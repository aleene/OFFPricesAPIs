//
//  OFFPricesProductsView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 01/03/2024.
//

import SwiftUI

struct OFFPricesProductsView: View {
    var body: some View {
        VStack {
            NavigationLink( destination: OFFPricesProductsIDView() ) {
                Text("Product ID")
            }
            NavigationLink( destination: OFFPricesProductsBarcodeView() ) {
                Text("Product barcode")
            }
            NavigationLink( destination: OFFPricesProductsListView() ) {
                Text("Products list")
            }
        }
        .navigationTitle("Products API's")
    }
}

#Preview {
    OFFPricesProductsView()
}
