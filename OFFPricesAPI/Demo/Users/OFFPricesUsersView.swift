//
//  OFFPricesUsersView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 27/02/2024.
//

import SwiftUI

struct OFFPricesUsersView: View {
    var body: some View {
        VStack {
            NavigationLink( destination: OFFPricesUsersBasicView() ) {
                Text("Users Basic API")
            }
            NavigationLink( destination: OFFPricesUsersSortedView() ) {
                Text("Users Sorted API")
            }
            NavigationLink( destination: OFFPricesUsersSortedAndFilteredView() ) {
                Text("Users Sorted and Filtered API")
            }

        }
        .navigationTitle("OFF Users API's")
    }
}

#Preview {
    OFFPricesUsersView()
}
