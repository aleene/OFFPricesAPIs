//
//  OFFPricesLocationsSortedAndFilteredView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 28/02/2024.
//

import SwiftUI

class OFFPricesLocationsSortedAndFilteredViewModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var response: OFFPricesRequired.LocationsResponse?
    @Published var errorMessage: String?
    
    fileprivate var page: UInt = 1
    fileprivate var size: UInt = 50
    fileprivate var osmName: String? = nil
    fileprivate var osmAddressCountry: String? = nil
    fileprivate var orderBy: OFFPricesRequired.LocationsOrderBy = .unordered
    fileprivate var orderDirection: OFFPricesRequired.OrderDirection = .increasing
    fileprivate var priceCount: UInt? = nil
    fileprivate var priceCountLowerLimit: UInt? = nil
    fileprivate var priceCountUpperLimit: UInt? = nil
    
    private var offPricesSession = URLSession.shared
    
    fileprivate var usersDictArray: [[String:String]] {
        guard let items = response?.items else { return [] }
        return items.map({ $0.dict })
    }

    // get the status
    fileprivate func update() {
        // get the remote data
        offPricesSession.OFFPricesLocations(page: page,
                                            size: size,
                                            osmName: osmName,
                                            osmAddressCountry: osmAddressCountry,
                                            priceCount: priceCount,
                                            priceCountGte: priceCountLowerLimit,
                                            priceCountLte: priceCountUpperLimit,
                                            orderBy: orderBy,
                                            orderDirection: orderDirection ) { (result) in
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

struct OFFPricesLocationsSortedAndFilteredView: View {
    @StateObject var model = OFFPricesLocationsSortedAndFilteredViewModel()

    @State private var page: String = ""
    @State private var size: String = ""
    @State private var order: String = ""
    @State private var osmNameLike: String = ""
    @State private var osmNameCountry: String = ""
    @State private var direction: String = ""
    @State private var priceCount: String = ""
    @State private var priceCountLower: String = ""
    @State private var priceCountUpper: String = ""

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if let response = model.response {
                    if response.items != nil,
                       response.items!.count == 0 {
                        Text("No locations found")

                    } else {
                        let validPage = response.page != nil ? "\(response.page!)" : "invalid page"
                        let validTotalPages = response.pages != nil ? "\(response.pages!)" : "invalid pages"
                        let text = "Locations for page \(validPage)  of \(validTotalPages)"
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
            Text("This fetch retrieves the locations.")
                .padding()
            
            InputView(title: "Enter osm name like", placeholder: "unused", text: $osmNameLike)
                .onChange(of: osmNameLike) {
                    if !osmNameLike.isEmpty {
                        model.osmName = osmNameLike
                    }
                }
            
            InputView(title: "Enter osm address country like", placeholder: "unused", text: $osmNameCountry)
                .onChange(of: osmNameCountry) {
                    if !osmNameCountry.isEmpty {
                        model.osmAddressCountry = osmNameCountry
                    }
                }

            InputView(title: "Enter specific page count", placeholder: "unused", text: $priceCount)
                .onChange(of: priceCount) {
                    if !priceCount.isEmpty {
                        model.priceCount = UInt(priceCount)
                    }
                }

            InputView(title: "Enter page number", placeholder: "\(model.page)", text: $page)
                .onChange(of: page)  {
                    if !page.isEmpty {
                        model.page = UInt(page) ?? model.page
                    }
                }
            InputView(title: "Enter page size", placeholder: "\(model.size)", text: $size)
                .onChange(of: size) {
                    if !size.isEmpty {
                        model.size = UInt(size) ?? model.size
                    }
                }
            
            InputView(title: "Enter order field (none, osm_id, id, count, ...)", placeholder: "none", text: $order)
                .onChange(of: order) {
                    if order == "user" {
                        model.orderBy = .id
                    } else if order == "count" {
                        model.orderBy = .priceCount
                    } else {
                        model.orderBy = .unordered
                    }
                }
            
            InputView(title: "Enter order direction (+ or -)", placeholder: "+", text: $direction)
                .onChange(of: direction) {
                    if direction == "-" {
                        model.orderDirection = .decreasing
                    } else {
                        model.orderDirection = .increasing
                    }
                }
            
            InputView(title: "Enter specific price count", placeholder: "unused", text: $priceCount)
                .onChange(of: priceCount) {
                    if !priceCount.isEmpty {
                        model.priceCount = UInt(priceCount)
                    }
                }
            
            InputView(title: "Enter lower limit price count", placeholder: "unused", text: $priceCountLower)
                .onChange(of: priceCountLower) {
                    if !priceCountLower.isEmpty {
                        model.priceCountLowerLimit = UInt(priceCountLower)
                    }
                }
            
            InputView(title: "Enter upper limit price count", placeholder: "unused", text: $priceCountUpper)
                .onChange(of: priceCountUpper) {
                    if !priceCountLower.isEmpty {
                        model.priceCountUpperLimit = UInt(priceCountUpper)
                    }
                }

            Button( action: {
                model.update()
                isFetching = true
            }) {
                Text("Fetch locations")
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
    OFFPricesLocationsSortedAndFilteredView()
}
