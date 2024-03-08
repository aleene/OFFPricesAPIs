//
//  OFFPricesPricesView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 01/03/2024.
//

import SwiftUI

struct OFFPricesPricesView: View {
    var body: some View {
        VStack {
            NavigationLink( destination: OFFPricesListView() ) {
                Text("Prices List")
            }
        }
        .navigationTitle("Prices API's")
    }
}

#Preview {
    OFFPricesPricesView()
}
