//
//  Payment.swift
//  Checkout
//
//  Created by Derrick Deese on 4/21/26.
//

import SwiftUI

struct Payment: View {
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


                PaymentOption(payIcon: .visa,
                              payName: "Visa *1234",
                              defaultPayment: "Default",
                              isSelected: selectedOption == "visa",
                              onSelect: { selectedOption = "visa" })

                PaymentOption(payIcon: .applePay,
                              payName: "Apple Pay",
                              isSelected: selectedOption == "applePay",
                              onSelect: { selectedOption = "applePay" })

                PaymentOption(payIcon: .payPal,
                              payName: "PayPal",
                              isSelected: selectedOption == "payPal",
                              onSelect: { selectedOption = "payPal" })

                Button("More payment options")
                {}
                .fontWeight(.regular)
                .padding(8)

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
                    .font(.title3)
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.gray)

                }

            }
            .primaryStyle()
            .padding(.horizontal, 16)
        }

    }
}

#Preview {
    Payment()
}
