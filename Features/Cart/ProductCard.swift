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
    let price: Decimal = 148.99
    @State private var quantity = 1
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(alignment: .top, spacing: 8) {
                    
                    ProductImage(productImage: Image(imageName))
                        .padding(.trailing, 8)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text(description)
                            .font(.callout)
                            .foregroundColor(.labelPrimary)
                            .lineLimit(2)
                        
                        QuantityStepper(quantity: $quantity)
                        
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        
                        Text(" \(price, format: .currency(code: "USD"))")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.labelPrimary)
                        
                        Text(wasPrice)
                            .font(.footnote)
                            .foregroundColor(.lableSecondary)
                    }
                }
                
//                Divider()
//                
//                HStack {
//                    
//                    Button {
//                    } label: {
//                        Text("Remove")
//                            .font(.footnote)
//                            .underline()
//                    }
//                    .tint(.primary.opacity(0.9))
//                    .frame(height: 48)
//                    
//                    Spacer()
//                    
//                    Button {
//                    } label: {
//                        Text("Save for Later")
//                            .font(.footnote)
//                            .underline()
//                    }
//                    .tint(.primary.opacity(0.9))
//                    .frame(height: 48)
//                    
//                    Spacer()
//                                        
//                    QuantityStepper(quantity: $quantity)
//                    
//                }
                
            }
            .primaryStyle(padding: 16)
            
        }
        .padding(.horizontal, 16)
        .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        // remove item
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                    
                    Button {
                        // save for later
                    } label: {
                        Label("Save", systemImage: "bookmark")
                    }
                }
        
    }
    
    var wasPrice: AttributedString {
        let wasText = AttributedString(" ")
        var priceText = AttributedString(price.formatted(.currency(code: "USD")))
        priceText.strikethroughStyle = .single
        return wasText + priceText
    }
}

#Preview {
    ProductCard()
}
