//
//  OSCart.swift
//  Checkout
//
//  Created by Derrick Deese on 4/29/26.
//

import SwiftUI

struct OSCart: View {
    
    private func summaryRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }
    
    var body: some View {
        
        VStack(spacing: 16) {
            HStack {
                Text("Order Summary")
                Spacer()
            }
            .font(.title3)
            .fontWeight(.semibold)
            Divider()
                .background(.borderSecondary)
            summaryRow(title: "Subtotal (3 items)", value: "$215.84")
                .font(.subheadline)
            summaryRow(title: "Savings", value: "-$24.00")
                .font(.subheadline)
            summaryRow(title: "Tax", value: "$15.65")
                .font(.subheadline)
            Divider()
                .background(.borderSecondary)
            summaryRow(title: "MyLowe's Money", value: "-$15.00")
                .font(.subheadline)
            Divider()
                .background(.borderSecondary)
            summaryRow(title: "Total", value: "$192.49")
                .font(.title3)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 32)
    }
}

struct BenefitsRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.callout)
                .foregroundStyle(.brandBlue)
                .frame(width: 32)
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.primary)
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
    }
}

struct BenefitsCard: View {
    var body: some View {
        VStack(spacing: 0) {
            BenefitsRow(icon: "arrow.uturn.left.square", title: "FREE & Easy Returns")
            Divider()
            BenefitsRow(icon: "tag", title: "Lowest Price Guarantee")
            Divider()
            BenefitsRow(icon: "truck.box", title: "Pickup & Delivery Options")
        }
//        .background(.white)
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.borderSecondary, lineWidth: 1)
        )
    }
}

#Preview {
    OSCart()
}
