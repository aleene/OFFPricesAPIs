//
//  OFFPricesSession.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 08/03/2024.
//

import SwiftUI

class OFFPricesSessionViewModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var response: OFFPricesRequired.SessionResponse?
    @Published var errorMessage: String?

    private var session = URLSession.shared
    
    // get the status
    fileprivate func update() {
        // get the remote data
        session.OFFPricesSession() { (result) in
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

struct OFFPricesSession: View {
    
    @StateObject var model = OFFPricesSessionViewModel()

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if let user_id = model.response?.user_id {
                
                    Text(user_id)
                    Text(model.response!.created ?? "no created")
                    Text(model.response!.last_used ?? "no last_used")
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Requesting session status")
                }
            
            }
            .navigationTitle("Session Status")
        } else {
            Text("This fetch retrieves the status of the session.")
            Button( action: {
                model.update()
                isFetching = true
            }) {
                Text("Fetch session status")
            }
            .font(.title)
            .navigationTitle("Session status")
            .onAppear {
                isFetching = false
            }

        }
    }
}

#Preview {
    OFFPricesSession()
}
