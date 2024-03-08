//
//  OFFPricesLocationsNodeView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 01/03/2024.
//

import SwiftUI

class OFFPricesLocationsNodeViewModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var response: OFFPricesRequired.Location? {
        didSet {
            if let validResponse = response {
                items.append(validResponse)
            }
        }
    }
    @Published var errorMessage: String?
    
    fileprivate var id: UInt = 26
    
    fileprivate var items: [OFFPricesRequired.Location] = []
    private var offPricesSession = URLSession.shared
    
    fileprivate var usersDictArray: [[String:String]] {
        return items.map({ $0.dict })
    }

    // get the status
    fileprivate func update() {
        // get the remote data
        offPricesSession.OFFPricesLocations(id: id) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.response = response
                case .failure(let error):
                    switch error {
                    case .notFound (let message):
                        self.errorMessage = message
                    default:
                        self.errorMessage = "Error not handled"
                    }
                }
                return
            }
        }
    }
}

struct OFFPricesLocationsNodeView: View {
    @StateObject var model = OFFPricesLocationsNodeViewModel()

    @State private var id: String = "26"

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if model.response != nil {
                    if model.items.isEmpty {
                        Text("No location found")
                    } else {
                        let text = "Location for id \(model.id)"
                        ListView(text: text, dictArray: model.usersDictArray)
                    }
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Requesting location")
                }
            
            }
            .navigationTitle("Locations")
        } else {
            Text("This fetch retrieves an OFF Prices location.")
                .padding()
            
            InputView(title: "Enter id", placeholder: "26", text: $id)
                .onChange(of: id) {
                    if !id.isEmpty {
                        model.id = UInt(id) ?? 26
                    }
                }
                                    
            Button( action: {
                model.update()
                isFetching = true
            }) {
                Text("Fetch location")
            }
            .font(.title)
            .navigationTitle("Locations")
            .onAppear {
                isFetching = false
            }

        }
    }
}

#Preview {
    OFFPricesLocationsNodeView()
}
