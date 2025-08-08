import Foundation
import SwiftUI

struct IntroductionView: View {
    @State private var goToLogin = false
    @ObservedObject private var appState = AppState.shared
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                
                VStack(spacing: height * 0.025) {
                    Spacer().frame(height: height * 0.05)
                    
                    Circle()
                        .fill(Color(hexString: "#A99CFF"))
                        .frame(width: width * 0.15, height: width * 0.15)
                        .overlay(
                            Text("S")
                                .font(.system(size: width * 0.06, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    Text("Skillnity")
                        .font(.system(size: width * 0.07, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Learn. Compete. Get Hired.")
                        .font(.system(size: width * 0.04))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Image(.introGroupIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: height * 0.22)
                    
                    HStack(spacing: width * 0.1) {
                        FeatureItem(iconName: "brain.head.profile", title: "Self-Paced\nLearning", width: width)
                        FeatureItem(iconName: "chevron.left.slash.chevron.right", title: "Coding\nBattles", width: width)
                        FeatureItem(iconName: "rosette", title: "Earn\nBadges", width: width)
                    }
                    .padding()
                    Button(action: {
                        AppState.shared.logout()
                        goToLogin = true
                    }) {
                        Text("Get Started")
                            .font(.system(size: width * 0.045, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(
                                gradient: Gradient(colors: [Color(hexString: "#7D5FFF"), Color(hexString: "#8E7CFF")]),
                                startPoint: .leading,
                                endPoint: .trailing))
                            .cornerRadius(30)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .frame(width: width, height: height)
                .navigationDestination(isPresented: $goToLogin) {
                    LoginView()
                        .padding()
                }

                }
            }
        }
    }


// MARK: - Feature Item View
struct FeatureItem: View {
    var iconName: String
    var title: String
    var width: CGFloat
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.system(size: width * 0.07))
                .foregroundColor(Color(hexString: "#7D5FFF"))
            
            Text(title)
                .multilineTextAlignment(.center)
                .font(.system(size: width * 0.035))
                .foregroundColor(.black)
        }
        .frame(width: width * 0.2)
    }
}
struct Intro_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}

