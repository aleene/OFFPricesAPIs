//
//  OFFPricesStatusView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 26/02/2024.
//

import SwiftUI

class OFFPricesStatusViewModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var statusResponse: OFFPricesRequired.StatusResponse?

    fileprivate var errorMessage: String?

    private var offPricesSession = URLSession.shared
    
    // get the status
    fileprivate func update() {
        // get the remote data
        offPricesSession.OFFPricesStatus() { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.statusResponse = response
                case .failure(let error):
                    self.errorMessage = error.description
                }
            }
        }
    }
}
struct OFFPricesStatusView: View {
    
    @StateObject var model = OFFPricesStatusViewModel()

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if let status = model.statusResponse?.status {
                
                    Text(status)
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Requesting status")
                }
            
            }
            .navigationTitle("Prices Status")
        } else {
            Text("This fetch retrieves the status of the server.")
            Button( action: {
                model.update()
                isFetching = true
            }) {
                Text("Fetch status")
            }
            .font(.title)
            .navigationTitle("Server status")
            .onAppear {
                isFetching = false
            }

        }
    }

}

#Preview {
    OFFPricesStatusView()
}
