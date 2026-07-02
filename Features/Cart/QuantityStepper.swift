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
        HStack(spacing: 8) {
            Button {
                if quantity > 1 { quantity -= 1 }
            } label: {
                Image(systemName: "minus")
                    .frame(width: 28, height: 28)
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
        .frame(height: 36)
        .padding(.horizontal, 12)
        .overlay {
            Capsule()
                .strokeBorder(.borderSecondary, lineWidth: 1)
        }
    }
}

#Preview {
    QuantityStepper(quantity: .constant(1))
}
