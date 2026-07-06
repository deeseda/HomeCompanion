//
//  MyHomeTabView.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/2/26.
//

import SwiftUI

struct MyHomeTabView: View {
    // Height of the blue/photo hero region (before the health card overlap).
    private let heroHeight: CGFloat = 340

    var body: some View {
        VStack(spacing: 12) {
            heroSection
            HomeGrid()
            MyProductsSection()
            MySpacesSection()
        }
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity)
    }

    private var heroSection: some View {
        VStack(spacing: 0) {
            hero

            MyHomeHealthCard()
                .padding(.horizontal, 16)
                .padding(.top, -70)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 16) {
            MyHomeAddressBlock(
                address: "100 W Worthington Ave",
                location: "Charlotte, NC 28203"
            )
                .padding(.top, 16)

            MyHomePropertyStatsPill()

            Spacer(minLength: 24)
        }
        .padding(.horizontal, 16)
        .frame(height: heroHeight, alignment: .top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(alignment: .bottom) {
            heroBackground
        }
    }

    private var heroBackground: some View {
        // Tuning divisor for the parallax stretch on overscroll.
        let stretchDivisor: CGFloat = 442
        // Extra height above the hero so the image runs up behind the status bar
        // and nav bar to the top of the screen.
        let topOverhang: CGFloat = 160

        return ZStack(alignment: .bottom) {
            Color.brandBlue

            Image("newhouse")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: heroHeight + topOverhang, alignment: .bottom)
                .clipped()
                .visualEffect { content, proxy in
                    let minY = proxy.frame(in: .scrollView).minY
                    // Overscroll (pull down): stretch from the bottom.
                    // Scrolling up: drift slower than the content for parallax.
                    let scale = minY > 0 ? 1 + (minY / stretchDivisor) : 1
                    let offset = minY > 0 ? 0 : -minY * 0.4
                    return content
                        .scaleEffect(scale, anchor: .bottom)
                        .offset(y: offset)
                }
        }
        .frame(maxWidth: .infinity)
        .frame(height: heroHeight + topOverhang, alignment: .bottom)
        .clipped()
    }
}


#Preview {
    MyHomeTabView()
}
