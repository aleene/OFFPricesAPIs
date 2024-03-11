//
//  OFFPricesDeleteSessionView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 11/03/2024.
//

import SwiftUI

class OFFPricesDeleteSessionViewModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var response: OFFPricesRequired.SessionDeleteResponse?
    @Published var errorMessage: String?

    private var session = URLSession.shared
    
    // get the status
    fileprivate func update() {
        // get the remote data
        session.OFFPricesDeleteSession() { (result) in
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

struct OFFPricesDeleteSessionView: View {
    @StateObject var model = OFFPricesDeleteSessionViewModel()

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if let status = model.response?.status {
                    Text(status)
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Deleting session")
                }
            
            }
            .navigationTitle("Session Deletion")
        } else {
            Text("This endpoint deletes the current session.")
            Button( action: {
                model.update()
                isFetching = true
            }) {
                Text("Delete session")
            }
            .font(.title)
            .navigationTitle("Session deletion")
            .onAppear {
                isFetching = false
            }

        }
    }
}

#Preview {
    OFFPricesDeleteSessionView()
}
