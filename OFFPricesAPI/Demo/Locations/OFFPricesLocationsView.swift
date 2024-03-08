//
//  OFFPricesLocationsView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 28/02/2024.
//

import SwiftUI

struct OFFPricesLocationsView: View {
    var body: some View {
        VStack {
            NavigationLink( destination: OFFPricesLocationsSortedAndFilteredView() ) {
                Text("Locations Sorted and Filtered API")
            }
            NavigationLink( destination: OFFPricesLocationsOSMView() ) {
                Text("OSM node location")
            }
            NavigationLink( destination: OFFPricesLocationsNodeView() ) {
                Text("OFF Prices node location")
            }

        }
        .navigationTitle("Locations Users API's")
    }
}

#Preview {
    OFFPricesLocationsView()
}
