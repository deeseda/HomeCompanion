//
//  CartPage.swift
//  Checkout
//
//  Created by Derrick Deese on 4/21/26.
//

import SwiftUI

struct SectionStyle: ViewModifier {
    var padding: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(.white)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(Color.borderSecondary, lineWidth: 0)
                )
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
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
        TabView(selection: shopOnlySelection) {
            Tab("Shop", systemImage: "storefront", value: "Shop") {
                NavigationStack {
                    ShopView(showShoppingList: $showShoppingList)
                }
            }

            Tab("Cart", systemImage: "cart", value: "Cart") {
                EmptyView()
            }

            Tab("Wallet", systemImage: "qrcode", value: "Wallet") {
                EmptyView()
            }

            Tab("Account", systemImage: "person", value: "Account") {
                EmptyView()
            }

            Tab(value: "Search", role: .search) {
                EmptyView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .toolbarBackground(.thickMaterial, for: .tabBar)
        .tabViewBottomAccessory {
            ShoppingListAccessory(showShoppingList: $showShoppingList)
                .matchedTransitionSource(id: "SHOPPINGLIST", in: animation)
        }
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

    private var shopOnlySelection: Binding<String> {
        Binding(
            get: { selectedTab },
            set: { newValue in
                guard newValue == "Shop" else { return }
                selectedTab = newValue
            }
        )
    }
}

struct ShoppingListAccessory: View {
    @Environment(\.tabViewBottomAccessoryPlacement) var placement
    @Binding var showShoppingList: Bool

    var body: some View {
        Button {
            showShoppingList = true
        } label: {
            Group {
                switch placement {
                case .inline:
                    HStack(spacing: 8) {
                        Image(systemName: "location.north.circle.fill")
                        Text("Aisle 66 • Endcap Front")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                    }
                default:
                    HStack(spacing: 12) {
                        Image(systemName: "location.north.circle.fill")
                            .font(.title3)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Aisle 66 • Endcap Front")
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            Text("Smart Shop")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(.black)
    }
}

#Preview {
    CartPage()
}
