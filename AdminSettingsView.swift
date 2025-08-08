////
////  AdminSettingsView.swift
////  SelfPacedLearningApp
////
////  Created by SAIL on 30/07/25.
////
//
import SwiftUI
import Foundation

struct AdminSettingsView: View {
    let userID: Int
    @State private var user: AdminUser?
    @State private var isEditing = false
    @State private var isLoading = true
    @State private var fetchError: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView("Loading profile...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let fetchError {
                    VStack(spacing: 12) {
                        Text("Failed to load profile")
                            .font(.headline)
                        Text(fetchError)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Button("Retry") {
                            fetchAdmin()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.themePurple.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding()
                } else {
                    content
                }
            }
            .padding(.top)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            fetchAdmin()
        }
        .sheet(isPresented: $isEditing) {
            if let _ = user {
                EditAdminView(user: $user, userID: userID)
            } else {
                ProgressView().padding()
            }
        }
    }
    
    /// Profile Content
    private var content: some View {
        VStack(spacing: 20) {
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
            
            VStack(spacing: 10) {
                if let urlString = user?.profile_pic,
                   let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 80, height: 80)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .transition(.opacity)
                        case .failure:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                                .frame(width: 80, height: 80)
                        @unknown default:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                                .frame(width: 80, height: 80)
                        }
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 80, height: 80)
                }
                
                Text(user?.username ?? "...")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal)
            
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
    
    /// Fetch Admin Data
    private func fetchAdmin() {
        isLoading = true
        fetchError = nil
        APIService.shared.fetchAdminUser(userID: userID) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let admin):
                    self.user = admin
                case .failure(let err):
                    self.fetchError = err.localizedDescription
                }
            }
        }
    }
}


//struct AdminSettingsView: View {
//    let userID: Int
//    @State private var user: AdminUser? = nil
//
//    @State private var isEditing = false
//    @State private var isLoading = true
//    @State private var fetchError: String?
//    
//    var body: some View {
//        Group {
//            if isLoading {
//                ProgressView("Loading profile...")
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//            } else if let fetchError {
//                VStack(spacing: 12) {
//                    Text("Failed to load profile")
//                        .font(.headline)
//                    Text(fetchError)
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                        .multilineTextAlignment(.center)
//                    Button("Retry") {
//                        fetchAdmin()
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 10)
//                    .background(Color.themePurple.opacity(0.1))
//                    .cornerRadius(10)
//                }
//                .padding()
//            } else {
//                content
//            }
//        }
//        .background(Color.white)
//        .ignoresSafeArea()
//        .onAppear {
//            fetchAdmin()
//        }
//        .sheet(isPresented: $isEditing) {
//            if let _ = user {
//                EditAdminView(user: $user, userID: userID)
//            } else {
//                ProgressView()
//                    .padding()
//            }
//        }
//    }
//
//    private var content: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Title + Settings Icon
//                HStack {
//                    Text("Your Profile")
//                        .font(.title2)
//                        .bold()
//                        .foregroundColor(.themePurple)
//                    Spacer()
//                    Button {
//                        isEditing = true
//                    } label: {
//                        Image(systemName: "gearshape")
//                            .foregroundColor(.themePurple)
//                            .font(.title2)
//                    }
//                }
//                .padding(.horizontal)
//
//                // Profile Card
//                VStack(spacing: 10) {
//                    if let urlString = user?.profile_pic,
//                       let url = URL(string: urlString) {
//                        AsyncImage(url: url) { phase in
//                            switch phase {
//                            case .empty:
//                                ProgressView()
//                                    .frame(width: 80, height: 80)
//                            case .success(let image):
//                                image
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .transition(.opacity)
//                                    .frame(width: 80, height: 80)
//                                    .clipShape(Circle())
//                            case .failure:
//                                Image(systemName: "person.crop.circle.fill")
//                                    .resizable()
//                                    .foregroundColor(.gray)
//                                    .frame(width: 80, height: 80)
//                            @unknown default:
//                                Image(systemName: "person.crop.circle.fill")
//                                    .resizable()
//                                    .foregroundColor(.gray)
//                                    .frame(width: 80, height: 80)
//                            }
//                        }
//                    } else {
//                        Image(systemName: "person.crop.circle.fill")
//                            .resizable()
//                            .foregroundColor(.gray)
//                            .frame(width: 80, height: 80)
//                    }
//
//                    Text(user?.username ?? "...")
//                        .font(.title2)
//                        .bold()
//                        .foregroundColor(.black)
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color(.systemGray6))
//                .cornerRadius(15)
//                .padding(.horizontal)
//
//                Button("Edit Profile") {
//                    isEditing = true
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.themePurple)
//                .foregroundColor(.white)
//                .cornerRadius(12)
//                .padding(.horizontal)
//            }
//            .padding(.vertical)
//        }
//    }
//
//    // MARK: - Networking
//    private func fetchAdmin() {
//        isLoading = true
//        fetchError = nil
//        APIService.shared.fetchadmin(userID: userID) { result in
//            DispatchQueue.main.async {
//                isLoading = false
//                switch result {
//                case .success(let fetchedUser):
//                    self.user = fetchedUser
//                case .failure(let err):
//                    self.fetchError = err.localizedDescription
//                }
//            }
//        }
//    }
//}

