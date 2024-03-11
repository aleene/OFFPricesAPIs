//
//  OFFPricesPostPriceView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 09/03/2024.
//

import SwiftUI

class OFFPricesPostPriceModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var response: OFFPricesRequired.PricePostPatchResponse? {
        didSet {
            if let validResponse = response {
                items.append(validResponse)
            }
        }
    }
    @Published var errorMessage: String?
    
    @ObservedObject var authController = AuthController()

    fileprivate var code: String = ""
    fileprivate var name: String? = nil
    fileprivate var categoryTag: String = "en:tomatoes"
    fileprivate var labelsTag: [String] = ["en:organic"]
    fileprivate var originsTag: [String] = ["en:california"]
    fileprivate var price: Double = 0.0
    fileprivate var isDiscounted: Bool = false
    fileprivate var undiscountedPrice: Double? = nil
    fileprivate var per: OFFPricesRequired.PricePer = .unit
    fileprivate var currency: ISO4217 = .Euro
    fileprivate var locationOSMid: UInt = 1
    fileprivate var locationOSMtype: OFFPricesRequired.OSMtype = .node
    fileprivate var proofId: UInt = 1
    fileprivate var date: Date = Date()

    fileprivate var items: [OFFPricesRequired.PricePostPatchResponse] = []

    private var offSession = URLSession.shared
    
    fileprivate var dictArray: [[String:String]] {
        return items.map({ $0.dict })
    }

    // get the status
    fileprivate func update() {
        print("token ",authController.access_token)
        // get the remote data
        offSession.OFFPricesPostPrice(code: code,
                                      name: name,
                                      categoryTag: categoryTag,
                                      labelsTags: labelsTag,
                                      originsTags: originsTag,
                                      price: price,
                                      isDiscounted: isDiscounted,
                                      undiscountedPrice: undiscountedPrice,
                                      per: per,
                                      currency: currency,
                                      locationOSMid: locationOSMid,
                                      locationOSMtype: locationOSMtype,
                                      date: date,
                                      proofId: proofId,
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

struct OFFPricesPostPriceView: View {
    @StateObject var model = OFFPricesPostPriceModel()

    @ObservedObject var authController: AuthController

    @State private var code: String = ""
    @State private var name: String = ""
    @State private var categoryTag: String = "en:tomatoes"
    @State private var labelsTag: String = "en:organic"
    @State private var originsTag: String = "en:california"
    @State private var price: String = "0.001"
    @State private var isDiscounted: String = ""
    @State private var undiscountedPrice: String = ""
    @State private var per: String = "UNIT"
    @State private var currency: String = "EUR"
    @State private var locationOSMid: String = "1"
    @State private var locationOSMtype: String = "node"
    @State private var proofId: String = "1"
    @State private var date: String = ""

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if model.response != nil {
                    if model.items.isEmpty {
                        Text("No price found")
                    } else if let id = model.items.first?.id {
                        let text = "Price response for id \(id)"
                        ListView(text: text, dictArray: model.dictArray)
                    }
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Posting price")
                }
            
            }
            .navigationTitle("Post")
        } else {
            Text("This fetch posts a price.")
                .padding()
            InputView(title: "Enter new code", placeholder: "", text: $code)
                .onChange(of: code) {
                    if !code.isEmpty {
                        model.code = code
                    }
                }
            InputView(title: "Enter new price", placeholder: "0.0", text: $price)
                .onChange(of: price) {
                    if !price.isEmpty {
                        model.price = Double(price) ?? 0.0
                    }
                }
            InputView(title: "Enter isDiscounted", placeholder: "N", text: $isDiscounted)
                .onChange(of: isDiscounted) {
                    if !isDiscounted.isEmpty {
                        if isDiscounted == "N" {
                            model.isDiscounted = false
                        } else {
                            model.isDiscounted = true
                        }
                    }
                }
            InputView(title: "Enter undiscountedPrice", placeholder: "", text: $undiscountedPrice)
                .onChange(of: undiscountedPrice) {
                    if !undiscountedPrice.isEmpty {
                        model.undiscountedPrice = Double(undiscountedPrice)
                    }
                }
            InputView(title: "Enter per (UNIT/KG)", placeholder: "UNIT", text: $per)
                .onChange(of: per) {
                    if !per.isEmpty {
                        if per == "UNIT" {
                            model.per = .unit
                        } else {
                            model.per = .kilogram
                        }
                    }
                }
            InputView(title: "Enter currency", placeholder: "EUR", text: $currency)
                .onChange(of: currency) {
                    if !currency.isEmpty {
                        switch currency {
                        case ISO4217.Euro.rawValue:
                            model.currency = .Euro
                        default:
                            model.currency = .Euro
                        }
                    }
                }
            InputView(title: "Enter date (yyyy/MM/dd)", placeholder: "current date", text: $date)
                .onChange(of: date) {
                    if !date.isEmpty {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy/MM/dd"
                        model.date = formatter.date(from: date) ?? Date()
                    } else {
                        model.date = Date()
                    }
                }

            Button( action: {
                model.update()
                isFetching = true
            }) {
                Text("Post")
            }
            .font(.title)
            .navigationTitle("Post price")
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
    OFFPricesPostPriceView(authController: AuthController())
}
