//
//  MyProductsSection.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/2/26.
//

import SwiftUI

struct MyProductsSection: View {

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            MyHomeSectionHeader(title: "My Products")

            LazyVGrid(columns: columns, spacing: 16) {
                MyHomeAddCard()

                MyHomeCard(
                    title: "Refrigerator",
                    image: Image("fridge")
                )

                MyHomeCard(
                    title: "Range",
                    image: Image("range")
                )

                MyHomeCard(
                    title: "Dishwasher",
                    image: Image("dishwasher")
                )

            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    MyProductsSection()
}
