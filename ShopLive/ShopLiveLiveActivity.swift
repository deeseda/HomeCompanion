//
//  ShopLiveLiveActivity.swift
//  ShopLive
//
//  Created by Derrick Deese on 6/7/26.
//

import ActivityKit
import AppIntents
import WidgetKit
import SwiftUI

struct ShopLiveItemSnapshot: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let detail: String
    let aisle: String
    let bay: String
    let thumbnailIdentifier: String
}

struct ShopLiveAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var itemName: String
        var itemDetail: String
        var aisle: String
        var bay: String
        var thumbnailIdentifier: String
        var completedCount: Int
        var totalCount: Int
        var currentItemId: String
        var upcomingItems: [ShopLiveItemSnapshot]
        var isConfirming: Bool

        var isComplete: Bool {
            currentItemId == "complete" || completedCount >= totalCount
        }

        var locationText: String {
            guard !isComplete else { return "Shopping Complete" }
            let location = bay.first?.isNumber == true ? "Bay \(bay)" : bay
            return "Aisle \(aisle) • \(location)"
        }

        var compactLocationText: String {
            guard !isComplete else { return "Complete" }
            return bay.first?.isNumber == true ? "A\(aisle) B\(bay)" : "Aisle \(aisle)"
        }

        var progressText: String {
            isComplete
                ? "\(totalCount) of \(totalCount) items collected"
                : "\(completedCount) of \(totalCount) items"
        }

        var counterText: String {
            "\(completedCount)/\(totalCount) items"
        }
    }

    let storeName: String
    let shoppingListId: String
}

struct CompleteSmartShopItemIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Complete Smart Shop Item"
    static var description = IntentDescription("Marks the current Smart Shop item complete and advances the Live Activity.")

    @Parameter(title: "Shopping List ID")
    var shoppingListId: String

    @Parameter(title: "Current Item ID")
    var currentItemId: String

    init() {
        shoppingListId = ""
        currentItemId = ""
    }

    init(shoppingListId: String, currentItemId: String) {
        self.shoppingListId = shoppingListId
        self.currentItemId = currentItemId
    }

    func perform() async throws -> some IntentResult {
        for activity in Activity<ShopLiveAttributes>.activities where activity.attributes.shoppingListId == shoppingListId {
            let state = activity.content.state
            guard state.currentItemId == currentItemId else { continue }

            var confirmingState = state
            confirmingState.isConfirming = true
            await activity.update(ActivityContent(state: confirmingState, staleDate: nil))

            try? await Task.sleep(for: .milliseconds(650))

            var remainingItems = state.upcomingItems
            let nextCompletedCount = min(state.completedCount + 1, state.totalCount)
            let nextItem = remainingItems.isEmpty ? nil : remainingItems.removeFirst()

            let nextState = ShopLiveAttributes.ContentState(
                itemName: nextItem?.name ?? "Shopping Complete",
                itemDetail: nextItem?.detail ?? "\(state.totalCount) of \(state.totalCount) items collected",
                aisle: nextItem?.aisle ?? "--",
                bay: nextItem?.bay ?? "--",
                thumbnailIdentifier: nextItem?.thumbnailIdentifier ?? state.thumbnailIdentifier,
                completedCount: nextCompletedCount,
                totalCount: state.totalCount,
                currentItemId: nextItem?.id ?? "complete",
                upcomingItems: remainingItems,
                isConfirming: false
            )

            await activity.update(ActivityContent(state: nextState, staleDate: nil))
        }

        return .result()
    }
}

