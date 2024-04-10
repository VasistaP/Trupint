import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongPassword = false
    @State private var wrongUsername = false
    @State private var signUp = false
    @State private var showAlert = false
    @State private var alertMessage: String?

    // Inject the LoginViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack {
                    Image("trooper_Icon")

                    Text("Login").font(.largeTitle).bold().padding()

                    TextField("Username", text: $username)
                        .padding().frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(Color.red, width: wrongUsername ? 1 : 0)

                    SecureField("Password", text: $password)
                        .padding().frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(Color.red, width: wrongPassword ? 1 : 0)

                    Button("Login") {
                        loginViewModel.loginUser(email: username, password: password)
                        // Replace with actual login validation
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.orange)
                    .cornerRadius(10)

                    Button("Sign Up?") {
                        signUp = true
                    }
                    .padding()

                    NavigationLink(
                        destination: SignUView(),
                        isActive: $signUp,
                        label: {
                            EmptyView()
                        }
                    )
                }
            }
            .navigationBarHidden(true)
            .onReceive(loginViewModel.$loggedInUser) { loggedInUser in
                if let user = loggedInUser {
                    loginViewModel.isLoggedIn = true
                    print("Logged in successfully. User ID: \(user.user_id)")
                }
            }
            .onReceive(loginViewModel.$loginError) { loginError in
                if let error = loginError {
                    if error.message == "Invalid Password" {
                        wrongPassword = true
                    } else if error.message == "Email not registered" {
                        wrongUsername = true
                    }
                    showAlert = true
                    alertMessage = error.message
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(LoginViewModel())
    }
}
