//
//  MyHomeTaskCard2.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/3/26.
//

import SwiftUI

struct MyHomeTaskCard2: View {
    let category: String
    let title: String
    let details: String

    init(
        category: String = "Seasonal • Summer",
        title: String = "Replace HVAC Filter",
        details: String = "Due in 12 days  •  15 min  •  Easy"
    ) {
        self.category = category
        self.title = title
        self.details = details
    }

    var body: some View {
        Button(action: { /* TODO: Open task details */ }) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(category)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)

                    Text(details)
                        .font(.caption)
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .padding(.vertical, 10)
            .frame(minHeight: 69)
            .background(.background, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MyHomeTaskCard2()
        .padding()
        .background(Color(.systemGroupedBackground))
}
