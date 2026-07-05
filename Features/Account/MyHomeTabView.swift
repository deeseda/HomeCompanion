//
//  MyHomeTabView.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/2/26.
//

import SwiftUI

struct MyHomeTabView: View {
    var body: some View {
        VStack(spacing: 32) {
            heroSection
            MyProductsSection()
            MySpacesSection()
        }
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity)
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            MyHomeAddressBlock(
                address: "100 W Worthington Ave",
                location: "Charlotte, NC 28203"
            )
                .padding(.top, 16)

            MyHomePropertyStatsPill()

            VStack(alignment: .leading, spacing: 16) {
                Text("Your Home Today")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                MyHomeHealthCard()
                
                MyHomeTaskCard()
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(alignment: .bottom) {
            heroBackground
        }
    }

    private var heroBackground: some View {
        GeometryReader { geometry in
            let extendedHeight = geometry.size.height + 220

            ZStack(alignment: .bottom) {
                Color.brandBlue
                    .frame(height: extendedHeight)

                Image("newhouse")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: geometry.size.width,
                        height: extendedHeight,
                        alignment: .bottom
                    )
                    .padding(.bottom, 32)

                LinearGradient(
                    colors: [
                        Color.brandBlue,
                        Color.brandBlue.opacity(0.1),
                        Color.brandBlue.opacity(0.08),
                        .clear,
                        .clear,
                        .clear,
                        Color(.systemGroupedBackground)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: extendedHeight)

                LinearGradient(
                    colors: [
                        .clear,
                        Color(.systemGroupedBackground)
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0.9),
                    endPoint: .bottom
                )
                .frame(height: extendedHeight)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
        }
    }
}

#Preview {
    MyHomeTabView()
}
