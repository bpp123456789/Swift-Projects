//
//  LoginView.swift
//  ControlFlow
//
//  Created by William Petrik on 12/5/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth


struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var buttonsDisabled = true
    @State private var alertMessage = ""
    @State private var presentSheet = false
    @State private var showingAlert = false
    @FirestoreQuery(collectionPath: "logins") var staffIDs: [Login]
    @FocusState private var focusField: Field?
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            Image("NEBCLogo")
                .resizable()
                .scaledToFit()
                .padding()
            
            Text("NEBC Login: This page is for staff only")
                .padding()
            
            TextField("Email: ", text: $email)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .submitLabel(.next)
                .focused($focusField, equals: .email)
                .onSubmit {
                    focusField = .password
                    enableButton()
                }
                .padding(.horizontal)
            
            TextField("Password: ", text: $password)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .focused($focusField, equals: .password)
                .onSubmit {
                    focusField = nil
                    enableButton()
                }
                .padding()
            
            HStack {
                Spacer()
                
                Button {
                    login()
                } label: {
                    Image(systemName: "person.fill")
                    
                    Text("Login")
                }
                .disabled(buttonsDisabled)
                
                Spacer()
                
                Button {
                    register()
                } label: {
                    Image(systemName: "person.fill.badge.plus")
                    
                    Text("Signup")
                }
                .disabled(buttonsDisabled)
                
                Spacer()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.baseCampTeal)
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
        
    }
    
    func enableButton() {
        let emailIsGood = email.count > 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("signup Error")
                alertMessage = "Login Error: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("registration successful")
                presentSheet = true
                saveLogin()
                dismiss()
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Sign In Error")
                alertMessage = "Sign In Error: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("login successful")
                for person in staffIDs {
                    if person.email == email {
                        AppData.shared.isStaff = person.isStaff
                        print("staff")
                    }
                }
                print(AppData.shared.isStaff)
                presentSheet = true
                dismiss()
            }
        }
    }
    
    func saveLogin() {
        Task {
            guard let _ = await LoginViewModel.saveLogin(login: Login(id: Auth.auth().currentUser?.uid, email: email)) else {
                print("Error area from save button")
                return
            }
        }
    }
    
}

#Preview {
    LoginView()
}
