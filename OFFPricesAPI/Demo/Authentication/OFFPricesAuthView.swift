//
//  OFFPricesAuthView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 08/03/2024.
//

import SwiftUI

struct OFFPricesAuthView: View {
    
    @ObservedObject var authController: AuthController

    var body: some View {
        VStack {
            NavigationLink( destination: OFFPricesAuthenticationView(authController: authController) ) {
                Text("Auth Endpoint API ")
            }
            NavigationLink( destination: OFFPricesSession() ) {
                Text("Session Endpoint API (session cookies not supported)")
            }
        }
        .navigationTitle("Authentication Endpoint API's")
    }
}

#Preview {
    OFFPricesAuthView(authController: AuthController() )
}
