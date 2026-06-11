//
//  ShoppingListView.swift
//  Checkout
//
//  Created by Derrick Deese on 6/5/26.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ShoppingListItem: Identifiable {
    let id = UUID()
    let name: String
    var detail: String = "In-store item"
    let department: String
    let aisle: String
    let bay: String
    let locationLabel: String
    let imageName: String
    let mapLocation: CGPoint
    var isChecked: Bool = false
}

struct ShoppingListView: View {
    struct AddableItem: Identifiable {
        let id = UUID()
        let name: String
        let department: String
        let aisle: String
        let bay: String
        let locationLabel: String
        let imageName: String
        let mapLocation: CGPoint
    }

    private struct AddedFeedback: Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }

    private struct StoreZone: Identifiable {
        let id = UUID()
        let name: String
        let frame: CGRect
    }

    private struct StoreAisle: Identifiable {
        let id: Int
        let number: Int
        let frame: CGRect
    }

    private enum Segment: String, CaseIterable, Identifiable {
        case shoppingList = "Shopping List"
        case deals = "Deals"

        var id: Self { self }
    }

    private enum SortOption: String, CaseIterable, Identifiable {
        case smartShop = "Smart Shop"
        case recentlyAdded = "Recently Added"

        var id: Self { self }
    }

    @Environment(\.dismiss) private var dismiss
    @State private var selectedSegment: Segment = .shoppingList
    @State private var selectedSortOption: SortOption = .smartShop
    @State private var isSheetPresented = true
    @State private var hasPresentedPrimarySheet = false
    @State private var isAddItemSheetPresented = false
    @State private var isMemberIDSheetPresented = false
    @State private var selectedDetent: PresentationDetent = .medium
    @State private var isCompletedExpanded = false
    @State private var isSortDialogPresented = false
    @State private var focusedItemID: ShoppingListItem.ID?
    @State private var addedFeedback: AddedFeedback?
    @GestureState private var mapDragTranslation: CGSize = .zero
    @State private var mapViewportSize: CGSize = .zero
    @State private var mapScale: CGFloat = 1
    @State private var mapOffset: CGSize = .zero
    @State private var customerHeadingDegrees: Double = 35
    @State private var items: [ShoppingListItem] = [
        ShoppingListItem(
            name: "Kobalt 24-volt 1/2-in Keyless Brushless Cordless Drill (1-Batteries Included, and Charger Included)",
            detail: "Kobalt 24-volt 1/2-in Keyless Brushless Cordless Drill (1-Batteries Included, a...",
            department: "",
            aisle: "66",
            bay: "Endcap Front",
            locationLabel: "Aisle 66  Endcap Front",
            imageName: "KobaltDrill",
            mapLocation: CGPoint(x: 0.70, y: 0.73)
        ),
        ShoppingListItem(
            name: "2-in x 4-in x 4-ft #2 Prime Pine Lumber",
            detail: "2-in x 4-in x 4-ft #2 Prime Pine Lumber",
            department: "",
            aisle: "20",
            bay: "8",
            locationLabel: "Aisle 20  Bay 8",
            imageName: "Lumber",
            mapLocation: CGPoint(x: 0.56, y: 0.37)
        ),
        ShoppingListItem(
            name: "Deck Plus #10 x 3-in Wood to wood Deck Screws 800-Per Box",
            detail: "Deck Plus #10 x 3-in Wood to wood Deck Screws 800-Per Box",
            department: "",
            aisle: "16",
            bay: "17",
            locationLabel: "Aisle 16  Bay 17",
            imageName: "Screws",
            mapLocation: CGPoint(x: 0.42, y: 0.38)
        ),
        ShoppingListItem(
            name: "Miracle-Gro Organic 1.5 Cubic feet All-purpose Organic Raised bed soil",
            detail: "Miracle-Gro Organic 1.5 Cubic feet All-purpose Organic Raised bed soil",
            department: "Garden Center",
            aisle: "3",
            bay: "Endcap Front",
            locationLabel: "Aisle 3  Endcap Front",
            imageName: "Miracle",
            mapLocation: CGPoint(x: 0.18, y: 0.18)
        ),
        ShoppingListItem(
            name: "Scotts Nature Scapes Brown Mulch",
            detail: "Scotts Nature Scapes Brown Mulch",
            department: "Garden Center",
            aisle: "3",
            bay: "18",
            locationLabel: "Aisle 3  Bay 18",
            imageName: "mulch",
            mapLocation: CGPoint(x: 0.24, y: 0.24),
            isChecked: true
        ),
        ShoppingListItem(
            name: "Project Source 25-ft Tape Measure",
            detail: "Project Source 25-ft Tape Measure",
            department: "Tools",
            aisle: "69",
            bay: "8",
            locationLabel: "Aisle 69  Bay 8",
            imageName: "tool",
            mapLocation: CGPoint(x: 0.72, y: 0.71),
            isChecked: true
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                mapLayer
                    .opacity(hasPresentedPrimarySheet ? 1 : 0)
            }
            .ignoresSafeArea(edges: .bottom)
            .background(Color(.systemBackground))
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $isSheetPresented, onDismiss: { dismiss() }) {
                NavigationStack {
                    sheetContent
                        .navigationBarTitleDisplayMode(.inline)
                        .overlay {
                            if let addedFeedback {
                                addedFeedbackOverlay(addedFeedback)
                                    .transition(.scale(scale: 0.94).combined(with: .opacity))
                            }
                        }
                        .safeAreaBar(edge: .bottom, alignment: .trailing, spacing: 0) {
                            Button {
                                isAddItemSheetPresented = true
                            } label: {
                                Image(systemName: "plus")
                            }
                            .buttonStyle(.glassProminent)
                            .buttonBorderShape(.circle)
                            .accessibilityLabel("Add item")
                            .padding(.trailing, 16)
                            .padding(.vertical, 8)
                        }
                        .scrollEdgeEffectStyle(.soft, for: .bottom)
                        .animation(.snappy(duration: 0.22), value: addedFeedback?.id)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                VStack(spacing: 0) {
                                    Text("Store Mode")
                                        .font(.headline)
                                    Text("Central Charlotte")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    isSheetPresented = false
                                } label: {
                                    Image(systemName: "xmark")
                                }
                            }

                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    isMemberIDSheetPresented = true
                                } label: {
                                    Image(systemName: "qrcode")
                                }
                                .accessibilityLabel("Show member ID")
                            }

                        }
                        .sheet(isPresented: $isAddItemSheetPresented) {
                            AddItemSheet(
                                catalogItems: searchableCatalogItems,
                                cartItems: cartItems,
                                savedLists: savedCustomerLists,
                                onSelect: { selectedItem in
                                    addItem(selectedItem)
                                    isAddItemSheetPresented = false
                                    showAddedFeedback(for: 1)
                                },
                                onSelectMany: { selectedItems in
                                    addItems(selectedItems)
                                    isAddItemSheetPresented = false
                                    showAddedFeedback(for: selectedItems.count)
                                }
                            )
                        }
                        .sheet(isPresented: $isMemberIDSheetPresented) {
                            MemberIDSheet(memberID: "8410 2946 5183")
                        }
                }
                .onAppear {
                    hasPresentedPrimarySheet = true
                }
                .presentationDetents([.medium, .large], selection: $selectedDetent)
                .presentationDragIndicator(.visible)
                .presentationBackground(Color.white)
                .presentationBackgroundInteraction(.enabled)
                .presentationContentInteraction(.resizes)
                .presentationCornerRadius(38)
            }
        }
        .task {
            // Replace this snapshot sync with your shared shopping-list store when the model moves out of this view.
            await SmartShopLiveActivityManager.sync(with: items)
        }
        .onChange(of: items.map { "\($0.id.uuidString)-\($0.isChecked)" }) { _, _ in
            Task {
                await SmartShopLiveActivityManager.sync(with: items)
            }
        }
        .onChange(of: activeItems.map(\.id)) { _, _ in
            centerMapOnNextStop()
        }
        .task {
            for await notification in NotificationCenter.default.notifications(named: .completeSmartShopItem) {
                guard
                    let idString = notification.object as? String,
                    let id = UUID(uuidString: idString),
                    let index = items.firstIndex(where: { $0.id == id })
                else { continue }

                items[index].isChecked = true
            }
        }
    }

    private var mapLayer: some View {
        GeometryReader { geometry in
            let mapSize = CGSize(width: geometry.size.width * 1.4, height: geometry.size.height * 0.62)

            ZStack(alignment: .topLeading) {
                LinearGradient(
                    colors: [
                        Color(red: 0.97, green: 0.98, blue: 1.00),
                        Color(red: 0.92, green: 0.95, blue: 0.99)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                    .ignoresSafeArea()

                ZStack {
                    storeMapCanvas(size: mapSize)
                }
                .frame(width: mapSize.width, height: mapSize.height)
                .scaleEffect(mapScale, anchor: .topLeading)
                .offset(
                    x: mapOffset.width + mapDragTranslation.width,
                    y: mapOffset.height + mapDragTranslation.height + 88
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .updating($mapDragTranslation) { value, state, _ in
                            state = value.translation
                        }
                        .onEnded { value in
                            mapOffset.width += value.translation.width
                            mapOffset.height += value.translation.height
                        }
                )
                .animation(.snappy(duration: 0.22), value: mapScale)
                .animation(.snappy(duration: 0.22), value: mapOffset)

            }
            .onAppear {
                mapViewportSize = geometry.size
                centerMapOnNextStop(in: geometry.size)
            }
            .onChange(of: geometry.size) { _, newValue in
                mapViewportSize = newValue
                centerMapOnNextStop(in: newValue)
            }
        }
    }

    private var sheetContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                Picker("Browse Section", selection: $selectedSegment) {
                    ForEach(Segment.allCases) { segment in
                        Text(segment.rawValue).tag(segment)
                    }
                }
                .pickerStyle(.segmented)

                if selectedSegment == .shoppingList {
                    shoppingListHeader
                    shoppingListContent
                    completedSection
                    if let outOfStockItem {
                        outOfStockCard(outOfStockItem)
                    }
                } else {
                    dealsContent
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 48)
        }
        .scrollIndicators(.hidden)
    }

    private var shoppingListHeader: some View {
        HStack {
            Button {
                isSortDialogPresented = true
            } label: {
                HStack(spacing: 4) {
                    Text(selectedSortOption.rawValue)
                        .font(.headline)
                    Image(systemName: "chevron.down.circle")
                        .font(.caption)
                }
                .foregroundStyle(Color.brandBlue)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("\(completedItems.count)/\(items.count) items")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .confirmationDialog("Sort Shopping List", isPresented: $isSortDialogPresented, titleVisibility: .visible) {
            Button(selectedSortOption == .smartShop ? "Smart Shop ✓" : "Smart Shop") {
                selectedSortOption = .smartShop
            }

            Button(selectedSortOption == .recentlyAdded ? "Recently Added ✓" : "Recently Added") {
                selectedSortOption = .recentlyAdded
            }
        } message: {
            Text("Smart Shop uses the most efficient route starting from your current location.")
        }
    }

    private var shoppingListContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let nextStop = sortedActiveItems.first {
                VStack(alignment: .leading, spacing: 8) {
                    Text("NEXT STOP")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)

                    activeItemRow(nextStop, isLast: true)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: .black.opacity(0.12), radius: 20, y: 8)
                }
            }

            LazyVStack(spacing: 0) {
                ForEach(Array(sortedActiveItems.dropFirst().enumerated()), id: \.element.id) { index, item in
                    activeItemRow(item, isLast: index == sortedActiveItems.dropFirst().count - 1)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteItem(withID: item.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .background(Color.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.12), radius: 40, y: 8)
        }
    }

    private var dealsContent: some View {
        VStack {
            Spacer()
            ContentUnavailableView(
                "Deals",
                systemImage: "tag",
                description: Text("Store deals will appear here.")
            )
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var completedSection: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.snappy(duration: 0.2)) {
                    isCompletedExpanded.toggle()
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark")
                        .font(.title3.weight(.semibold))
                    Text("Collected (\(completedItems.count))")
                        .font(.headline)
                    Spacer()
                    Image(systemName: isCompletedExpanded ? "chevron.up.circle" : "chevron.down.circle")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
                .foregroundStyle(Color(red: 0.38, green: 0.40, blue: 0.44))
                .padding(.horizontal, 16)
                .frame(height: 60)
            }
            .buttonStyle(.plain)

            if isCompletedExpanded, !completedItems.isEmpty {
                Divider()
                    .padding(.horizontal, 16)

                VStack(spacing: 0) {
                    ForEach(Array(completedItems.enumerated()), id: \.element.id) { index, item in
                        completedItemRow(item, isLast: index == completedItems.count - 1)
                    }
                }
            }
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var storeZones: [StoreZone] {
        [
            StoreZone(name: "Garden Center", frame: CGRect(x: 0.035, y: 0.10, width: 0.16, height: 0.60)),
            StoreZone(name: "Plumbing", frame: CGRect(x: 0.22, y: 0.08, width: 0.18, height: 0.12)),
            StoreZone(name: "Electrical", frame: CGRect(x: 0.42, y: 0.08, width: 0.16, height: 0.12)),
            StoreZone(name: "Appliances", frame: CGRect(x: 0.60, y: 0.08, width: 0.17, height: 0.12)),
            StoreZone(name: "Building Materials", frame: CGRect(x: 0.79, y: 0.08, width: 0.17, height: 0.33)),
            StoreZone(name: "Lumber", frame: CGRect(x: 0.79, y: 0.44, width: 0.17, height: 0.29)),
            StoreZone(name: "Tools", frame: CGRect(x: 0.57, y: 0.70, width: 0.20, height: 0.12)),
            StoreZone(name: "Seasonal", frame: CGRect(x: 0.22, y: 0.70, width: 0.18, height: 0.12))
        ]
    }

    private var storeAisles: [StoreAisle] {
        let columns = 11
        return (0..<columns).map { index in
            StoreAisle(
                id: index,
                number: 12 + (index * 4),
                frame: CGRect(
                    x: 0.235 + (CGFloat(index) * 0.047),
                    y: 0.25,
                    width: 0.025,
                    height: 0.36
                )
            )
        }
    }

    private var customerLocation: CGPoint {
        CGPoint(x: 0.49, y: 0.77)
    }

    private var activeItems: [ShoppingListItem] {
        items.filter { !$0.isChecked }
    }

    private var outOfStockItem: ShoppingListItem? {
        items.first { $0.imageName == "Miracle" }
    }

    private var completedItems: [ShoppingListItem] {
        items.filter(\.isChecked)
    }

    private var searchableCatalogItems: [AddableItem] {
        [
            AddableItem(
                name: "CRAFTSMAN 16-oz Smooth-Face Claw Hammer",
                department: "Hardware",
                aisle: "17",
                bay: "2",
                locationLabel: "Aisle 17  Bay 2",
                imageName: "Screws",
                mapLocation: CGPoint(x: 0.50, y: 0.37)
            ),
            AddableItem(
                name: "SharkBite 1/2-in Push-to-Connect Brass Elbow",
                department: "Rough Plumbing",
                aisle: "42",
                bay: "5",
                locationLabel: "Aisle 42  Bay 5",
                imageName: "Lumber",
                mapLocation: CGPoint(x: 0.16, y: 0.19)
            ),
            AddableItem(
                name: "Project Source 25-ft Tape Measure",
                department: "Tools",
                aisle: "69",
                bay: "8",
                locationLabel: "Aisle 69  Bay 8",
                imageName: "KobaltDrill",
                mapLocation: CGPoint(x: 0.72, y: 0.71)
            )
        ]
    }

    private var cartItems: [AddableItem] {
        [
            AddableItem(
                name: "Little Giant Ladders Multi M22, 22-ft Reach Type 1A - 300 lbs. Load Capacity Telescoping Multi-Position Ladder",
                department: "",
                aisle: "17",
                bay: "18",
                locationLabel: "Aisle 17  Bay 18",
                imageName: "ladder",
                mapLocation: CGPoint(x: 0.45, y: 0.42)
            ),
            AddableItem(
                name: "Lowe's 1.5 -Pint Blue Lithodora 1 -Pack",
                department: "Garden Center",
                aisle: "3",
                bay: "1",
                locationLabel: "Aisle 3  Bay 1",
                imageName: "plant",
                mapLocation: CGPoint(x: 0.17, y: 0.17)
            )
        ]
    }

    private var savedCustomerLists: [AddItemSheet.SavedCustomerList] {
        [
            AddItemSheet.SavedCustomerList(
                name: "Kitchen Renovation",
                itemCount: 13,
                items: [
                    AddableItem(
                        name: "Severe Weather 5/8-in Pressure Treated Deck Board",
                        department: "Lumber",
                        aisle: "20",
                        bay: "14",
                        locationLabel: "Aisle 20  Bay 14",
                        imageName: "Lumber",
                        mapLocation: CGPoint(x: 0.58, y: 0.39)
                    ),
                    AddableItem(
                        name: "Deck Plus #10 x 3-in Wood to Wood Deck Screws 800-Per Box",
                        department: "",
                        aisle: "16",
                        bay: "17",
                        locationLabel: "Aisle 16  Bay 17",
                        imageName: "Screws",
                        mapLocation: CGPoint(x: 0.42, y: 0.38)
                    ),
                    AddableItem(
                        name: "Project Source 25-ft Tape Measure",
                        department: "Tools",
                        aisle: "69",
                        bay: "8",
                        locationLabel: "Aisle 69  Bay 8",
                        imageName: "KobaltDrill",
                        mapLocation: CGPoint(x: 0.72, y: 0.71)
                    )
                ]
            ),
            AddItemSheet.SavedCustomerList(
                name: "Garden Project",
                itemCount: 5,
                items: [
                    AddableItem(
                        name: "Miracle-Gro Organic Raised Bed Soil",
                        department: "Garden Center",
                        aisle: "3",
                        bay: "12",
                        locationLabel: "Aisle 3  Bay 12",
                        imageName: "Miracle",
                        mapLocation: CGPoint(x: 0.22, y: 0.22)
                    ),
                    AddableItem(
                        name: "Scotts Nature Scapes Mulch",
                        department: "Garden Center",
                        aisle: "3",
                        bay: "18",
                        locationLabel: "Aisle 3  Bay 18",
                        imageName: "Miracle",
                        mapLocation: CGPoint(x: 0.24, y: 0.24)
                    )
                ]
            ),
            AddItemSheet.SavedCustomerList(
                name: "Paint Supplies",
                itemCount: 2,
                items: cartItems
            )
        ]
    }

    private var sortedActiveItems: [ShoppingListItem] {
        switch selectedSortOption {
        case .smartShop:
            return activeItems
        case .recentlyAdded:
            return activeItems
        }
    }

    private func toggleItem(withID id: ShoppingListItem.ID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].isChecked.toggle()
        if items[index].isChecked {
            focusedItemID = nil
        }
    }

    private func restoreItem(withID id: ShoppingListItem.ID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].isChecked = false
    }

    private func deleteItem(withID id: ShoppingListItem.ID) {
        items.removeAll { $0.id == id }
        if focusedItemID == id {
            focusedItemID = nil
        }
    }

    private func addItem(_ item: AddableItem) {
        items.append(
            ShoppingListItem(
                name: item.name,
                department: item.department,
                aisle: item.aisle,
                bay: item.bay,
                locationLabel: item.locationLabel,
                imageName: item.imageName,
                mapLocation: item.mapLocation
            )
        )
    }

    private func addItems(_ newItems: [AddableItem]) {
        items.append(contentsOf: newItems.map {
            ShoppingListItem(
                name: $0.name,
                department: $0.department,
                aisle: $0.aisle,
                bay: $0.bay,
                locationLabel: $0.locationLabel,
                imageName: $0.imageName,
                mapLocation: $0.mapLocation
            )
        })
    }

    private func showAddedFeedback(for count: Int) {
        guard count > 0 else { return }

        let feedback = AddedFeedback(
            title: "Added",
            message: count == 1
                ? "This item was added to your Shopping List."
                : "\(count) items were added to your Shopping List."
        )

        addedFeedback = feedback

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.8))
            if addedFeedback?.id == feedback.id {
                withAnimation(.snappy(duration: 0.2)) {
                    addedFeedback = nil
                }
            }
        }
    }

    private func storeMapCanvas(size: CGSize) -> some View {
        ZStack {
            storeFootprint(size: size)

            ForEach(storeZones) { zone in
                mapBlock(
                    frame: zone.frame,
                    size: size,
                    fill: zoneFill(for: zone.name),
                    stroke: zoneStroke(for: zone.name),
                    cornerRadius: 8
                )
            }

            checkoutArea(size: size)

            ForEach(storeAisles) { aisle in
                mapBlock(
                    frame: aisle.frame,
                    size: size,
                    fill: Color(red: 0.79, green: 0.82, blue: 0.88),
                    stroke: Color.white.opacity(0.72),
                    cornerRadius: 4
                )

                if mapScale >= 1.05 {
                    aisleNumber(aisle.number)
                        .position(
                            x: size.width * aisle.frame.midX,
                            y: size.height * (aisle.frame.minY - 0.025)
                        )
                }
            }

            ForEach(storeZones) { zone in
                if mapScale >= 0.95 {
                    Text(zone.name)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(Color(red: 0.09, green: 0.16, blue: 0.28).opacity(0.78))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.65)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                        .frame(width: size.width * zone.frame.width * 0.88)
                        .background(.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .position(
                            x: size.width * zone.frame.midX,
                            y: size.height * zone.frame.midY
                        )
                }
            }

            ForEach(sortedActiveItems) { item in
                if focusedItemID == item.id {
                    focusedItemMarker
                        .position(point(for: item.mapLocation, in: size))
                } else {
                    mapMarker(tint: Color(red: 0.0, green: 0.13, blue: 0.41))
                        .position(point(for: item.mapLocation, in: size))
                }
            }

            VStack(spacing: 4) {
                customerLocationMarker
                Text("You")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(Color(red: 0.09, green: 0.16, blue: 0.28))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(.white.opacity(0.86), in: Capsule())
            }
            .position(point(for: customerLocation, in: size))
        }
        .frame(width: size.width, height: size.height)
    }

    private func storeFootprint(size: CGSize) -> some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.99, green: 0.99, blue: 0.98),
                            Color(red: 0.93, green: 0.95, blue: 0.98)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(floorGrid(size: size))

            HStack(spacing: 5) {
                entranceMarker(title: "ENTRANCE", systemImage: "arrow.down.to.line")
                entranceMarker(title: "EXIT", systemImage: "arrow.up.from.line")
            }
            .position(x: size.width * 0.46, y: size.height * 0.965)
        }
        .padding(size.width * 0.018)
    }

    private func checkoutArea(size: CGSize) -> some View {
        let frame = CGRect(x: 0.39, y: 0.83, width: 0.29, height: 0.10)

        return ZStack {
            mapBlock(
                frame: frame,
                size: size,
                fill: Color(red: 0.78, green: 0.87, blue: 0.80),
                stroke: Color(red: 0.52, green: 0.70, blue: 0.56).opacity(0.55),
                cornerRadius: 8
            )

            Text("Checkout")
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(Color(red: 0.09, green: 0.22, blue: 0.12).opacity(0.78))
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(.white.opacity(0.68), in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                .position(x: size.width * frame.midX, y: size.height * frame.midY)
        }
    }

    private func mapBlock(
        frame: CGRect,
        size: CGSize,
        fill: Color,
        stroke: Color = Color.black.opacity(0.06),
        cornerRadius: CGFloat
    ) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(fill)
            .frame(width: size.width * frame.width, height: size.height * frame.height)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(stroke, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
            .position(x: size.width * frame.midX, y: size.height * frame.midY)
    }

    private func aisleNumber(_ number: Int) -> some View {
        Text("\(number)")
            .font(.system(size: 7, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 3)
            .padding(.vertical, 1)
            .background(Color.brandBlue, in: RoundedRectangle(cornerRadius: 3))
    }

    private func entranceMarker(title: String, systemImage: String) -> some View {
        VStack(spacing: 1) {
            Image(systemName: systemImage)
                .font(.system(size: 7, weight: .bold))
            Text(title)
                .font(.system(size: 5, weight: .bold))
        }
        .foregroundStyle(Color.brandBlue)
        .padding(.horizontal, 5)
        .padding(.vertical, 3)
        .background(.white, in: RoundedRectangle(cornerRadius: 3))
        .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.brandBlue.opacity(0.45)))
    }

    private func floorGrid(size: CGSize) -> some View {
        ZStack {
            ForEach(0..<10, id: \.self) { index in
                Rectangle()
                    .fill(Color.white.opacity(0.32))
                    .frame(width: 1, height: size.height * 0.88)
                    .position(
                        x: size.width * (0.10 + CGFloat(index) * 0.085),
                        y: size.height * 0.50
                    )
            }

            ForEach(0..<7, id: \.self) { index in
                Rectangle()
                    .fill(Color.white.opacity(0.28))
                    .frame(width: size.width * 0.88, height: 1)
                    .position(
                        x: size.width * 0.50,
                        y: size.height * (0.16 + CGFloat(index) * 0.105)
                    )
            }
        }
        .allowsHitTesting(false)
    }

    private func zoneFill(for name: String) -> Color {
        switch name {
        case "Garden Center":
            return Color(red: 0.80, green: 0.90, blue: 0.80)
        case "Tools":
            return Color(red: 0.80, green: 0.86, blue: 0.96)
        case "Lumber", "Building Materials":
            return Color(red: 0.88, green: 0.85, blue: 0.76)
        case "Seasonal":
            return Color(red: 0.90, green: 0.84, blue: 0.92)
        default:
            return Color(red: 0.84, green: 0.88, blue: 0.95)
        }
    }

    private func zoneStroke(for name: String) -> Color {
        switch name {
        case "Garden Center":
            return Color.brandGreen.opacity(0.30)
        case "Lumber", "Building Materials":
            return Color(red: 0.62, green: 0.50, blue: 0.28).opacity(0.28)
        default:
            return Color.brandBlue.opacity(0.16)
        }
    }

    private func activeItemRow(_ item: ShoppingListItem, isLast: Bool) -> some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.snappy(duration: 0.2)) {
                    toggleItem(withID: item.id)
                }
            } label: {
                Image(systemName: "circle")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(Color(.systemGray3))
                    .frame(width: 25, height: 22)
            }
            .buttonStyle(.plain)
            .frame(width: 25, height: 22)
            .padding(.leading, 16)
            .padding(.trailing, 16)

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    shoppingListLocationView(for: item)

                    Text(item.detail)
                        .font(.caption)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                itemThumbnail(item, size: 68)
                    .padding(.trailing, 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.trailing, 16)

            Spacer(minLength: 0)
        }
        .padding(.vertical, 20)
        .contentShape(Rectangle())
        .onTapGesture {
            centerMap(on: item)
        }
        .overlay(alignment: .bottom) {
            if !isLast {
                Divider()
                    .padding(.leading, 58)
            }
        }
    }

    private func completedItemRow(_ item: ShoppingListItem, isLast: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.headline)
                .foregroundStyle(.brandGreen)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                completedLocationView(for: item)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button("Add Back") {
                withAnimation(.snappy(duration: 0.2)) {
                    restoreItem(withID: item.id)
                }
            }
            .font(.subheadline.weight(.semibold))
            .buttonStyle(.plain)
            .foregroundStyle(.blue)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            if !isLast {
                Divider()
                    .padding(.leading, 18)
            }
        }
    }

    private func itemThumbnail(_ item: ShoppingListItem, size: CGFloat = 68) -> some View {
        Image(item.imageName)
            .resizable()
            .scaledToFit()
            .padding(item.imageName == "Miracle" ? 6 : 0)
            .frame(width: size, height: size)
            .background(item.imageName == "Miracle" ? Color.white : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private func outOfStockCard(_ item: ShoppingListItem) -> some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("1 item is out of stock at this store")
                    .font(.subheadline.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(red: 0.38, green: 0.40, blue: 0.44))

                Text("You can find a similar item in store or buy online")
                    .font(.subheadline)
                    .foregroundStyle(Color(red: 0.38, green: 0.40, blue: 0.44))
                    .multilineTextAlignment(.center)
            }

            Image("plant")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Button {
            } label: {
                Text("Find similar items in store")
                    .font(.headline)
                    .foregroundStyle(Color.brandBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 0.90, green: 0.92, blue: 0.96), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 24)
        .background(Color(red: 0.95, green: 0.95, blue: 0.97), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func mapMarker(tint: Color) -> some View {
        Circle()
            .fill(tint)
            .frame(width: 28, height: 28)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 3)
            )
            .overlay(
                Circle()
                    .stroke(tint.opacity(0.65), lineWidth: 2)
                    .padding(-3)
            )
            .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
    }

    private var focusedItemMarker: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.12, green: 0.42, blue: 0.89))

            Image(systemName: "mappin")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(width: 32, height: 32)
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 3)
        )
        .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
    }

    private var customerLocationMarker: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.12, green: 0.42, blue: 0.89))

            Image(systemName: "location.north.fill")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
                .rotationEffect(.degrees(customerHeadingDegrees))
        }
        .frame(width: 30, height: 30)
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 3)
        )
        .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
    }

    private func point(for normalizedPoint: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: size.width * normalizedPoint.x,
            y: size.height * normalizedPoint.y
        )
    }

    private func centerMap(on item: ShoppingListItem) {
        focusedItemID = item.id
        fitMap(customerLocation, item.mapLocation)
    }

    private func centerMapOnNextStop(in viewportSize: CGSize? = nil) {
        guard let nextStop = sortedActiveItems.first else { return }
        focusedItemID = nextStop.id
        fitMap(customerLocation, nextStop.mapLocation, viewportSize: viewportSize)
    }

    private func fitMap(_ firstLocation: CGPoint, _ secondLocation: CGPoint, viewportSize: CGSize? = nil) {
        let viewportSize = viewportSize ?? mapViewportSize
        guard viewportSize != .zero else { return }

        let mapSize = CGSize(
            width: viewportSize.width * 1.4,
            height: viewportSize.height * 0.62
        )
        let firstPoint = point(for: firstLocation, in: mapSize)
        let secondPoint = point(for: secondLocation, in: mapSize)
        let markerPadding: CGFloat = 64
        let visibleMapFrame = CGRect(
            x: 44,
            y: 104,
            width: max(viewportSize.width - 88, 1),
            height: max((viewportSize.height * 0.47) - 104, 1)
        )
        let contentWidth = abs(firstPoint.x - secondPoint.x) + markerPadding
        let contentHeight = abs(firstPoint.y - secondPoint.y) + markerPadding
        let targetScale = min(
            1.35,
            max(
                0.55,
                min(
                    visibleMapFrame.width / contentWidth,
                    visibleMapFrame.height / contentHeight
                )
            )
        )
        let mapMidpoint = CGPoint(
            x: (firstPoint.x + secondPoint.x) * 0.5,
            y: (firstPoint.y + secondPoint.y) * 0.5
        )

        withAnimation(.snappy(duration: 0.3)) {
            mapScale = targetScale
            mapOffset = CGSize(
                width: visibleMapFrame.midX - (mapMidpoint.x * targetScale),
                height: visibleMapFrame.midY - (mapMidpoint.y * targetScale) - 88
            )
        }
    }

    private func rowHeight(for item: ShoppingListItem) -> CGFloat {
        item.department.isEmpty ? 108 : 124
    }

    private func addedFeedbackOverlay(_ feedback: AddedFeedback) -> some View {
        VStack(spacing: 18) {
            booksAddedIcon

            VStack(spacing: 8) {
                Text(feedback.title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(feedback.message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 24)
        .frame(maxWidth: 280)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.14), radius: 18, y: 8)
        .allowsHitTesting(false)
    }

    private var booksAddedIcon: some View {
        Image(systemName: "text.badge.plus")
            .font(.system(size: 72, weight: .regular))
            .foregroundStyle(.primary.opacity(0.68))
            .frame(width: 116, height: 88)
    }

    @ViewBuilder
    private func shoppingListLocationView(for item: ShoppingListItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if !item.department.isEmpty {
                Text(item.department)
                    .font(.subheadline.weight(.semibold))
            }

            Text("Aisle \(item.aisle) • \(locationTrailingText(for: item))")
                .font(.subheadline.weight(.semibold))
        }
        .foregroundStyle(Color(red: 0.0, green: 0.13, blue: 0.41))
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func completedLocationView(for item: ShoppingListItem) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            if !item.department.isEmpty {
                Text(item.department)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 4) {
                Text("Aisle \(item.aisle)")
                    .font(.caption.weight(.semibold))
                Text(locationTrailingText(for: item))
                    .font(.caption)
            }
            .foregroundStyle(.secondary)
        }
    }

    private func locationTrailingText(for item: ShoppingListItem) -> String {
        let trimmedBay = item.bay.trimmingCharacters(in: .whitespacesAndNewlines)
        let startsWithDigit = trimmedBay.first?.isNumber == true
        return startsWithDigit ? "Bay \(trimmedBay)" : trimmedBay
    }
}

