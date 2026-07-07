//
//  HomeRecordGrid.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/6/26.
//

import SwiftUI

struct HomeRecordGrid: View {
    var body: some View {
        Button(action: { /* TODO: Open Home Record timeline */ }) {
            VStack(alignment: .leading, spacing: 4) {
                
                Text("Home Record")
                    .font(.footnote)
                
                Text("Added Refrigerator")
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text("Yesterday")
                    .font(.footnote)
                    .foregroundStyle(Color(.secondaryLabel))
                
                Spacer()

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeRecordGrid()
}
