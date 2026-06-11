//
//  Payment2.swift
//  Checkout
//
//  Created by Derrick Deese on 4/22/26.
//

import SwiftUI

struct Payment2: View {
    @State private var selectedOption = "visa"

    var body: some View {

        VStack {


            VStack(alignment: .leading, spacing: 16) {

                HStack {
                    Text("Payment")
                        .font(.title3)
                        .padding(.bottom, 4)

                    Spacer()

//                    Button("More Options")
//                    {}
//                    .fontWeight(.regular)
//                    .padding(8)
                }


                HStack(spacing: 16) {
                    
                    Image(.visa)
                        .resizable()
                        .frame(width: 40, height: 40)

                    
                    VStack(alignment: .leading) {
                        
                        Text("Visa *1234")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("expires 07/28")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Edit", systemImage: "chevron.right") {

                    }
                    .buttonStyle(.automatic)
                    .font(.headline)
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.secondary)
                    
                }

            
//                Divider()
//                    .background(.borderSecondary)

//                MLM()

                Divider()
                    .background(.borderSecondary)

                HStack {

                    Image(systemName: "giftcard.fill")
                        .frame(width: 24, height: 24)
                    Text("Add Lowe's gift card")
                        .font(.body)
                    Spacer()
                    Button("Edit", systemImage: "chevron.right") {

                    }
                    .buttonStyle(.automatic)
                    .font(.headline)
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.secondary)

                }

            }
            .primaryStyle()
            .padding(.horizontal, 16)
        }

    }
}

#Preview {
    Payment2()
}

