//
//  ShopView.swift
//  Checkout
//
//  Created by Derrick Deese on 6/5/26.
//

import SwiftUI

struct ShopView: View {
    @Binding var showShoppingList: Bool

    let categories = ["Shop All", "MyLow", "HomeCare+", "Appliances", "Bath", "Flooring"]
    let recommendedSearches = ["Potting Soil", "Cypress Mulch", "Garden Soil", "Patio Furniture", "Lawn Mower"]

    var body: some View {
        ScrollView {
            VStack(spacing:0) {
                headerSection
                categoryBar
                recommendedSection
                    .padding(.bottom, 16)
                VStack(spacing: 16) {
                    promoImage("1")
                    promoImage("3")
                    promoImage("4")
                    promoImage("5")
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                Spacer(minLength: 40)
            }
        }
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button { } label: {
                    Image(systemName: "camera")
                }
                Button { } label: {
                    Image(systemName: "sparkles.2")
                }
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image("LowesLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 40)

            Button { } label: {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                    Text("E. Charlotte Lowe's")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption2)
                }
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            Color.brandBlue
                .padding(.top, -1000)
        }
    }

    // MARK: - Category Bar

    private var categoryBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {

                Button {
                    showShoppingList = true
                } label: {
                    Text("Store Mode")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(.blue)
                        .clipShape(Capsule())
                }

                ForEach(categories, id: \.self) { category in
                    HStack(spacing: 4) {
                        Text(category)
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        if category == "HomeCare+" {
//                            Text("New")
//                                .font(.caption2)
//                                .fontWeight(.bold)
//                                .foregroundStyle(.white)
//                                .padding(.horizontal, 6)
//                                .padding(.vertical, 2)
//                                .background(.red)
//                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .foregroundStyle(.white)
        .background(.brandBlue.opacity(0.85))
    }

    // MARK: - Recommended Searches

    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recommended Searches for You")
                .font(.headline)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(recommendedSearches, id: \.self) { search in
                        Button { } label: {
                            Text(search)
                                .font(.subheadline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                        }
                        .tint(.primary)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, 20)
    }

    // MARK: - Promo Images

    private func promoImage(_ name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    ShopView(showShoppingList: .constant(false))
}
