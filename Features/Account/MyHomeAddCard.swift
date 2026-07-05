//
//  MyHomeAddCard.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/2/26.
//

import SwiftUI

struct MyHomeAddCard: View {
    var body: some View {
        Button {
            // action
        } label: {
            VStack(spacing: 18) {
                Spacer()

                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundStyle(.accent)

                Text("Add a Product")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 210)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.background)
                    .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 4)

            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MyHomeAddCard()
        .padding()
}
