//
//  TopPriority.swift
//  Home Companion
//
//  Created by Deese, Derrick on 7/3/26.
//

import SwiftUI

struct TopPriority: View {

    let title: String
    let details: String
    let health: String
    let due: String
    let difficulty: String

    init(
        title: String = "Clean Gutters",
        details: String = "Prevent roof and foundation water damage.",
        health: String = "+2 Home Health",
        due: String = "Due in 12 days",
        difficulty: String = "1 hr  •  Medium"
    
    ) {
        self.title = title
        self.details = details
        self.health = health
        self.due = due
        self.difficulty = difficulty
    }

    var body: some View {
        Button(action: { /* TODO: Open task details */ }) {
            VStack(alignment: .leading, spacing: 16) {
                
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                            Text("Highest Priority")
                        }
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(.green.opacity(0.15))
                        .clipShape(Capsule())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.callout)
                            .fontWeight(.semibold)
                        Text(details)
                            .font(.footnote)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                       
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.heart.fill")
                            Text(health)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                            Text(due)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "timer")
                            Text(difficulty)
                        }

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
                    .foregroundStyle(.lableSecondary)
                }
                
                Button("View Task") {
                    // Action
                }
                .font(.body.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(.secondary.opacity(0.4))

                .clipShape(Capsule())

            }
            .padding(16)
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TopPriority()
        .padding()
        .background(Color(.systemGroupedBackground))
}
