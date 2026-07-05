//
//  SectionHeader.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/2/26.
//

import SwiftUI

struct MyHomeSectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .foregroundStyle(.brandBlue)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    MyHomeSectionHeader(title: "My Products")
        .padding()
}
