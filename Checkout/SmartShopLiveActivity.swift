//
//  SmartShopLiveActivity.swift
//  Checkout
//
//  App-side integration for the Smart Shop Live Activity.
//

import ActivityKit
import AppIntents
import Foundation

extension Notification.Name {
    static let completeSmartShopItem = Notification.Name("completeSmartShopItem")
}

struct CompleteSmartShopItemIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Complete Smart Shop Item"

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
        // Replace this notification with a call into your shared shopping-list repository when one is available.
        await MainActor.run {
            NotificationCenter.default.post(name: .completeSmartShopItem, object: currentItemId)
        }
        return .result()
    }
}

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
    }

    let storeName: String
    let shoppingListId: String
}

@MainActor
enum SmartShopLiveActivityManager {
    static let shoppingListId = "active-smart-shop-list"

    static func sync(with items: [ShoppingListItem]) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        let activeItems = items.filter { !$0.isChecked }
        let completedCount = items.count - activeItems.count

        guard let currentItem = activeItems.first else {
            await showCompletedTrip(totalCount: items.count)
            return
        }

        let state = ShopLiveAttributes.ContentState(
            itemName: currentItem.name,
            itemDetail: detail(for: currentItem),
            aisle: currentItem.aisle,
            bay: currentItem.bay,
            thumbnailIdentifier: currentItem.imageName,
            completedCount: completedCount,
            totalCount: items.count,
            currentItemId: currentItem.id.uuidString,
            upcomingItems: activeItems.dropFirst().map(snapshot(for:)),
            isConfirming: false
        )
        let content = ActivityContent(state: state, staleDate: nil)

        if let activity = Activity<ShopLiveAttributes>.activities.first(where: {
            $0.attributes.shoppingListId == shoppingListId
        }) {
            await activity.update(content)
            return
        }

        let attributes = ShopLiveAttributes(
            storeName: "E. Charlotte Lowe's",
            shoppingListId: shoppingListId
        )

        do {
            _ = try Activity.request(attributes: attributes, content: content)
        } catch {
            // Connect this error to app analytics or user-facing messaging as needed.
            print("Unable to start Smart Shop Live Activity: \(error)")
        }
    }

    static func showCompletedTrip(totalCount: Int) async {
        let finalState = ShopLiveAttributes.ContentState(
            itemName: "Shopping Complete",
            itemDetail: "\(totalCount) of \(totalCount) items collected",
            aisle: "--",
            bay: "--",
            thumbnailIdentifier: "",
            completedCount: totalCount,
            totalCount: totalCount,
            currentItemId: "complete",
            upcomingItems: [],
            isConfirming: false
        )

        for activity in Activity<ShopLiveAttributes>.activities where activity.attributes.shoppingListId == shoppingListId {
            await activity.update(ActivityContent(state: finalState, staleDate: nil))
        }
    }

    private static func snapshot(for item: ShoppingListItem) -> ShopLiveItemSnapshot {
        ShopLiveItemSnapshot(
            id: item.id.uuidString,
            name: item.name,
            detail: detail(for: item),
            aisle: item.aisle,
            bay: item.bay,
            thumbnailIdentifier: item.imageName
        )
    }

    private static func detail(for item: ShoppingListItem) -> String {
        item.detail
    }
}
