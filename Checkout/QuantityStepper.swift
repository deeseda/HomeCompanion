//
//  QuantityStepper.swift
//  Checkout
//
//  Created by Derrick Deese on 4/29/26.
//

import SwiftUI

struct QuantityStepper: View {
    @Binding var quantity: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                if quantity > 1 { quantity -= 1 }
            } label: {
                Image(systemName: "minus")
                    .frame(width: 32, height: 32)
                    .opacity(quantity == 1 ? 0.3 : 1)
            }
            
            Text("\(quantity)")
                .monospacedDigit()
                .frame(minWidth: 24)
            
            Button {
                quantity += 1
            } label: {
                Image(systemName: "plus")
                    .frame(width: 32, height: 32)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .overlay {
            Capsule()
                .strokeBorder(.secondary.opacity(0.3), lineWidth: 1)
        }
    }
}

#Preview {
    QuantityStepper(quantity: .constant(1))
}
