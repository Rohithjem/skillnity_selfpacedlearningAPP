////
////  SafariView.swift
////  SelfPacedLearningApp
////
////  Created by SAIL on 25/07/25.
////
//
//import Foundation
//import SwiftUI
//import SafariServices
//
//struct CertificateDownloadView: View {
//    let name: String
//    let college: String
//    @State private var showSafari = false
//
//    var certificateURL: URL {
//        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let encodedCollege = college.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        return URL(string: "http://localhost/skillnity/generate_certificate.php?name=\(encodedName)&college=\(encodedCollege)")!
//    }
//
//    var body: some View {
//        VStack(spacing: 6) {
//            Text("🎉 Certificate Earned!")
//                .font(.subheadline)
//
//            Button("Download PDF") {
//                showSafari = true
//            }
//            .padding()
//            .background(Color.themePurple)
//            .foregroundColor(.white)
//            .cornerRadius(12)
//            .sheet(isPresented: $showSafari) {
//                SafariView(url: certificateURL)
//            }
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(15)
//        .padding(.horizontal)
//    }
//}
//
//// SafariView Wrapper
//struct SafariView: UIViewControllerRepresentable {
//    let url: URL
//    func makeUIViewController(context: Context) -> SFSafariViewController {
//        return SFSafariViewController(url: url)
//    }
//    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
//}
