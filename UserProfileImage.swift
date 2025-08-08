//
//  UserProfileImage.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 30/05/25.
//

import Foundation
import SwiftUI

//struct UserProfileImage: View {
//    let imageName: String
//    
//    var body: some View {
//        if let url = URL(string: imageName) {
//            AsyncImage(url: url) { phase in
//                switch phase {
//                case .empty:
//                    ProgressView()
//                case .success(let image):
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                case .failure:
//                    Image("default-profile")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                @unknown default:
//                    Image("default-profile")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                }
//            }
//            .frame(width: 40, height: 40)
//            .clipShape(Circle())
//        } else {
//            Image("default-profile")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 40, height: 40)
//                .clipShape(Circle())
//        }
//    }
//}
//
