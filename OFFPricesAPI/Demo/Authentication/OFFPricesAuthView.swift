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
            NavigationLink( destination: OFFPricesSessionView() ) {
                Text("Session Endpoint API (authenticate first)")
            }
            NavigationLink( destination: OFFPricesDeleteSessionView() ) {
                Text("Delete Session Endpoint API (authenticate first)")
            }

        }
        .navigationTitle("Authentication Endpoint API's")
    }
}

#Preview {
    OFFPricesAuthView(authController: AuthController() )
}
