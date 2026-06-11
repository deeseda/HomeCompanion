//
//  ProductCard.swift
//  Checkout
//
//  Created by Derrick Deese on 4/29/26.
//

import SwiftUI

struct ProductCard: View {
    var imageName: String = "flower"
    var description: String = "Orange Marigold in 1 Pint Pot 1-Pack"
    let price: Decimal = 0.90
    @State private var quantity = 1
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(alignment: .top, spacing: 8) {
                    
                    ProductImage(productImage: Image(imageName))
                    
                    VStack(alignment: .leading) {
                        
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                        
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        
                        Text("Now \(price, format: .currency(code: "USD"))")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.brandGreen)
                        
                        Text(wasPrice)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                HStack {
                    
                    Button {
                    } label: {
                        Text("Remove")
                            .font(.footnote)
                            .underline()
                    }
                    .tint(.primary.opacity(0.9))
                    .frame(height: 48)
                    
                    Spacer()
                    
                    Button {
                    } label: {
                        Text("Save for Later")
                            .font(.footnote)
                            .underline()
                    }
                    .tint(.primary.opacity(0.9))
                    .frame(height: 48)
                    
                    Spacer()
                                        
                    QuantityStepper(quantity: $quantity)
                    
                }
                
            }
            .primaryStyle(padding: 16)
            
        }
        .padding(.horizontal, 16)
        
    }
    
    var wasPrice: AttributedString {
        let wasText = AttributedString("Was ")
        var priceText = AttributedString(price.formatted(.currency(code: "USD")))
        priceText.strikethroughStyle = .single
        return wasText + priceText
    }
}

#Preview {
    ProductCard()
}