private struct MemberIDSheet: View {
    let memberID: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    qrCodeImage
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 265, height: 265)

                    Text("Show at checkout or scan with a hand scanner")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 240)

                    rewardsCard
                    paymentMethodRow
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 48)
            }
            .navigationTitle("Member ID & Pay")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("Close")
                }

                ToolbarItem(placement: .principal) {
                    Text("Member ID & Pay")
                        .font(.headline)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(38)
    }

    private var rewardsCard: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 0) {
                Text("mylowe's")
                    .font(.caption2.weight(.semibold))
                Text("Rewards")
                    .font(.caption.weight(.semibold))
            }
            .frame(width: 72, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text("Derrick Deese")
                    .font(.headline)
                Text("Earning 1x points per dollar spent")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "info.circle")
        }
        .foregroundStyle(.white)
        .padding(16)
        .background(Color.brandBlue, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var paymentMethodRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "creditcard")
                .foregroundStyle(Color.brandBlue)

            VStack(alignment: .leading, spacing: 0) {
                Text("Pay with Card")
                    .font(.subheadline)

                HStack(spacing: 3) {
                    Text("Visa *1234 •")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Applied")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.brandGreen)
                }
            }

            Spacer()

            Button("Change") {
            }
            .font(.footnote)
            .buttonStyle(.plain)
            .foregroundStyle(Color.brandBlue)
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 60)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var qrCodeImage: Image {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(memberID.utf8)
        filter.correctionLevel = "M"

        let context = CIContext()
        guard
            let outputImage = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: 12, y: 12)),
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        else {
            return Image(systemName: "qrcode")
        }

        return Image(decorative: cgImage, scale: 1)
    }
}

