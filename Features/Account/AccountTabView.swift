//
//  AccountTabView.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/2/26.
//

import SwiftUI

struct AccountTabView: View {
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            rewardsStatusBanner
                .padding(.horizontal, 16)
                .padding(.top, 16)
            earningInfo
                .padding(.top, 12)
            quickActions
                .padding(.horizontal, 16)
                .padding(.top, 16)
            myPurchasesSection
                .padding(.top, 24)
            myLowesRewardsSection
                .padding(.top, 24)
            Spacer(minLength: 40)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hi, Derrick")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Member since 2024")
                .font(.subheadline)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            Color.brandBlue
                .padding(.top, -1000)
        }
    }

    private var rewardsStatusBanner: some View {
        HStack(spacing: 12) {
            Text("MyLowe's\nRewards")
                .font(.caption)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            Divider()
                .frame(height: 30)
                .overlay(Color.white.opacity(0.4))

            Image(systemName: "key.horizontal.fill")
                .font(.title3)
                .foregroundStyle(.white)

            Text("Gold Key Status")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(red: 0.7, green: 0.6, blue: 0.3))
        )
    }

    private var earningInfo: some View {
        HStack(spacing: 4) {
            Text("Earning 1.5 points per eligible dollar spent")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Image(systemName: "info.circle")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
    }

    private var quickActions: some View {
        HStack(spacing: 12) {
            quickActionCard(icon: "dollarsign.circle.fill", title: "MyLowe's Money", iconColor: .brandBlue)
            quickActionCard(icon: "qrcode", title: "Scan Member ID", iconColor: .primary)
        }
    }

    private func quickActionCard(icon: String, title: String, iconColor: Color) -> some View {
        Button { } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(iconColor)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.background)
            )
        }
    }

    private var myPurchasesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("My Purchases")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.brandBlue)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                purchaseRow(icon: "shippingbox", title: "Purchase History")
                Divider().padding(.leading, 56)
                purchaseRow(icon: "arrow.counterclockwise.circle", title: "Buy It Again")
                Divider().padding(.leading, 56)
                purchaseRow(icon: "arrow.triangle.2.circlepath", title: "Subscriptions")
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.background)
            )
            .padding(.horizontal, 16)
        }
    }

    private func purchaseRow(icon: String, title: String) -> some View {
        Button { } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.brandBlue)
                    .frame(width: 32)
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
        }
    }

    private var myLowesRewardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("MyLowe's Rewards")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.brandBlue)
                .padding(.horizontal, 16)

            HStack {
                Image(systemName: "key.horizontal.fill")
                    .font(.title3)
                    .padding(8)
                    .background(Circle().fill(.white.opacity(0.2)))
                Text("Gold Key")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "info.circle")
                    .font(.title3)
            }
            .foregroundStyle(.white)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(red: 0.7, green: 0.6, blue: 0.3))
            )
            .padding(.horizontal, 16)

            HStack(spacing: 4) {
                tierBar(label: "Bronze Key", color: Color(red: 0.7, green: 0.45, blue: 0.25))
                tierBar(label: "Silver Key", color: .gray)
                tierBar(label: "Gold Key", color: Color(red: 0.7, green: 0.6, blue: 0.3))
            }
            .padding(.horizontal, 16)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundStyle(.brandBlue)
                    Text("MyLowe's Money")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                    Button("Terms") { }
                        .font(.caption)
                }

                HStack {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 8)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.brandBlue)
                                .frame(width: geo.size.width * 0.55, height: 8)
                        }
                    }
                    .frame(height: 8)

                    Text("$5")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }

                HStack(spacing: 0) {
                    Text("183 points")
                        .fontWeight(.bold)
                    Text(" to unlock next reward")
                }
                .font(.caption)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.background)
            )
            .padding(.horizontal, 16)

            HStack(spacing: 4) {
                Text("Earning 1.5 points per eligible dollar spent")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
        }
    }

    private func tierBar(label: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(height: 6)
        }
    }
}

#Preview {
    NavigationStack {
        AccountTabView()
    }
}
