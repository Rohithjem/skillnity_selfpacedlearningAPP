//
//  ProjectView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 31/05/25.
//

import Foundation
import SwiftUI
struct ProjectsView: View {
    var body: some View {
        VStack {
                    Text("No Padding")
                        .background(Color.red)

                    Text("With Padding")
                        .padding()
                        .background(Color.green)
                }
    }
    
}


#Preview {
    ProjectsView()
}
