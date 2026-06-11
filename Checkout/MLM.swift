//
//  MLM.swift
//  Checkout
//
//  Created by Derrick Deese on 4/21/26.
//

import SwiftUI

struct MLM: View {
    
    @State private var mylowesMoney = false

    var body: some View {
        
        VStack {
            HStack {
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("MyLowe's Money")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("$15 Available")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.brandBlue)
                    
                }
                
                Spacer()
                
                Button {
                    // action
                } label: {
                    HStack(spacing: 6) {
                        Text("Apply")
                        Image(systemName: "chevron.right")
                    }
                    .font(.body)
                }
                .buttonStyle(.borderedProminent)
                .tint(.brandBlue)
                
                //Toggle("", isOn: $mylowesMoney)
                
            }
            
//            Divider()
//                .frame(height: 1)
//                .background(.brandBlue.opacity(0.4))
//            
//            
//            HStack  {
//                Text("expires 4/21/26")
//                    .font(.footnote)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 4)
//                    .background(.yellow)
//                    .cornerRadius(4)
//                Spacer()
//            }
            
        }
        .padding()
        .background(.white.opacity(0.1))

        .background(.brandLightblue)
        .cornerRadius(16)
//        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        
    }
}

#Preview {
    MLM()
}