private struct AddItemSheet: View {
    private enum AddMode: String, CaseIterable, Identifiable {
        case list = "My Lists"
        case cart = "Cart"

        var id: Self { self }
    }

    struct SavedCustomerList: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let itemCount: Int
        let items: [ShoppingListView.AddableItem]

        static func == (lhs: SavedCustomerList, rhs: SavedCustomerList) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    let catalogItems: [ShoppingListView.AddableItem]
    let cartItems: [ShoppingListView.AddableItem]
    let savedLists: [SavedCustomerList]
    let onSelect: (ShoppingListView.AddableItem) -> Void
    let onSelectMany: ([ShoppingListView.AddableItem]) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selectedMode: AddMode = .list
    @State private var searchText = ""
    @State private var selectedDetent: PresentationDetent = .large
    @State private var selectedCartItemIDs = Set<ShoppingListView.AddableItem.ID>()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Picker("Add from", selection: $selectedMode) {
                    ForEach(AddMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                if !searchText.isEmpty {
                    searchResults
                } else {
                    switch selectedMode {
                    case .list:
                        savedListsCard
                    case .cart:
                        cartHeader
                        cartItemsCard
                    }
                }

                Spacer(minLength: 0)

                searchField
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 32)
            .background(Color.white)
            .navigationTitle("Add an item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    if selectedMode == .cart {
                        Button {
                            addSelectedCartItems()
                        } label: {
                            Image(systemName: "checkmark")
                        }
                        .buttonStyle(.glassProminent)
                        .buttonBorderShape(.circle)
                        .tint(.blue)
                        .disabled(selectedCartItemIDs.isEmpty)
                    }
                }
            }
            .navigationDestination(for: SavedCustomerList.self) { list in
                SavedListItemsView(list: list, onSelect: onSelect, onSelectMany: onSelectMany)
            }
        }
        .presentationDetents([.medium, .large], selection: $selectedDetent)
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(38)
    }

    private var filteredCatalogItems: [ShoppingListView.AddableItem] {
        return catalogItems.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.department.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var savedListsCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(savedLists.enumerated()), id: \.element.id) { index, list in
                NavigationLink(value: list) {
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(list.name)
                                .font(.body)
                                .foregroundStyle(.primary)
                            Text("\(list.itemCount) items")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color(.systemGray3))
                    }
                    .frame(height: 68)
                    .padding(.horizontal, 16)
                }
                .buttonStyle(.plain)

                if index < savedLists.count - 1 {
                    Divider()
                        .padding(.horizontal, 16)
                }
            }
        }
        .background(Color(.systemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var cartItemsCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(cartItems.enumerated()), id: \.element.id) { index, item in
                cartItemRow(item)

                if index < cartItems.count - 1 {
                    Divider()
                }
            }
        }
        .background(Color.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.12), radius: 20, y: 8)
    }

    private var cartHeader: some View {
        HStack {
            Text("\(cartItems.count) items")
                .font(.body)

            Spacer()

            Button {
                selectedCartItemIDs = Set(cartItems.map(\.id))
            } label: {
                Label("Add all items", systemImage: "plus.circle")
                    .font(.headline)
                    .foregroundStyle(Color.brandBlue)
            }
            .buttonStyle(.plain)
        }
    }

    private var searchResults: some View {
        VStack(spacing: 0) {
            if filteredCatalogItems.isEmpty {
                ContentUnavailableView.search(text: searchText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else {
                ForEach(Array(filteredCatalogItems.enumerated()), id: \.element.id) { index, item in
                    addItemRow(item)
                        .padding(.horizontal, 16)
                        .frame(minHeight: 68)

                    if index < filteredCatalogItems.count - 1 {
                        Divider()
                            .padding(.leading, 70)
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.title3)

            TextField("Search the store", text: $searchText)
                .font(.body)

            Image(systemName: "mic.fill")
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 14)
        .frame(height: 48)
        .background(.regularMaterial, in: Capsule())
        .shadow(color: .black.opacity(0.12), radius: 20, y: 8)
        .padding(.horizontal, 12)
    }

    private func cartItemRow(_ item: ShoppingListView.AddableItem) -> some View {
        Button {
            toggleCartSelection(for: item)
        } label: {
            HStack(spacing: 16) {
                Image(systemName: selectedCartItemIDs.contains(item.id) ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(selectedCartItemIDs.contains(item.id) ? Color.brandBlue : Color(.systemGray3))

                VStack(alignment: .leading, spacing: 4) {
                    VStack(alignment: .leading, spacing: 0) {
                        if !item.department.isEmpty {
                            Text(item.department)
                        }
                        Text(locationTitle(for: item))
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color(red: 0.0, green: 0.13, blue: 0.41))

                    Text(item.name)
                        .font(.footnote)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(item.imageName == "Miracle" ? 6 : 0)
                    .frame(width: 68, height: 68)
                    .background(item.imageName == "Miracle" ? Color.white : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .buttonStyle(.plain)
    }

    private func locationTitle(for item: ShoppingListView.AddableItem) -> String {
        let startsWithDigit = item.bay.first?.isNumber == true
        let trailing = startsWithDigit ? "Bay \(item.bay)" : item.bay
        return "Aisle \(item.aisle) • \(trailing)"
    }

    private func toggleCartSelection(for item: ShoppingListView.AddableItem) {
        if selectedCartItemIDs.contains(item.id) {
            selectedCartItemIDs.remove(item.id)
        } else {
            selectedCartItemIDs.insert(item.id)
        }
    }

    private func addSelectedCartItems() {
        onSelectMany(cartItems.filter { selectedCartItemIDs.contains($0.id) })
    }

    @ViewBuilder
    private func addItemRow(_ item: ShoppingListView.AddableItem) -> some View {
        Button {
            onSelect(item)
        } label: {
            HStack(spacing: 12) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(item.locationLabel)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.blue)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct SavedListItemsView: View {
    let list: AddItemSheet.SavedCustomerList
    let onSelect: (ShoppingListView.AddableItem) -> Void
    let onSelectMany: ([ShoppingListView.AddableItem]) -> Void

    @State private var selectedItemIDs = Set<ShoppingListView.AddableItem.ID>()

    var body: some View {
        List {
            Section {
                ForEach(list.items) { item in
                    Button {
                        toggleSelection(for: item)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: selectedItemIDs.contains(item.id) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(selectedItemIDs.contains(item.id) ? .blue : .secondary)

                            Image(item.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .foregroundStyle(.primary)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(item.locationLabel)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button("Add") {
                            onSelect(item)
                        }
                        .tint(.blue)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(list.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add All") {
                    onSelectMany(list.items)
                }
            }

            ToolbarItem(placement: .bottomBar) {
                Button("Add Selected") {
                    let itemsToAdd = list.items.filter { selectedItemIDs.contains($0.id) }
                    onSelectMany(itemsToAdd)
                }
                .disabled(selectedItemIDs.isEmpty)
            }
        }
    }

    private func toggleSelection(for item: ShoppingListView.AddableItem) {
        if selectedItemIDs.contains(item.id) {
            selectedItemIDs.remove(item.id)
        } else {
            selectedItemIDs.insert(item.id)
        }
    }
}

#Preview {
    ShoppingListView()
}
