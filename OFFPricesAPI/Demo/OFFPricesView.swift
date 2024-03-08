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
             NavigationLink( destination: OFFPricesLocationsView() ) {
                 Text("Locations Endpoint API's")
             }
             NavigationLink( destination: OFFPricesPricesView() ) {
                 Text("Prices Endpoint API's")
             }
             NavigationLink( destination: OFFPricesProductsView() ) {
                 Text("Products Endpoint API's")
             }
             NavigationLink( destination: OFFPricesStatusView() ) {
                 Text("Status Endpoint API's")
             }
             NavigationLink( destination: OFFPricesUsersView() ) {
                 Text("Users Endpoint API's")
             }
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
