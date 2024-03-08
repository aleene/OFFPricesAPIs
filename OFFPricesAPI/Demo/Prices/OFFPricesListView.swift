//
//  OFFPricesListView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 01/03/2024.
//

import SwiftUI

class OFFPricesPricesListViewModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var response: OFFPricesRequired.PricesResponse?
    @Published var errorMessage: String?
    
    fileprivate var page: UInt = 1
    fileprivate var size: UInt = 50
    fileprivate var orderBy: OFFPricesRequired.PricesOrderBy = .unordered
    fileprivate var orderDirection: OFFPricesRequired.OrderDirection = .increasing
    fileprivate var product_code: String? = nil
    fileprivate var product_id: UInt? = nil
    fileprivate var product_id__isnull: Bool? = nil
    fileprivate var category_tag: String? = nil
    fileprivate var location_ism_id: UInt? = nil
    fileprivate var location_osm_type: String? = nil
    fileprivate var location_id: UInt? = nil
    fileprivate var price: Double? = nil
    fileprivate var price_is_discounted: Bool? = nil
    fileprivate var price__gt: Double? = nil
    fileprivate var price__gte: Double? = nil
    fileprivate var price__lt: Double? = nil
    fileprivate var price__lte: Double? = nil
    fileprivate var currency: String? = nil
    fileprivate var date: String? = nil
    fileprivate var date__gt : String? = nil
    fileprivate var date__gte: String? = nil
    fileprivate var date__lt: String? = nil
    fileprivate var date__lte: String? = nil
    fileprivate var proof_id: UInt? = nil
    fileprivate var owner: String? = nil
    fileprivate var created_gte: String? = nil
    fileprivate var created_lte: String? = nil

    private var offSession = URLSession.shared
    
    fileprivate var dictArray: [[String:String]] {
        guard let items = response?.items else { return [] }
        return items.map({ $0.dict })
    }

    // get the status
    fileprivate func update() {
        // get the remote data
        offSession.OFFPricesPrices(page: page,
                                   size: size,
                                   orderBy: orderBy,
                                   orderDirection: orderDirection,
                                   product_code: product_code,
                                   product_id: product_id,
                                   product_id__isnull: product_id__isnull,
                                   category_tag: category_tag,
                                   location_ism_id: location_ism_id,
                                   location_osm_type: location_osm_type,
                                   location_id: location_id,
                                   price: price,
                                   price_is_discounted: price_is_discounted,
                                   price__gt: price__gt,
                                   price__gte: price__gte,
                                   price__lt: price__lt,
                                   price__lte: price__lte,
                                   currency: currency,
                                   date: date,
                                   date__gt: date__gt,
                                   date__gte: date__gte,
                                   date__lt: date__lt,
                                   date__lte: date__lte,
                                   proof_id: proof_id,
                                   owner: owner,
                                   created_gte: created_gte,
                                   created_lte: created_lte) { (result) in
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

struct OFFPricesListView: View {
    @StateObject var model = OFFPricesPricesListViewModel()

    @State private var page: String = ""
    @State private var size: String = ""
    @State private var orderBy: String = ""
    @State private var orderDirection: String = ""
    @State private var product_code: String = ""
    @State private var product_id: String = ""
    @State private var product_id__isnull: String = ""
    @State private var category_tag: String = ""
    @State private var location_ism_id: String = ""
    @State private var location_osm_type: String = ""
    @State private var location_id: String = ""
    @State private var price: String = ""
    @State private var price_is_discounted: String = ""
    @State private var price__gt: String = ""
    @State private var price__gte: String = ""
    @State private var price__lt: String = ""
    @State private var price__lte: String = ""
    @State private var currency: String = ""
    @State private var date: String = ""
    @State private var date__gt : String = ""
    @State private var date__gte: String = ""
    @State private var date__lt: String = ""
    @State private var date__lte: String = ""
    @State private var proof_id: String = ""
    @State private var owner: String = ""
    @State private var created_gte: String = ""
    @State private var created_lte: String = ""

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if let response = model.response {
                    if response.items != nil,
                       response.items!.count == 0 {
                        Text("No prices found")

                    } else {
                        let validPage = response.page != nil ? "\(response.page!)" : "invalid page"
                        let validTotalPages = response.pages != nil ? "\(response.pages!)" : "invalid pages"
                        let text = "Prices for page \(validPage)  of \(validTotalPages)"
                        ListView(text: text, dictArray: model.dictArray)
                    }
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Requesting prices")
                }
            
            }
            .navigationTitle("Prices")
        } else {
            Text("This fetch retrieves the prices.")
                .padding()
            
            InputView(title: "Enter product_code", placeholder: "unused", text: $product_code)
                .onChange(of: product_code) {
                    if !product_code.isEmpty {
                        model.product_code = product_code
                    }
                }
            
            InputView(title: "Enter product_id", placeholder: "unused", text: $product_id)
                .onChange(of: product_id) {
                    if !product_id.isEmpty {
                        model.product_id = UInt(product_id)
                    }
                }

            InputView(title: "Enter location_ism_id", placeholder: "unused", text: $location_ism_id)
                .onChange(of: location_ism_id) {
                    if !location_ism_id.isEmpty {
                        model.location_ism_id = UInt(location_ism_id)
                    }
                }
            
            InputView(title: "Enter location_id", placeholder: "unused", text: $location_id)
                .onChange(of: location_id) {
                    if !location_id.isEmpty {
                        model.location_id = UInt(location_id)
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
            
            InputView(title: "Enter order field (none, price, product_code, ...)", placeholder: "none", text: $orderBy)
                .onChange(of: orderBy) {
                    if orderBy == "price" {
                        model.orderBy = .price
                    } else if orderBy == "product_code" {
                        model.orderBy = .product_code
                    } else {
                        model.orderBy = .unordered
                    }
                }
            
            InputView(title: "Enter order direction (+ or -)", placeholder: "+", text: $orderDirection)
                .onChange(of: orderDirection) {
                    if orderDirection == "-" {
                        model.orderDirection = .decreasing
                    } else {
                        model.orderDirection = .increasing
                    }
                }
            
            InputView(title: "Enter specific price", placeholder: "unused", text: $price)
                .onChange(of: price) {
                    if !price.isEmpty {
                        model.price = Double(price)
                    }
                }
            
            InputView(title: "Enter lower limit price", placeholder: "unused", text: $price__gte)
                .onChange(of: price__gte) {
                    if !price__gte.isEmpty {
                        model.price__gte = Double(price__gte)
                    }
                }
            
            InputView(title: "Enter upper limit price count", placeholder: "unused", text: $price__lte)
                .onChange(of: price__lte) {
                    if !price__lte.isEmpty {
                        model.price__lte = Double(price__lte)
                    }
                }

            Button( action: {
                model.update()
                isFetching = true
            }) {
                Text("Fetch prices")
            }
            .font(.title)
            .navigationTitle("Prices")
            .onAppear {
                isFetching = false
            }

        }
    }
}

#Preview {
    OFFPricesListView()
}
