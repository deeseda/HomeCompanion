//
//  MyHomeAddressBlock.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/3/26.
//

import SwiftUI

struct MyHomeAddressBlock: View {
    let address: String
    let location: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(address)
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.78)

            Text(location)
                .font(.callout)
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    MyHomeAddressBlock(
        address: "100 W Worthington Ave",
        location: "Charlotte, NC 28203"
    )
    .padding()
    .background(.brandBlue)
}
