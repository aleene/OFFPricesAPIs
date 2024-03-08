//
//  OFFPricesProductsListView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 01/03/2024.
//

import SwiftUI

class OFFPricesProductsListViewModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var response: OFFPricesRequired.ProductsResponse?
    @Published var errorMessage: String?
    
    fileprivate var page: UInt = 1
    fileprivate var size: UInt = 50
    fileprivate var code: String? = nil
    fileprivate var source: String? = nil
    fileprivate var name: String? = nil
    fileprivate var brand: String? = nil
    fileprivate var minimumNumberOfScans: UInt? = nil
    fileprivate var orderBy: OFFPricesRequired.ProductsOrderBy = .unordered
    fileprivate var orderDirection: OFFPricesRequired.OrderDirection = .increasing
    fileprivate var priceCount: UInt? = nil
    fileprivate var priceCountMinimum: UInt? = nil
    fileprivate var priceCountMaximum: UInt? = nil
    
    private var offPricesSession = URLSession.shared
    
    fileprivate var dictArray: [[String:String]] {
        guard let items = response?.items else { return [] }
        return items.map({ $0.dict })
    }

    // get the status
    fileprivate func update() {
        // get the remote data
        offPricesSession.OFFPricesProducts(page: page,
                                           size: size,
                                           code: code, 
                                           source: source, 
                                           productName: name, 
                                           brand: brand, 
                                           minimumNumberOfScans: minimumNumberOfScans,
                                           priceCount: priceCount,
                                           priceCountMinimum: priceCountMinimum,
                                           priceCountMaximum: priceCountMaximum,
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

struct OFFPricesProductsListView: View {
    @StateObject var model = OFFPricesProductsListViewModel()

    @State private var page: String = ""
    @State private var size: String = ""
    @State private var order: String = ""
    @State private var code: String = ""
    @State private var source: String = ""
    @State private var name: String = ""
    @State private var brand: String = ""
    @State private var minimumNumberOfScans = ""
    @State private var direction: String = ""
    @State private var priceCount: String = ""
    @State private var priceCountMinimum: String = ""
    @State private var priceCountMaximum: String = ""

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if let response = model.response {
                    if response.items != nil,
                       response.items!.count == 0 {
                        Text("No products found")

                    } else {
                        let validPage = response.page != nil ? "\(response.page!)" : "invalid page"
                        let validTotalPages = response.pages != nil ? "\(response.pages!)" : "invalid pages"
                        let text = "Products for page \(validPage)  of \(validTotalPages)"
                        ListView(text: text, dictArray: model.dictArray)
                    }
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Requesting products")
                }
            
            }
            .navigationTitle("Products")
        } else {
            Text("This fetch retrieves the products.")
                .padding()
            
            InputView(title: "Enter code", placeholder: "unused", text: $code)
                .onChange(of: code) {
                    if !code.isEmpty {
                        model.code = code
                    }
                }
            
            InputView(title: "Enter source (off)", placeholder: "unused", text: $source)
                .onChange(of: source) {
                    if !source.isEmpty {
                        model.source = source
                    }
                }

            InputView(title: "Enter name like", placeholder: "unused", text: $name)
                .onChange(of: name) {
                    if !name.isEmpty {
                        model.name = name
                    }
                }
            
            InputView(title: "Enter brand like", placeholder: "unused", text: $brand)
                .onChange(of: brand) {
                    if !brand.isEmpty {
                        model.brand = brand
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
            
            InputView(title: "Enter order field (none, id, count, ...)", placeholder: "none", text: $order)
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
            
            InputView(title: "Enter lower limit price count", placeholder: "unused", text: $priceCountMinimum)
                .onChange(of: priceCountMinimum) {
                    if !priceCountMinimum.isEmpty {
                        model.priceCountMinimum = UInt(priceCountMinimum)
                    }
                }
            
            InputView(title: "Enter upper limit price count", placeholder: "unused", text: $priceCountMaximum)
                .onChange(of: priceCountMaximum) {
                    if !priceCountMaximum.isEmpty {
                        model.priceCountMaximum = UInt(priceCountMaximum)
                    }
                }

            Button( action: {
                model.update()
                isFetching = true
            }) {
                Text("Fetch products")
            }
            .font(.title)
            .navigationTitle("Products")
            .onAppear {
                isFetching = false
            }

        }
    }
}

#Preview {
    OFFPricesProductsListView()
}
