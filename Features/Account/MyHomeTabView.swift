//
//  MyHomeTabView.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/2/26.
//

import SwiftUI

struct MyHomeTabView: View {
    private let heroHeight: CGFloat = 442
    private let heroImageHeight: CGFloat = 412
    private let heroImageBottomInset: CGFloat = 0

    var body: some View {
        VStack(spacing: 12) {
            
            heroSection
            
            HomeGrid()
                .padding(.bottom, 36)
            
            MyProductsSection()
                .padding(.bottom, 36)
            
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
                .padding(.top, -104)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 32) {
            Spacer(minLength: 160)

            MyHomeAddressBlock(
                address: "100 W Worthington Ave",
                location: "Charlotte, NC 28203"
            )

            MyHomePropertyStatsPill()

            Spacer(minLength: 112)
        }
        .padding(.horizontal, 16)
        .frame(height: heroHeight, alignment: .top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(alignment: .bottom) {
            heroBackground
        }
    }

    private var heroBackground: some View {
        let stretchDivisor: CGFloat = 442
        let topOverhang: CGFloat = 160

        return ZStack(alignment: .bottom) {
            LinearGradient(
                stops: [
                    .init(color: .brandBlue, location: 0),
                    .init(color: .brandBlue, location: 0.64),
                    .init(color: Color(.systemGroupedBackground), location: 0.71),
                    .init(color: Color(.systemGroupedBackground), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            Image("newhouse")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: heroImageHeight + topOverhang, alignment: .bottom)
                .offset(y: -60)
                .clipped()
                .visualEffect { content, proxy in
                    let minY = proxy.frame(in: .scrollView).minY
                    let scale = minY > 0 ? 1 + (minY / stretchDivisor) : 1
                    let offset = minY > 0 ? 0 : -minY * 0.4
                    return content
                        .scaleEffect(scale, anchor: .bottom)
                        .offset(y: offset)
                }
                .overlay {
                    LinearGradient(
                        colors: [
                            .brandBlue.opacity(0.94),
                            .brandBlue.opacity(0.36),
                            .brandBlue.opacity(0)
                        ],
                        startPoint: .top,
                        endPoint: UnitPoint(x: 0.5, y: 0.38)
                    )
                }
                .overlay {
                    LinearGradient(
                        colors: [
                            .brandBlue.opacity(0.24),
                            .brandBlue.opacity(0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                }
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [
                            .clear,
                            Color(.systemGroupedBackground)
                        ],
                        startPoint: .top,
                        endPoint: .center
                    )
                    .frame(height: 48)
                }
                .padding(.bottom, heroImageBottomInset)
        }
        .frame(maxWidth: .infinity)
        .frame(height: heroHeight + topOverhang, alignment: .bottom)
        .clipped()
        .ignoresSafeArea(edges: .top)
    }
}


#Preview {
    MyHomeTabView()
}
