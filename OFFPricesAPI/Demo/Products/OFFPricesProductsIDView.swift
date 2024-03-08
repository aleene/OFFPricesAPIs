//
//  OFFPricesProductsIDView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 01/03/2024.
//

import SwiftUI

class OFFPricesProductsIDViewModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var response: OFFPricesRequired.Product? {
        didSet {
            if let validResponse = response {
                items.append(validResponse)
            }
        }
    }
    @Published var errorMessage: String?
    
    fileprivate var id: UInt = 26
    
    fileprivate var items: [OFFPricesRequired.Product] = []
    private var offPricesSession = URLSession.shared
    
    fileprivate var dictArray: [[String:String]] {
        return items.map({ $0.dict })
    }

    // get the status
    fileprivate func update() {
        // get the remote data
        offPricesSession.OFFPricesProducts(id: id) { (result) in
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

struct OFFPricesProductsIDView: View {
    @StateObject var model = OFFPricesProductsIDViewModel()

    @State private var id: String = "26"

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if model.response != nil {
                    if model.items.isEmpty {
                        Text("No products found")

                    } else {
                        let text = "Product for id \(model.id)"
                        ListView(text: text, dictArray: model.dictArray)
                    }
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Requesting product")
                }
            
            }
            .navigationTitle("Products")
        } else {
            Text("This fetch retrieves an OFF Prices products.")
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
                Text("Fetch product")
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
    OFFPricesProductsIDView()
}
