//
//  OFFPricesDeletePriceView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 09/03/2024.
//

import SwiftUI

class OFFPricesDeletePriceViewModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var response: String?
    @Published var errorMessage: String?
    
    @ObservedObject var authController = AuthController()

    fileprivate var priceID: UInt = 1

    private var offSession = URLSession.shared
    
    // get the status
    fileprivate func update() {
        print("token ",authController.access_token)
        // get the remote data
        offSession.OFFPricesDeletePrice(priceID: priceID,
                                        token: authController.access_token) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.response = response
                case .failure(let error):
                    self.errorMessage = error.description
                }
            }
        }
    }
}

struct OFFPricesDeletePriceView: View {
    @StateObject var model = OFFPricesDeletePriceViewModel()

    @ObservedObject var authController: AuthController

    @State private var priceID: String = ""

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if let text = model.response {
                        Text(text)
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Deleting price")
                }
            
            }
            .navigationTitle("Delete")
        } else {
            Text("This fetch deletes a price.")
                .padding()
            InputView(title: "Enter priceID", placeholder: "", text: $priceID)
                .onChange(of: priceID) {
                    if !priceID.isEmpty {
                        model.priceID = UInt(priceID) ?? 0
                    }
                }
            Button( action: {
                model.update()
                isFetching = true
            }) {
                Text("Delete")
            }
            .font(.title)
            .navigationTitle("Delete price")
            .onAppear {
                isFetching = false
            }
            . onAppear() {
                model.authController = authController
                }
        }
    }
}

#Preview {
    OFFPricesDeletePriceView(authController: AuthController())
}
