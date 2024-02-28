//
//  ContentView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 26/02/2024.
//

import SwiftUI

struct OFFPricesView: View {
    
     
     var body: some View {
         VStack {
             NavigationLink( destination: OFFPricesStatusView() ) {
                 Text("Status API's")
             }
             NavigationLink( destination: OFFPricesUsersView() ) {
                 Text("Users API's")
             }
             NavigationLink( destination: OFFPricesLocationsView() ) {
                 Text("Locations API's")
             }
             /*

             NavigationLink( destination: nil
                            // OFFPricesPricesView()
                           ) {
                 Text("Prices API's")
             }
             NavigationLink( destination: nil
                            // OFFPricesProofsView()
                           ) {
                 Text("Proofs API's")
             }
             NavigationLink( destination: nil
                             // OFFPricesProductsView() 
                           ) {
                 Text("Products API's")
             }
             NavigationLink( destination: nil
                             // OFFPricesLocationsView()
                           ) {
                 Text("Locations API's")
             }
*/
         }
         .navigationTitle("OFF Prices API's")
     }
 }

 // Give an overview of all Prices API's
 struct OFFPricesView_Previews: PreviewProvider {
     static var previews: some View {
         OFFPricesView()
     }
 }
