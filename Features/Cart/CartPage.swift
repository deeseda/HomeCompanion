//
//  CartView.swift
//  Checkout
//
//  Created by Derrick Deese on 5/29/26.
//

import SwiftUI

struct SectionStyle: ViewModifier {
    var padding: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(.backgroundPrimary)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
    }
}

extension View {
    func primaryStyle(padding: CGFloat = 20) -> some View {
        modifier(SectionStyle(padding: padding))
    }
}

struct CartPage: View {
    @State private var selectedTab = "Shop"
    @State private var showShoppingList = false
    @Namespace private var animation

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Shop", systemImage: "storefront", value: "Shop") {
                NavigationStack {
                    ShopView(showShoppingList: $showShoppingList)
                }
            }

            Tab("Cart", systemImage: "cart", value: "Cart") {
                NavigationStack {
                    CartView()
                }
            }

            Tab("Wallet", systemImage: "qrcode", value: "Wallet") {
                EmptyView()
            }

            Tab("Account", systemImage: "person", value: "Account") {
                NavigationStack {
                    AccountView()
                }
            }

            Tab(value: "Search", role: .search) {
                EmptyView()
            }
        }
        .toolbarBackground(.thickMaterial, for: .tabBar)
        .fullScreenCover(isPresented: $showShoppingList) {
            ShoppingListView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background)
                .navigationTransition(.zoom(sourceID: "SHOPPINGLIST", in: animation))
        }
        .onOpenURL { url in
            guard url.scheme == "storemode", url.host == "shopping-list" else { return }
            showShoppingList = true
        }
    }
}

#Preview {
    CartPage()
}
