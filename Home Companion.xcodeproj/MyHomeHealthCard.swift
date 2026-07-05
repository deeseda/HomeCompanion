//
//  MyHomeHealthCard.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/3/26.
//

import SwiftUI

struct MyHomeHealthCard: View {
    let score: String
    let status: String
    let change: String
    let period: String

    init(
        score: String = "87",
        status: String = "Good",
        change: String = "+3",
        period: String = "this month"
    ) {
        self.score = score
        self.status = status
        self.change = change
        self.period = period
    }

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Home Health")
                    .font(.caption)

                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    Text(score)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(status)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }

            Rectangle()
                .fill(.white.opacity(0.75))
                .frame(width: 0.5, height: 40)

            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 4) {
                    Image(systemName: "arrowtriangle.up.fill")
                        .font(.caption2)
                        .foregroundStyle(Color(red: 0.22, green: 0.66, blue: 0.18))

                    Text(change)
                        .font(.caption)
                        .fontWeight(.semibold)
                }

                Text(period)
                    .font(.caption)
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.brandBlue.opacity(0.28), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

#Preview {
    MyHomeHealthCard()
        .padding()
        .background(.brandBlue)
}
