//
//  AchievementBadge.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 24/07/25.
//

import Foundation
import SwiftUI
struct AchievementBadge: View {
    let title: String
    let count: Int

    var body: some View {
        VStack {
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.themePurple)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
