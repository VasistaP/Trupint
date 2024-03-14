//
//  SignUpView.swift
//  Trooper_App
//
//  Created by D Vijay Vardhan Reddy on 17/01/24.
//

import SwiftUI

struct SignUView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var SignIn = false
    @State private var isEmailValid: Bool = false
    @State private var isPasswordValid: Bool = false
    @State private var errorMessage: String = ""
    @State private var isAlertPresented = false
    @State private var MainPage = false

    var body: some View {
        NavigationView {
            VStack {
                Image("trooper_Icon")

                Text("Create an Account").font(.title).padding().bold()
                TextField("Email", text: $email, onEditingChanged: { _ in
                    isEmailValid = isValidEmail(email)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: password) { newPassword in
                        isPasswordValid = isValidPassword(newPassword)
                    }

                Button("Sign Up!") {
                    if isEmailValid && isPasswordValid {
                        // Your sign-in logic here
                        MainPage = true
                        print("Sign Up Successful")
                    } else {
                        // Handle invalid email or password
                        if !isEmailValid {
                            errorMessage = "Invalid Email. Please enter a valid email address."
                            print("Invalid Email")
                        }
                        if !isPasswordValid {
                            print("Invalid Password")
                            errorMessage = "Invalid Password. Password must contain at least types of characters (uppercase, lowercase, numbers, special characters)."
                        }
                        isAlertPresented = true
                    }
                }
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.orange)
                .cornerRadius(10)
                .alert(isPresented: $isAlertPresented) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton:
                        .default(Text("OK")))
                }

                Button("Already Have an Account?") {
                    SignIn = true
                }

                NavigationLink(destination: ContentView2(), isActive: $SignIn, label: {
                    EmptyView()
                })

                NavigationLink(destination: BottomBarView(), isActive: $MainPage, label: {
                    EmptyView()
                })
            }
        }
    }
}

struct SignUView_Previews: PreviewProvider {
    static var previews: some View {
        SignUView()
    }
}

extension SignUView {
    func signUp() {
        // Your signup logic here
        // Remove the Firebase signup logic
    }

    func isValidEmail(_ email: String) -> Bool {
        // Basic email validation using regular expression
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailPredicate.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
}
