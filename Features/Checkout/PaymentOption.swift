//
//  PaymentOption.swift
//  Checkout
//
//  Created by Derrick Deese on 4/21/26.
//

import SwiftUI

struct PaymentOption: View {
    
    var payIcon: ImageResource
    var payName: String
    var defaultPayment: String?
    var isSelected: Bool
    var onSelect: () -> Void
    
    var body: some View {
        
        HStack(spacing: 16) {
            
            Image(payIcon)
                .resizable()
                .frame(width: 36, height: 36)

            
            VStack(alignment: .leading) {
                
                Text(payName)
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)

            }
            
            Spacer()
            
                        if let defaultPayment {
                            Text(defaultPayment)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        
            Button {
                onSelect()
            } label: {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(isSelected ? .accent : .gray)
            }
            .buttonStyle(.plain)
            
        }
    }
}

#Preview {
    PaymentOption(payIcon: .visa,
                  payName: "Visa *1234",
                  isSelected: true,
                  onSelect: {})
}
