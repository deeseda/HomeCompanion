//
//  MyHomeTabView.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/2/26.
//

import SwiftUI

struct MyHomeTabView: View {
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Spacer(minLength: 40)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("My Home")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Member since 2024")
                .font(.subheadline)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            Color.brandBlue
                .padding(.top, -1000)
        }
    }
}
#Preview {
    MyHomeTabView()
}
