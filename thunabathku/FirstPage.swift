import SwiftUI

struct firstPage: View {
    @State var SignIn = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange, Color.orange]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all)

                VStack {
                    HStack {
                        Image("trooper_Icon")
                            .resizable()
                            .frame(width: 50, height: 50)

                        Text("TROOPER")
                            .font(.system(size: 40))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }

                    Text("Explore without Fear")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .offset(x: 50, y: -10)

                    Spacer()

                    Button(action: {
                        // Handle Google Sign-In
                    }) {
                        HStack {
                            Image(systemName: "google") // Google icon
                                .foregroundColor(.white) // Icon color

                            Text("Continue with Google")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black, radius: 3, x: 1, y: 2)
                    .offset(y: -20)

                    Text("-Or-").foregroundColor(.white).padding(.horizontal, 20)
                        .offset(y: 10)
                        .fontWeight(.bold)
                        .offset(y: -20)

                    Button(action: {
                        // Handle Email Signup
                    }) {
                        HStack {
                            Image(systemName: "envelope") // Email icon
                                .foregroundColor(.white) // Icon color

                            Text("Signup with Email")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                                .background(Color.clear)
                        )
                        .background(Color.clear)
                        .cornerRadius(10)
                        .shadow(color: Color.black, radius: 3, x: 1, y: 2)
                    }
                    .offset(y: -20)
                    .padding()

                    HStack {
                        Text("Already a member?")
                            .foregroundColor(.white)

                        Button(action: {
                            SignIn = true
                        }) {
                            Text("SIGN IN")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }

                        NavigationLink(destination: LoginView(),
                                       isActive: $SignIn,
                                       label: {
                                           EmptyView()
                                       })
                    }
                    .offset(y: -20)
                    .navigationBarBackButtonHidden(true)

                    Text("By creating an account, I accept Trooper App's")
                        .foregroundColor(.white)
                        .offset(y: -10)

                    HStack {
                        Button(action: {
                            // Handle terms and conditions
                        }) {
                            Text("TERMS AND CONDITIONS")
                                .underline()
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        Text("&").foregroundColor(.white)

                        Button(action: {
                            // Handle privacy policy
                        }) {
                            Text("PRIVACY POLICY")
                                .underline()
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                    .offset(y: -10)
                }
            }
        }
    }
}

struct firstPage_Previews: PreviewProvider {
    static var previews: some View {
        firstPage()
    }
}
