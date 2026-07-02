//
//  CartView.swift
//  Checkout
//
//  Created by Derrick Deese on 4/29/26.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        if #available(iOS 27.0, *) {
            ScrollView {
                LazyVStack(spacing: 16, pinnedViews: .sectionHeaders) {
                    
                    Section {
                        ProductCard(imageName: "flower", description: "2 Quart(s) Orange Marigold 1 -Pack - Low Maintenance")
                        ProductCard(imageName: "saw", description: "DEWALT 20-volt Max 6-1/2-in Brushless Cordless Circular saw (Battery Not Included and Charger Not Included)")
                        ProductCard(imageName: "mulch", description: "Sta-Green Premium 2-cu ft Brown Mulch")
                    }
                    header: {
                        SectionHeader(title: "Pickup")
                    }
                    
                    Section {
                        ProductCard()
                    }
                    header: {
                        SectionHeader(title: "Delivery")
                    }
                    
                    BenefitsCard()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 24)
                    
                    OSCart()
                        .background {
                            Color.white
                                .padding(.bottom, -1000)
                        }
                    
                    
                    
                }
            }

            .background(.backgroundSecondary)
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
    }
}

#Preview {
    NavigationStack {
        CartView()
    }
}
