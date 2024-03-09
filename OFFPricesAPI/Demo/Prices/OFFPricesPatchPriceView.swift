//
//  OFFPricesPatchPriceView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 08/03/2024.
//

import SwiftUI

class OFFPricesPatchPriceModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var response: OFFPricesRequired.PricePatchResponse? {
        didSet {
            if let validResponse = response {
                items.append(validResponse)
            }
        }
    }
    @Published var errorMessage: String?
    
    @ObservedObject var authController = AuthController()

    fileprivate var priceID: UInt = 14982
    fileprivate var price: Double = 0.0
    fileprivate var isDiscounted: Bool? = nil
    fileprivate var undiscountedPrice: Double? = nil
    fileprivate var per: OFFPricesRequired.PricePer = .kilogram
    fileprivate var currency: ISO4217 = .Euro
    fileprivate var date: Date = Date()

    fileprivate var items: [OFFPricesRequired.PricePatchResponse] = []

    private var offSession = URLSession.shared
    
    fileprivate var dictArray: [[String:String]] {
        return items.map({ $0.dict })
    }

    // get the status
    fileprivate func update() {
        print("token ",authController.access_token)
        // get the remote data
        offSession.OFFPricesPatchPrice(priceID: priceID,
                                       price: price,
                                       isDiscounted: isDiscounted ?? false,
                                       undiscountedPrice: undiscountedPrice,
                                       per: per,
                                       currency: currency,
                                       date: date,
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

struct OFFPricesPatchPriceView: View {
    @StateObject var model = OFFPricesPatchPriceModel()

    @ObservedObject var authController: AuthController

    @State private var id: String = "14982"
    @State private var price: String = "0.0"
    @State private var isDiscounted: String = ""
    @State private var undiscountedPrice: String = ""
    @State private var per: String = ""
    @State private var currency: String = "EUR"
    @State private var date: String = ""

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if model.response != nil {
                    if model.items.isEmpty {
                        Text("No price found")
                    } else {
                        let text = "Location for id \(model.priceID)"
                        ListView(text: text, dictArray: model.dictArray)
                    }
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Patching price")
                }
            
            }
            .navigationTitle("Patch")
        } else {
            Text("This fetch patches a price.")
                .padding()
            
            InputView(title: "Enter price id", placeholder: "14982", text: $id)
                .onChange(of: id) {
                    if !id.isEmpty {
                        model.priceID = UInt(id) ?? 14982
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
                        model.undiscountedPrice = Double(undiscountedPrice) ?? nil
                    }
                }
            InputView(title: "Enter per (UNIT/KG)", placeholder: "KG", text: $per)
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
                Text("Patch")
            }
            .font(.title)
            .navigationTitle("Patch prices")
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
    OFFPricesPatchPriceView(authController: AuthController())
}
