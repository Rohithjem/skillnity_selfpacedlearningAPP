import SwiftUI
import PDFKit
import UIKit
import Foundation
struct ProfileView: View {
    let userID: Int
    
    @State private var user: User?
    @State private var progress: ProgressData?

    @State private var isEditing = false
    @State private var generatedPDFURL: URL?
    @State private var showPDFPreview = false
    @State private var showShareSheet = false
    @State private var shareURL: URL?

    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title + Settings Icon
                HStack {
                    Text("Your Profile")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.themePurple)
                    Spacer()
                    Button {
                        isEditing = true
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.themePurple)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                // Profile Card
                VStack(spacing: 10) {
                    AsyncImage(url: URL(string: user?.profile_pic ?? "")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .transition(.opacity)
                                .id(UUID()) // forces refresh
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .padding(.top)
                    
                    Text(user?.username ?? "...")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text(user?.college_name ?? "")
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                
                // Course Progress
                VStack(alignment: .leading, spacing: 6) {
                    Text("Course Progress")
                        .font(.headline)
                        .foregroundColor(.themePurple)
                    
                    ProgressView(value: Double(progress?.week ?? 0) / 5.0) {
                        Text("Week \(progress?.week ?? 0) of 5 Completed")
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                
//                 Achievements
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Achievements")
                        .font(.headline)
                        .foregroundColor(.themePurple)
                    
                    if (progress?.badges_earned ?? 0) == 0 {
                        Text("You have no achievements yet.")
                            .foregroundColor(.gray)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                if (progress?.week ?? 0) >= 1 {
                                    AchievementCard(title: "Week 1 Hero", color: .blue)
                                }
                                if (progress?.quizzes_passed ?? 0) >= 3 {
                                    AchievementCard(title: "Quiz Champion", color: .purple)
                                }
                                if (progress?.badges_earned ?? 0) >= 3 {
                                    AchievementCard(title: "Fast Learner", color: .green)
                                }
                                if (progress?.week ?? 0) >= 3 {
                                    AchievementCard(title: "DSA Explorer", color: .orange)
                                }
                                if (progress?.quizzes_passed ?? 0) >= 5 && (progress?.week ?? 0) >= 4 {
                                    AchievementCard(title: "Consistency King", color: .pink)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }

//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Your Achievements")
//                        .font(.headline)
//                        .foregroundColor(.themePurple)
//
//                    // Safely convert badges_earned to Int and compare
//                    if let badgeCount = progress?.badges_earned, badgeCount == 0 {
//                        Text("You have no achievements yet.")
//                            .foregroundColor(.gray)
//                    } else {
//                        HStack(spacing: 10) {
//                            AchievementBadge(
//                                title: "Badges Earned",
//                                count: progress?.badges_earned ?? 0
//                            )
//                            AchievementBadge(
//                                title: "Quizzes Passed",
//                                count: progress?.quizzes_passed ?? 0
//                            )
//                        }
//                    }
//                }

                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                
                // Stats
                // Stats
                HStack(spacing: 12) {
                    // Convert badges_earned to Int, default to 0, then multiply
                    let badgePoints = progress?.badges_earned ?? 0 * 400
                    let quizzesPassed = progress?.quizzes_passed ?? 0
                    
                    StatCard(icon: "trophy.fill", value: "\(badgePoints)", label: "Points Earned")
                    StatCard(icon: "checkmark.circle", value: "\(quizzesPassed)/5", label: "Quizzes Passed")
                }
                .padding(.horizontal)

                
                // Certificate
                /*if (progress?.week ?? 0) == 5*/if let badgeCount = progress?.badges_earned, badgeCount >= 5  {
                    VStack(spacing: 6) {
                        Text("🎉 Certificate Earned!")
                            .font(.subheadline)
//                        Button("Download PDF") {
//                            if let user = user {
//                                generateCertificatePDF(user: user) { url in
//                                    if let pdfURL = url {
//                                        self.generatedPDFURL = pdfURL
//                                        self.showPDFPreview = true
//                                    }
//                                }
//                            }
//                        }
                        Button("Download PDF") {
                            if let user = user {
                                generateCertificatePDF(user: user) { url in
                                    if let url = url {
                                        self.shareURL = url
                                        self.showShareSheet = true
                                    }
                                }
                            }
                        }


                        .padding()
                        .background(Color.themePurple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                
                // Edit Button
                Button("Edit Profile") {
                    isEditing = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.themePurple)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            fetchUserData()
        }
        .sheet(isPresented: $isEditing) {
            if let _ = user {
                EditProfileView(user: $user, userID: userID)
            }
        }
//        .sheet(isPresented: $showPDFPreview) {
//            if let url = generatedPDFURL {
//                PDFKitView(url: url)
//            }
//        }
        .sheet(isPresented: $showShareSheet) {
            if let url = shareURL {
                ShareSheet(activityItems: [url])
            }
        }


    }



//    func generateCertificatePDF(user: User, completion: @escaping (URL?) -> Void) {
//        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792)) // A4 size in points
//        
//        let data = renderer.pdfData { context in
//            context.beginPage()
//            let ctx = context.cgContext
//            
//
//            // Background
//            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
//                                      colors: [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor] as CFArray,
//                                      locations: [0.0, 1.0])!
//
//            ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 612, y: 792), options: [])
//
//            // Title
//            let titleAttributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.boldSystemFont(ofSize: 32),
//                .foregroundColor: UIColor.white
//            ]
//            let title = "Skillnity Certificate of Completion"
//            title.draw(in: CGRect(x: 40, y: 60, width: 532, height: 50), withAttributes: titleAttributes)
//
//            // Content Box
//            let boxRect = CGRect(x: 40, y: 130, width: 532, height: 480)
//            ctx.setFillColor(UIColor.white.cgColor)
//            ctx.setShadow(offset: CGSize(width: 0, height: 3), blur: 6, color: UIColor.gray.cgColor)
//            ctx.fill(boxRect)
//
//            // Content inside
//            let textAttributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: 18),
//                .foregroundColor: UIColor.black
//            ]
//
//            let courseName = "Data Structures & Algorithms (DSA)"
//            let nameText = "This is to certify that"
//            let userText = "\(user.username) from \(user.college_name)"
//            let hasCompleted = "has successfully completed the course:"
//            let courseText = courseName
//            let authority = "\nApproved by Skillnity Academy"
//
//            let content = "\(nameText)\n\n\(userText)\n\n\(hasCompleted)\n\n\(courseText)\n\n\(authority)"
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.alignment = .center
//
//            let fullAttributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: 18),
//                .foregroundColor: UIColor.black,
//                .paragraphStyle: paragraphStyle
//            ]
//
//            let attributedContent = NSAttributedString(string: content, attributes: fullAttributes)
//
//            attributedContent.draw(in: CGRect(x: 60, y: 160, width: 492, height: 400))
//
//
//            // Footer
//            let footer = "www.skillnity.com"
//            let footerAttributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.italicSystemFont(ofSize: 14),
//                .foregroundColor: UIColor.white
//            ]
//            footer.draw(in: CGRect(x: 200, y: 750, width: 212, height: 20), withAttributes: footerAttributes)
//        }
//
//        // Save to documents
//        let fileName = "SkillnityCertificate_\(user.username).pdf"
//        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let outputURL = documentDirectory.appendingPathComponent(fileName)
//            do {
//                try data.write(to: outputURL)
//                completion(outputURL)
//            } catch {
//                print("Failed to save PDF: \(error)")
//                completion(nil)
//            }
//        } else {
//            completion(nil)
//        }
//    }
    func generateCertificatePDF(user: User, completion: @escaping (URL?) -> Void) {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))

        let data = renderer.pdfData { context in
            context.beginPage()
            let ctx = context.cgContext

            // Background gradient
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor] as CFArray,
                                      locations: [0.0, 1.0])!
            ctx.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: pageWidth, y: pageHeight), options: [])

            // White content box
            ctx.setFillColor(UIColor.white.cgColor)
            ctx.fill(CGRect(x: 40, y: 40, width: pageWidth - 80, height: pageHeight - 80))

            ctx.saveGState()
            ctx.translateBy(x: 0, y: pageHeight)
            ctx.scaleBy(x: 1.0, y: -1.0)

            // Logo
            if let logo = UIImage(named: "skillnity_logo")?.cgImage {
                let logoSize: CGFloat = 100
                let logoX = (pageWidth - logoSize) / 2
                let logoY = pageHeight - 150
                ctx.draw(logo, in: CGRect(x: logoX, y: logoY, width: logoSize, height: logoSize))
            }

            ctx.restoreGState()

            // Title
            let title = "Skillnity Certificate of Completion"
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 32),
                .foregroundColor: UIColor.black
            ]
            title.draw(in: CGRect(x: 40, y: 160, width: pageWidth - 80, height: 50), withAttributes: titleAttributes)

