//
//  ViewModifiers.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/3/26.
//

import SwiftUI

struct SectionStyle: ViewModifier {
    var padding: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(.backgroundPrimary)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
    }
}

extension View {
    func primaryStyle(padding: CGFloat = 20) -> some View {
        modifier(SectionStyle(padding: padding))
    }
}
