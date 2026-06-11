//
//  StoreInfo.swift
//  Checkout
//
//  Created by Derrick Deese on 4/22/26.
//

import SwiftUI

struct StoreInfo: View {
    
    private func hoursRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
        }
    }
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        
        NavigationStack {

            HStack {
                
                VStack(alignment: .leading, spacing: 32) {
                    
                    HStack(alignment: .center) {
                        Text("OPEN NOW")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                            .background(.green)
                            .foregroundStyle(.white)
                            .cornerRadius(24)

                        Text("Closes at 10 PM")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    
                    
                    
                    VStack(alignment: .leading) {
                        Text("217 Iverson Way")
                            .font(.headline)
                        Text("Charlotte, NC 28203")
                            .font(.body)
                        Text("7.4 mi")
                            .font(.body)
                    }
                    .font(.body)
                    .foregroundColor(.primary)
                    
                    HStack(spacing: 12) {
                                
                        Button {} label: {
                                    Label("Call Store", systemImage: "phone.fill")
                        }
                        .buttonStyle(.bordered)
                        .foregroundStyle(.accent)

                        
                        Button {} label: {
                                    Label("Directions", systemImage: "car.fill")
                        }
                        .buttonStyle(.borderedProminent)
                        .foregroundStyle(.white)
                        .font(.body)

                    }
                    .buttonSizing(.flexible)
                    .controlSize(.large)
                    .font(.body)
                    
                    VStack {
                        
                        HStack {
                            Text("Store Hours")
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .font(.title3)
                        .fontWeight(.semibold)

                        
                        VStack(spacing: 16) {
                            hoursRow(title: "Sunday", value: "8 AM – 8 PM")
                            Divider()
                                .background(.borderSecondary)
                            hoursRow(title: "Mon – Sat", value: "6 AM – 10 PM")
                        }
                        .padding(16)
                        .padding(.bottom, 4)
                        .background(.backgroundSecondary)
                        .cornerRadius(24)
                        
                        
                    }

                    
                    Spacer()
                    
                }
                
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.white)
            .navigationTitle("Central Charlotte")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Back", systemImage: "xmark") { dismiss() }
                }
                
            }
            
        }
                
    }
}

#Preview {
    StoreInfo()
}
