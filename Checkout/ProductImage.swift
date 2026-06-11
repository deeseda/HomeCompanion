//
//  ProductImage.swift
//  Checkout
//
//  Created by Derrick Deese on 4/20/26.
//

import SwiftUI

struct ProductImage: View {
    
    var productImage: Image
    var quantity: Int?
    
    private var quantityLabel: String {
        guard let quantity else { return "" }
        return quantity > 99 ? "99+" : "\(quantity)"
    }
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            productImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(8)
                .frame(width: 68, height: 68)
                .blendMode(.multiply)
                .background(.brandLightblue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            if let _ = quantity {
                HStack {
                    Text(quantityLabel)
                }
                .padding(.horizontal, 4)
                .font(.callout)
                .fontWeight(.semibold)
                .frame(minWidth: 24, minHeight: 24, maxHeight: 24)
                .background(.brandBlue)
                .foregroundStyle(.white)
                .cornerRadius(12)
                .padding(.bottom, -4)
                .padding(.trailing, -4)
            }
        }
    }
}

#Preview {
    ProductImage(productImage: Image("flower"))
    ProductImage(productImage: Image("flower"), quantity: 5)
    ProductImage(productImage: Image("flower"), quantity: 150)
}
