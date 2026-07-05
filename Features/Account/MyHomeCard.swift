//
//  MyHomeCard.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/2/26.
//

import SwiftUI

struct MyHomeCard: View {
    let title: String
    let image: Image

    var body: some View {
        Button {
            // action
        } label: {
            VStack(alignment: .leading, spacing: 16) {

                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)


                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .frame(height: 210)
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

    MyHomeCard(

        title: "Range",

        image: Image("Range")

    )

    .padding()

}
