//
//  CurrentProjectGrid.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/6/26.
//

import SwiftUI

struct CurrentProjectGrid: View {
    var body: some View {
        Button(action: { /* TODO: Open Home Record timeline */ }) {
            VStack(alignment: .leading, spacing: 4) {
                
                Text("Current Project")
                    .font(.footnote)
                
                Text("Bathroom Renovation")
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text("6/10 items complete")
                    .font(.footnote)
                    .foregroundStyle(Color(.secondaryLabel))
                
                Spacer()
                
                ProgressView(value: 0.6)
                    .tint(.blue)
                    .padding(.top, 16)

            }
            .padding(.leading, 12)
            .padding(.trailing, 12)
            .padding(.vertical, 12)
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CurrentProjectGrid()
}
