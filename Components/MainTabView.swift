//
//  MainTabView.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/3/26.
//

import SwiftUI

enum MainTab: Hashable {
    case shop
    case cart
    case wallet
    case account
    case search
}

struct MainTabView: View {
    @State private var selectedTab: MainTab
    @State private var showShoppingList = false
    @Namespace private var animation

    private let initialAccountTab: AccountView.Tab

    init(
        initialTab: MainTab = .shop,
        initialAccountTab: AccountView.Tab = .account
    ) {
        _selectedTab = State(initialValue: initialTab)
        self.initialAccountTab = initialAccountTab
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Shop", systemImage: "storefront", value: .shop) {
                NavigationStack {
                    ShopView(showShoppingList: $showShoppingList)
                }
            }

            Tab("Cart", systemImage: "cart", value: .cart) {
                NavigationStack {
                    EmptyView()
                }
            }

            Tab("Wallet", systemImage: "qrcode", value: .wallet) {
                EmptyView()
            }

            Tab("Account", systemImage: "person", value: .account) {
                NavigationStack {
                    AccountView(initialTab: initialAccountTab)
                }
            }

            Tab(value: .search, role: .search) {
                EmptyView()
            }
        }
        .toolbarBackground(.thickMaterial, for: .tabBar)
    }
}

#Preview("Account / My Home") {
    MainTabView(
        initialTab: .account,
        initialAccountTab: .myHome
    )
}
