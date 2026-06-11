

//
//  ContentView.swift
//  Checkout
//
//  Created by Derrick Deese on 4/20/26.
//

import SwiftUI

struct ContentView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 24) {
                    ContactInfo()
                    PickupDetails()
                    Payment2()
                    OrderSummary()
                        .background {
                            Color.white
                                .padding(.bottom, -1000)
                        }

                }
                .padding(.top, 24)

            }
            .scrollContentBackground(.hidden)
            .background(.backgroundSecondary)
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Back", systemImage: "xmark") { dismiss() }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Place Order for $192.49")
                    {}
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.glassProminent)
                    .tint(.accent)
                    .padding(8)
                }
            }
           
        }
        
    }
}
#Preview {
    ContentView()
}