            // Certificate box
            let boxRect = CGRect(x: 40, y: 220, width: pageWidth - 80, height: 480)
            ctx.setFillColor(UIColor.white.cgColor)
            ctx.setShadow(offset: CGSize(width: 0, height: 3), blur: 6, color: UIColor.gray.cgColor)
            ctx.fill(boxRect)

            // Main content
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let bodyAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]

            let content = """
            This is to certify that

            \(user.username) from \(user.college_name)

            has successfully completed the course:

            Data Structures & Algorithms (DSA)

            \nApproved by Skillnity Academy
            """

            let attributedContent = NSAttributedString(string: content, attributes: bodyAttributes)
            attributedContent.draw(in: CGRect(x: 60, y: 260, width: pageWidth - 120, height: 400))

            // Footer
            let footer = "www.skillnity.com"
            let footerAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.italicSystemFont(ofSize: 14),
                .foregroundColor: UIColor.gray
            ]
            footer.draw(in: CGRect(x: (pageWidth - 150) / 2, y: pageHeight - 40, width: 150, height: 20), withAttributes: footerAttributes)
        }

        // Save PDF to temp directory
        let fileName = "SkillnityCertificate_\(user.username).pdf"
//        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
//
//        do {
//            try data.write(to: tempURL)
//            print("PDF saved at: \(tempURL)")
//            completion(tempURL)
//        } catch {
//            print("❌ Could not save PDF: \(error)")
//            completion(nil)
//        }
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
                    do {
                        try data.write(to: tempURL)

                        // Present share sheet
                        let av = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootVC = windowScene.windows.first?.rootViewController {
                            rootVC.present(av, animated: true, completion: nil)
                        }
                    } catch {
                        print("Could not save PDF: \(error)")
                    }
    }




    

    func fetchUserData() {
        APIService.shared.fetchUser(userID: userID) { result in
            if case .success(let fetchedUser) = result {
                DispatchQueue.main.async {
                    self.user = fetchedUser
                }
            }
        }
        APIService.shared.fetchProgress(userID: userID) { result in
            if case .success(let fetchedProgress) = result {
                DispatchQueue.main.async {
                    self.progress = fetchedProgress
                }
            }
        }
    }
}

struct AchievementCard: View {
    let title: String
    let color: Color

    var body: some View {
        VStack {
            Image(systemName: "medal.fill")
                .foregroundColor(color)
                .font(.title)
            Text(title)
                .font(.caption)
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.themePurple)
                .font(.title2)
            Text(value)
                .font(.title3)
                .bold()
                .foregroundColor(.black)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }
}
struct PDFPreview: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
