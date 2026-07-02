//
//  OrderSummary.swift
//  Checkout
//
//  Created by Derrick Deese on 4/21/26.
//

import SwiftUI

struct OrderSummary: View {
    
    private func summaryRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }
    
    var body: some View {
        
        VStack(spacing: 24) {
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
            
            
            VStack(alignment: .leading, spacing:20) {
                Text("By placing an order, you agree to [Lowe's Terms](https://example.com) and [Privacy Statement](https://example.com)")
                Text("By providing the phone number above, you consent to receive automated text messages from Lowe's about your order and delivery. Messages and data rates may apply. Number of messages depends on order details. See [Lowe's SMS Terms](https://example.com) and [Privacy Statement](https://example.com).")

            }
            .font(.footnote)
            .lineSpacing(2)
            .foregroundStyle(.primary.opacity(0.8))
            .padding(.top, 24)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 32)

        
    }
}

#Preview {
    OrderSummary()
}
