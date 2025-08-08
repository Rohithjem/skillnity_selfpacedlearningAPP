//
//  StudentProgressView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 30/07/25.
//

import Foundation


import SwiftUI
struct StudentProgressView: View {
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