//struct AdminSettingsView: View {
//    let userID: Int
//    @State private var user: User?
//    @State private var isEditing = false
//    @State private var isLoading = true
//    @State private var fetchError: String?
//
//
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Title + Settings Icon
//                HStack {
//                    Text("Your Profile")
//                        .font(.title2)
//                        .bold()
//                        .foregroundColor(.themePurple)
//                    Spacer()
//                    Button {
//                        isEditing = true
//                    } label: {
//                        Image(systemName: "gearshape")
//                            .foregroundColor(.themePurple)
//                            .font(.title2)
//                    }
//                }
//                .padding(.horizontal)
//
//                // Profile Card
//                VStack(spacing: 10) {
//                    if let urlString = user?.profile_pic,
//                       let url = URL(string: urlString) {
//                        AsyncImage(url: url) { phase in
//                            switch phase {
//                            case .empty:
//                                ProgressView()
//                                    .frame(width: 80, height: 80)
//                            case .success(let image):
//                                image
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .transition(.opacity)
//                                    .frame(width: 80, height: 80)
//                                    .clipShape(Circle())
//                            case .failure:
//                                Image(systemName: "person.crop.circle.fill")
//                                    .resizable()
//                                    .foregroundColor(.gray)
//                                    .frame(width: 80, height: 80)
//                            @unknown default:
//                                Image(systemName: "person.crop.circle.fill")
//                                    .resizable()
//                                    .foregroundColor(.gray)
//                                    .frame(width: 80, height: 80)
//                            }
//                        }
//                    } else {
//                        Image(systemName: "person.crop.circle.fill")
//                            .resizable()
//                            .foregroundColor(.gray)
//                            .frame(width: 80, height: 80)
//                    }
//
//                    Text(user?.username ?? "...")
//                        .font(.title2)
//                        .bold()
//                        .foregroundColor(.black)
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color(.systemGray6))
//                .cornerRadius(15)
//                .padding(.horizontal)
//
//                Button("Edit Profile") {
//                    isEditing = true
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.themePurple)
//                .foregroundColor(.white)
//                .cornerRadius(12)
//                .padding(.horizontal)
//            }
//            .padding(.vertical)
//        }
//        .background(Color.white.ignoresSafeArea())
//        .onAppear {
//            fetchAdmin()
//        }
//        .sheet(isPresented: $isEditing) {
//            if let _ = user {
//                EditAdminView(user: $user, userID: userID)
//            } else {
//                ProgressView()
//                    .padding()
//            }
//        }
//    }
//
//    // MARK: - Networking
//    private func fetchAdmin() {
//        isLoading = true
//        APIService.shared.fetchadmin(userID: userID) { result in
//            DispatchQueue.main.async {
//                isLoading = false
//                switch result {
//                case .success(let fetchedUser):
//                    self.user = fetchedUser
//                case .failure(let err):
//                    self.fetchError = err.localizedDescription
//                }
//            }
//        }
//    }
//
//}

//struct AdminSettingsView: View {
//    let userID: Int
//    
//    @State private var user: User?
//    
//    
//    @State private var isEditing = false
//    
//    
//    
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Title + Settings Icon
//                HStack {
//                    Text("Your Profile")
//                        .font(.title2)
//                        .bold()
//                        .foregroundColor(.themePurple)
//                    Spacer()
//                    Button {
//                        isEditing = true
//                    } label: {
//                        Image(systemName: "gearshape")
//                            .foregroundColor(.themePurple)
//                            .font(.title2)
//                    }
//                }
//                .padding(.horizontal)
//                
//                // Profile Card
//                VStack(spacing: 10) {
//                    AsyncImage(url: URL(string: user?.profile_pic ?? "")) { phase in
//                        if let image = phase.image {
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .transition(.opacity)
//                                .id(UUID()) // forces refresh
//                        } else {
//                            Image(systemName: "person.crop.circle.fill")
//                                .resizable()
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .frame(width: 80, height: 80)
//                    .clipShape(Circle())
//                    .padding(.top)
//                    
//                    Text(user?.username ?? "...")
//                        .font(.title2)
//                        .bold()
//                        .foregroundColor(.black)
//                    
//                    
//                    Spacer()
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color(.systemGray6))
//                .cornerRadius(15)
//                .padding(.horizontal)
//                Button("Edit Profile") {
//                    isEditing = true
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.themePurple)
//                .foregroundColor(.white)
//                .cornerRadius(12)
//                .padding(.horizontal)
//            }
//            .padding(.vertical)
//        }
//        .background(Color.white.ignoresSafeArea())
//        .onAppear {
//            fetchadmin()
//        }
//        .sheet(isPresented: $isEditing) {
//            if let _ = user {
//                EditProfileView(user: $user, userID: userID)
//            }
//        }
//        
//        func fetchadmin() {
//            APIService.shared.fetchadmin(userID: userID) { result in
//                if case .success(let fetchedUser) = result {
//                    DispatchQueue.main.async {
//                        self.user = fetchedUser
//                    }
//                }
//            }
//        }
//    }
//    
//}
