//
//  Trooper_newApp.swift
//  Trooper_new
//
//  Created by D Vijay Vardhan Reddy on 17/01/24.
//

import SwiftUI
//import GoogleSignIn

@main
struct Trooper_newApp: App {
    @StateObject private var loginViewModel = LoginViewModel()

        var body: some Scene {
            WindowGroup {
                if !loginViewModel.isLoggedIn {
                    firstPage()
                        .environmentObject(loginViewModel)
                } else {
                    BottomBarView()
                        .environmentObject(loginViewModel)
                }
            }
        }
}
