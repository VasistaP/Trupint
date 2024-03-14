//
//  ContextView2.swift
//  Trooper_App
//
//  Created by D Vijay Vardhan Reddy on 17/01/24.
//

import SwiftUI


struct ContentView2: View {
    @State var username=""
    @State var password=""
    @State var wrongPassword=0
    @State var wrongUsernme=0
    @State var loadScreen = false
    @State var getin=0
    @State var SignIn=false
    @State var signUp=false
    var body: some View {
        NavigationView {
            
            ZStack{
                Color.white.ignoresSafeArea()
                
                
                
                VStack{
                    
                    Image("trooper_Icon")
                    Text("Login").font(.largeTitle).bold().padding()
                    TextField ("Username", text:
                                $username).padding().frame (width: 300,height: 50).background (Color.black.opacity(0.05))
                        .cornerRadius (10)
                        .border(.red, width: CGFloat(wrongUsernme))
                    
                    SecureField ("Password", text:
                                $password).padding().frame (width: 300,height: 50).background (Color.black.opacity(0.05)).cornerRadius (10)
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    Button("Login"){
                        authenticateUsers(username: username, password: password)
                        
                        
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(width:300,height:50)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .border(.blue, width: CGFloat(getin))
                    
                
                        
                        VStack {
                            // Your view content here...
                            
                            // NavigationLink using the updated initializer
                            NavigationLink(
                                destination: BottomBarView(),
                                isActive: $loadScreen,
                                label: {
                                    EmptyView()
                                }
                            )
                           
                            
    // Button to simulate navigation activation
                        }
                        
                    
                    
                }
                
            }
            
        }.navigationBarBackButtonHidden(true)
        
       
    }
    func authenticateUsers(username:String,password: String){
        if username.lowercased() == "vardhan.dumbala@gmail.com"{
            wrongUsernme=0
            if password == "Vardhan5"{
                wrongPassword = 0
                loadScreen=true
                getin=3
            }else{
                wrongPassword=2
            }
        }else{
            wrongUsernme=2
        }
        
    }
        
}
#Preview {
    ContentView2()
}
