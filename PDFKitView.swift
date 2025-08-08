//
//  PDFKitView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 25/07/25.
//

import Foundation
import SwiftUI
import PDFKit

struct PDFKitView: View {
    let url: URL
    @Environment(\.dismiss) var dismiss
    @State private var isSharing = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isSharing = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .padding()
                }
            }
            .padding(.top, 10)

            PDFKitRepresentedView(url:url)
                .edgesIgnoringSafeArea(.bottom)
        }
        .sheet(isPresented: $isSharing) {
            ActivityView(activityItems: [url])
        }
    }
}
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems,
                                 applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}


struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
