//
//  ContactInfo.swift
//  Checkout
//
//  Created by Derrick Deese on 4/20/26.
//

import SwiftUI

struct ContactInfo: View {
    
    @State private var showEditSheet = false
    
    var body: some View {
            
            VStack {
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    HStack {
                        
                        VStack(alignment: .leading) {
                            
                            Text(verbatim: "irene.smith@gmail.com")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(verbatim: "(704) 330-7440")
                                .font(.body)

                        }
                        
                        Spacer()
                        
                        Button("Edit", systemImage: "chevron.right") {
                            showEditSheet = true
                        }
                        .buttonStyle(.automatic)
                        .font(.headline)
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.secondary)
                    }
                    
                }
                .primaryStyle()
            }
            .padding(.horizontal, 16)
            .sheet(isPresented: $showEditSheet) {
                EditContactInfo()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.thinMaterial)
            }
        }
}

#Preview {
    ContactInfo()
}
