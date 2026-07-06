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
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Your Home Today")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            HStack(spacing: 14) {
                VStack(alignment: .leading) {
                    Text("Home Health")
                        .font(.footnote)

                    HStack(alignment: .firstTextBaseline, spacing: 5) {
                        Text(score)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)

                        Text(status)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)

                    }
                }
                .frame(alignment: .leading)

                Rectangle()
                    .foregroundStyle(.gray)
                    .frame(width: 0.5, height: 40)

                VStack(alignment: .leading, spacing: 1) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrowtriangle.up.fill")
                            .font(.caption2)
                            .foregroundStyle(.green)

                        Text(change)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }

                    Text(period)
                        .font(.caption)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 1) {
                    HStack(spacing: 4) {
                        Image(systemName: "lightbulb")
                            .font(.caption2)
                            .foregroundStyle(.labelPrimary)

                        Text("Focus Area")
                            .font(.footnote)
                            .foregroundStyle(.labelPrimary)
                    }

                    Text("Improve energy efficiency")
                        .font(.footnote)
                        .foregroundStyle(.lableSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .background(Color(red: 0.94, green: 0.95, blue: 0.98))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 8)

            
        }
        
    }
}

#Preview {
    MyHomeHealthCard()
        .padding()
        .background(.brandBlue)
}
