//
//  MyHomePropertyStatsPill.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/3/26.
//

import SwiftUI

struct MyHomePropertyStatsPill: View {
    let stats: [MyHomePropertyStat]

    init(stats: [MyHomePropertyStat] = MyHomePropertyStat.defaultStats) {
        self.stats = stats
    }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(stats) { stat in
                statView(stat)

                if stat.id != stats.last?.id {
                    Rectangle()
                        .fill(.white.opacity(0.75))
                        .frame(width: 0.5, height: 16)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.brandBlue.opacity(0.28), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private func statView(_ stat: MyHomePropertyStat) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            if let prefix = stat.prefix {
                Text(prefix)
                    .font(.caption)
            }

            Text(stat.value)
                .font(.subheadline)
                .fontWeight(.semibold)

            if let suffix = stat.suffix {
                Text(suffix)
                    .font(.caption)
            }
        }
        .foregroundStyle(.white)
        .lineLimit(1)
    }
}

struct MyHomePropertyStat: Identifiable {
    let id = UUID()
    let prefix: String?
    let value: String
    let suffix: String?

    static let defaultStats = [
        MyHomePropertyStat(prefix: "Built", value: "1958", suffix: nil),
        MyHomePropertyStat(prefix: nil, value: ".27", suffix: "Acres"),
        MyHomePropertyStat(prefix: nil, value: "3", suffix: "Beds"),
        MyHomePropertyStat(prefix: nil, value: "1.5", suffix: "Baths")
    ]
}

#Preview {
    MyHomePropertyStatsPill()
        .padding()
        .background(.brandBlue)
}
