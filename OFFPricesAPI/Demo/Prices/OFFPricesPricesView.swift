//
//  OFFPricesPricesView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 01/03/2024.
//

import SwiftUI


struct OFFPricesPricesView: View {

    @ObservedObject var authController: AuthController

    var body: some View {
        
        VStack {
            
            NavigationLink( destination: OFFPricesPricesListView() ) {
                Text("Prices List")
                
            }
            NavigationLink( destination: OFFPricesPostPriceView(authController: authController) ) {
                Text("Post Price (authenticate first)")
            }

            NavigationLink( destination: OFFPricesPatchPriceView(authController: authController) ) {
                Text("Patch Price (authenticate first)")
            }
            NavigationLink( destination: OFFPricesDeletePriceView(authController: authController) ) {
                Text("Delete Price (authenticate first)")
            }

        }
        .navigationTitle("Prices API's")
    }

}

struct OFFPricesPricesView_Previews: PreviewProvider {
    static var previews: some View {
        OFFPricesPricesView(authController: AuthController())
    }
}
