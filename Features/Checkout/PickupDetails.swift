//
//  PickupDetails.swift
//  Checkout
//
//  Created by Derrick Deese on 4/20/26.
//

import SwiftUI

struct PickupDetails: View {
    @State private var curbSide = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            VStack(alignment: .leading) {
                Text("Pickup Details")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Central Charlotte Lowe's")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("2.9 mi")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button("Edit", systemImage: "info.circle") {

                    }
                    .buttonStyle(.automatic)
                    .font(.headline)
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.secondary)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ProductImage(productImage: Image("flower"))
                    ProductImage(productImage: Image("plant"), quantity: 3)
                    ProductImage(productImage: Image("tool"))
                    ProductImage(productImage: Image("saw"))
                    ProductImage(productImage: Image("ladder"))
                    ProductImage(productImage: Image("mulch"), quantity: 120)
                }
                .padding(.bottom, 6)
                .padding(.trailing, 6)
            }
            .padding(.vertical, 8)
            .safeAreaPadding(.horizontal, 32)
            .padding(.horizontal, -32)

            Divider()

            HStack {
                Image(systemName: "car.fill")
                    .frame(width: 24, height: 24)
                Text("Curbside pickup")
                    .font(.body)
                Spacer()
                Toggle("", isOn: $curbSide)
                    .tint(.accent)
            }

            Divider()

            HStack {
                Image(systemName: "person.fill")
                    .frame(width: 24, height: 24)
                Text("Add pickup person")
                    .font(.body)
                Spacer()
                Button("Edit", systemImage: "chevron.right") {

                }
                .buttonStyle(.automatic)
                .font(.headline)
                .labelStyle(.iconOnly)
                .foregroundStyle(.secondary)
            }
        }
        .primaryStyle()
        .padding(.horizontal, 16)
    }
}

#Preview {
    PickupDetails()
}