struct ShopLiveLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ShopLiveAttributes.self) { context in
            SmartShopLiveActivityView(context: context)
                .activityBackgroundTint(Color(red: 0.0, green: 0.19, blue: 0.42))
                .activitySystemActionForegroundColor(.white)
                .widgetURL(deepLinkURL(for: context))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 5) {
                        if !context.state.isComplete {
                            Text("NEXT STOP")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(.secondary)
                        }
                        Text(context.state.locationText)
                            .font(.headline.weight(.bold))
                            .lineLimit(1)
                    }
                    .id(context.state.currentItemId)
                    .transition(.push(from: .trailing))
                    .animation(.snappy(duration: 0.3, extraBounce: 0.05), value: context.state.currentItemId)
                }

                DynamicIslandExpandedRegion(.trailing) {
                    if context.state.isComplete {
                        Link(destination: deepLinkURL(for: context)!) {
                            Text("Open List")
                                .font(.caption.weight(.bold))
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                    } else {
                        Button(intent: CompleteSmartShopItemIntent(
                            shoppingListId: context.attributes.shoppingListId,
                            currentItemId: context.state.currentItemId
                        )) {
                            SmartShopCompletionIcon(isConfirming: context.state.isConfirming, size: 30)
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                }

                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 12) {
                        if !context.state.isComplete {
                            SmartShopThumbnail(identifier: context.state.thumbnailIdentifier, size: 34)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            if !context.state.isComplete {
                                Text(context.state.itemName)
                                    .font(.subheadline.weight(.semibold))
                                    .lineLimit(2)
                            }
                            Text(context.state.progressText)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .id(context.state.currentItemId)
                    .transition(.push(from: .trailing))
                    .animation(.snappy(duration: 0.3, extraBounce: 0.05), value: context.state.currentItemId)
                }
            } compactLeading: {
                Text("\(context.state.completedCount)/\(context.state.totalCount)")
                    .font(.caption2.weight(.bold))
            } compactTrailing: {
                Text(context.state.compactLocationText)
                    .font(.caption2.weight(.bold))
            } minimal: {
                Text("\(context.state.completedCount)")
                    .font(.caption2.weight(.bold))
            }
            .widgetURL(deepLinkURL(for: context))
            .keylineTint(.blue)
        }
    }

    private func deepLinkURL(for context: ActivityViewContext<ShopLiveAttributes>) -> URL? {
        URL(string: "storemode://shopping-list/\(context.attributes.shoppingListId)?item=\(context.state.currentItemId)")
    }
}

private struct SmartShopLiveActivityView: View {
    let context: ActivityViewContext<ShopLiveAttributes>

    var body: some View {
        Group {
            if context.state.isComplete {
                completedLayout
            } else {
                activeLayout
            }
        }
        .id(context.state.currentItemId)
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
        .animation(.snappy(duration: 0.4, extraBounce: 0.05), value: context.state.currentItemId)
        .padding(16)
        .background {
            Color(red: 0.0, green: 0.19, blue: 0.42)
                .ignoresSafeArea()
        }
    }

    private var activeLayout: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .firstTextBaseline) {
                    Text("NEXT STOP")

                    Spacer(minLength: 12)

                    Text(context.state.counterText)
                        .contentTransition(.numericText())
                }
                .font(.system(size: 11, weight: .semibold))
                .tracking(0.06)
                .foregroundStyle(.white.opacity(0.8))
                .lineLimit(1)

                Text(context.state.locationText)
                    .font(.system(size: 20, weight: .semibold))
                    .tracking(-0.45)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            HStack(alignment: .bottom, spacing: 16) {
                HStack(alignment: .top, spacing: 12) {
                    SmartShopThumbnail(identifier: context.state.thumbnailIdentifier, size: 44)

                    Text(context.state.itemName)
                        .font(.system(size: 15, weight: .regular))
                        .tracking(-0.23)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Button(intent: CompleteSmartShopItemIntent(
                    shoppingListId: context.attributes.shoppingListId,
                    currentItemId: context.state.currentItemId
                )) {
                    SmartShopCompletionIcon(isConfirming: context.state.isConfirming, size: 36)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var completedLayout: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(context.state.locationText)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            HStack {
                Text(context.state.progressText)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.8))

                Spacer()

                Link(destination: deepLinkURL) {
                    Text("Open List")
                        .font(.subheadline.weight(.bold))
                        .padding(.horizontal, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundStyle(Color(red: 0.0, green: 0.19, blue: 0.42))
            }
        }
    }

    private var deepLinkURL: URL {
        URL(string: "storemode://shopping-list/\(context.attributes.shoppingListId)?item=\(context.state.currentItemId)")!
    }
}

private struct SmartShopCompletionIcon: View {
    let isConfirming: Bool
    let size: CGFloat

