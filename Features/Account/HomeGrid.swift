//
//  HomeGrid.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/6/26.
//

import SwiftUI

private struct LeftColumnHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct HomeGrid: View {
    @State private var leftCardHeight: CGFloat = 0

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            TopPriority()
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: LeftColumnHeightKey.self,
                                        value: geo.size.height)
                    }
                )
                .frame(maxWidth: .infinity, alignment: .topLeading)

            VStack(spacing: 12) {
                HomeRecordGrid()
                    .frame(maxHeight: .infinity, alignment: .top)
                
                CurrentProjectGrid()
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .frame(height: leftCardHeight, alignment: .top)
        }
        .padding(.horizontal, 16)
        .onPreferenceChange(LeftColumnHeightKey.self) { leftCardHeight = $0 }
    }
}

#Preview {
    HomeGrid()
}
