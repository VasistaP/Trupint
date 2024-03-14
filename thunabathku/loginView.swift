import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongPassword = false
    @State private var wrongUsername = false
    @State private var loadScreen = false
    @State private var signUp = false
    @State private var showAlert = false
    @State private var alertMessage: String?

    // Inject the LoginViewModel
    @StateObject private var loginViewModel = LoginViewModel()

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

                    // Use the login function from the ViewModel
                    Button("Login") {
                        loginViewModel.loginUser(email: username, password: password)
                        
                        
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.orange)
                    .cornerRadius(10)

                    Button("Sign Up?") {
                        signUp = true
                    }

                    // NavigationLinks
                    NavigationLink(
                        destination: BottomBarView(),
                        isActive: $loadScreen,
                        label: {
                            EmptyView()
                        }
                    )
                    .navigationBarBackButtonHidden(true)

                    NavigationLink(
                        destination: SignUView(),
                        isActive: $signUp,
                        label: {
                            EmptyView()
                        }
                    )
                }
            }
            .navigationBarHidden(loadScreen)
            .navigationBarBackButtonHidden(true)
            .onReceive(loginViewModel.$loggedInUser) { loggedInUser in
                // Handle successful login, navigate to next screen, etc.
                if let user = loggedInUser {
                    loadScreen = true
                    print("Logged in successfully. User ID: \(user.user_id)")

                }
            }
            .onReceive(loginViewModel.$loginError) { loginError in
                // Handle login error, update UI accordingly
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
        .environmentObject(loginViewModel) // Inject the LoginViewModel into the environment
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
