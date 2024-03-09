//
//  OFFPricesAPIApp.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 26/02/2024.
//

import SwiftUI

@main
struct OFFPricesAPIApp: App {
    
/// Every API call should get the tokens here
    @StateObject private var authController = AuthController()

    var body: some Scene {
        WindowGroup {
            NavigationView() {
                OFFPricesView(authController: authController)
            }
        }
    }
}
