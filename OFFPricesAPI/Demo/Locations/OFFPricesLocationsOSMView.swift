//
//  OFFPricesLocationsOSMView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 29/02/2024.
//

import SwiftUI

class OFFPricesLocationsOSMViewModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var response: OFFPricesRequired.Location? {
        didSet {
            if let validResponse = response {
                items.append(validResponse)
            }
        }
    }
    @Published var errorMessage: String?
    
    fileprivate var osmType: OFFPricesRequired.OSMtype = .node
    fileprivate var osmID: UInt = 1582865334
    
    fileprivate var items: [OFFPricesRequired.Location] = []
    private var offPricesSession = URLSession.shared
    
    fileprivate var usersDictArray: [[String:String]] {
        return items.map({ $0.dict })
    }

    // get the status
    fileprivate func update() {
        // get the remote data
        offPricesSession.OFFPricesLocations(type: osmType,
                                        id: osmID ) { (result) in
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

struct OFFPricesLocationsOSMView: View {
    @StateObject var model = OFFPricesLocationsOSMViewModel()

    @State private var type: String = "node"
    @State private var id: String = "1582865334"

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if model.response != nil {
                    if model.items.isEmpty {
                        Text("No locations found")

                    } else {
                        let text = "Location for OSM id \(model.osmID)  of type \(model.osmType.rawValue)"
                        ListView(text: text, dictArray: model.usersDictArray)
                    }
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Requesting locations")
                }
            
            }
            .navigationTitle("Locations")
        } else {
            Text("This fetch retrieves an OSM location.")
                .padding()
            
            InputView(title: "Enter osm id", placeholder: "1582865334", text: $id)
                .onChange(of: id) {
                    if !id.isEmpty {
                        model.osmID = UInt(id) ?? 1582865334
                    }
                }
                        
            InputView(title: "Enter osm type (node, way, relation", placeholder: "node", text: $type)
                .onChange(of: type) {
                    if type == "way" {
                        model.osmType = .way
                    } else if type == "relation" {
                        model.osmType = .relation
                    } else {
                        model.osmType = .node
                    }
                }
            
            Button( action: {
                model.update()
                isFetching = true
            }) {
                Text("Fetch OSM location")
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
    OFFPricesLocationsOSMView()
}
