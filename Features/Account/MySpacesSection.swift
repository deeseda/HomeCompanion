//
//  MySpacesSection.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/3/26.
//

import SwiftUI

struct MySpacesSection: View {

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            MyHomeSectionHeader(title: "My Spaces")

            LazyVGrid(columns: columns, spacing: 16) {
                MyHomeAddCard()

                MyHomeCard(
                    title: "Outdoor",
                    image: Image("outdoor")
                )

                MyHomeCard(
                    title: "Kitchen",
                    image: Image("kitchen")
                )

                MyHomeCard(
                    title: "Bathroom",
                    image: Image("bath")
                )

            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    MySpacesSection()
}