    var body: some View {
        Image(systemName: isConfirming ? "checkmark.circle.fill" : "checkmark")
            .font(.system(size: size * 0.58, weight: .semibold))
            .foregroundStyle(.white)
            .contentTransition(.symbolEffect(.replace))
            .symbolEffect(.bounce, value: isConfirming)
            .scaleEffect(isConfirming ? 1.12 : 1)
            .animation(.spring(duration: 0.25, bounce: 0.45), value: isConfirming)
            .sensoryFeedback(.impact(weight: .light, intensity: 0.7), trigger: isConfirming)
            .frame(width: size, height: size)
            .background(Color(red: 0.0, green: 0.53, blue: 1.0), in: Circle())
            .contentShape(Circle())
            .accessibilityLabel(isConfirming ? "Item collected" : "Mark item collected")
    }
}

private struct SmartShopThumbnail: View {
    let identifier: String
    let size: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.white)

            // Replace this placeholder with an App Group cached image or item-specific extension asset later.
            Image("KobaltDrill")
                .resizable()
                .scaledToFit()
                .padding(4)
        }
        .frame(width: size, height: size)
    }
}

extension ShopLiveAttributes {
    fileprivate static var preview: ShopLiveAttributes {
        ShopLiveAttributes(storeName: "E. Charlotte Lowe's", shoppingListId: "preview-list")
    }
}

extension ShopLiveAttributes.ContentState {
    fileprivate static var drill: ShopLiveAttributes.ContentState {
        ShopLiveAttributes.ContentState(
            itemName: "Kobalt 24-volt 1/2-in Keyless Brushless Cordless Drill (1-Batteries Included, and Charger Included)",
            itemDetail: "Kobalt 24-volt 1/2-in Keyless Brushless Cordless Drill (1-Batteries Included, a...",
            aisle: "66",
            bay: "Endcap Front",
            thumbnailIdentifier: "KobaltDrill",
            completedCount: 2,
            totalCount: 6,
            currentItemId: "kobalt-drill",
            upcomingItems: [
                ShopLiveItemSnapshot(
                    id: "lumber",
                    name: "2-in x 4-in x 4-ft #2 Prime Pine Lumber",
                    detail: "4 ft",
                    aisle: "20",
                    bay: "8",
                    thumbnailIdentifier: "Lumber"
                )
            ],
            isConfirming: false
        )
    }

    fileprivate static var lumber: ShopLiveAttributes.ContentState {
        ShopLiveAttributes.ContentState(
            itemName: "2-in x 4-in x 4-ft #2 Prime Pine Lumber",
            itemDetail: "4 ft",
            aisle: "20",
            bay: "8",
            thumbnailIdentifier: "Lumber",
            completedCount: 19,
            totalCount: 42,
            currentItemId: "lumber",
            upcomingItems: [],
            isConfirming: false
        )
    }

    fileprivate static var complete: ShopLiveAttributes.ContentState {
        ShopLiveAttributes.ContentState(
            itemName: "Shopping Complete",
            itemDetail: "42 of 42 items collected",
            aisle: "--",
            bay: "--",
            thumbnailIdentifier: "",
            completedCount: 42,
            totalCount: 42,
            currentItemId: "complete",
            upcomingItems: [],
            isConfirming: false
        )
    }
}

#Preview("Lock Screen", as: .content, using: ShopLiveAttributes.preview) {
    ShopLiveLiveActivity()
} contentStates: {
    ShopLiveAttributes.ContentState.drill
    ShopLiveAttributes.ContentState.lumber
}

#Preview("Shopping Complete", as: .content, using: ShopLiveAttributes.preview) {
    ShopLiveLiveActivity()
} contentStates: {
    ShopLiveAttributes.ContentState.complete
}

#Preview("Dynamic Island Compact", as: .dynamicIsland(.compact), using: ShopLiveAttributes.preview) {
    ShopLiveLiveActivity()
} contentStates: {
    ShopLiveAttributes.ContentState.drill
}

#Preview("Dynamic Island Expanded", as: .dynamicIsland(.expanded), using: ShopLiveAttributes.preview) {
    ShopLiveLiveActivity()
} contentStates: {
    ShopLiveAttributes.ContentState.drill
}
