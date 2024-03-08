//
//  OFFPricesUsersSortedView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 27/02/2024.
//

import SwiftUI

class OFFPricesUsersSortedViewModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var usersResponse: OFFPricesRequired.UsersResponse?
    @Published var errorMessage: String?
    
    fileprivate var page: UInt = 1
    fileprivate var size: UInt = 50
    fileprivate var orderBy: OFFPricesRequired.UsersOrderBy = .unordered
    fileprivate var orderDirection: OFFPricesRequired.OrderDirection = .increasing

    private var offPricesSession = URLSession.shared
    
    fileprivate var usersDictArray: [[String:String]] {
        guard let items = usersResponse?.items else { return [] }
        return items.map({ $0.dict })
    }

    // get the status
    fileprivate func update() {
        // get the remote data
        offPricesSession.OFFPricesUsers(page: page,
                                        size: size,
                                        orderBy: orderBy,
                                        orderDirection: orderDirection) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.usersResponse = response
                case .failure(let error):
                    self.errorMessage = error.description
                }
            }
        }
    }
}

struct OFFPricesUsersSortedView: View {
    
    @StateObject var model = OFFPricesUsersSortedViewModel()

    @State private var page: String = ""
    @State private var size: String = ""
    @State private var order: String = ""
    @State private var direction: String = ""

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if let response = model.usersResponse {
                    if response.items != nil,
                       response.items!.count == 0 {
                        Text("No users found")

                    } else {
                        
                        let validPage = response.page != nil ? "\(response.page!)" : "invalid"
                        let validTotalPages = response.pages != nil ? "\(response.pages!)" : "invalid"
                        let text = "Users for page \(validPage)  of \(validTotalPages)"
                        ListView(text: text, dictArray: model.usersDictArray)
                    }
                } else if model.errorMessage != nil {
                    Text(model.errorMessage!)
                } else {
                    Text("Requesting users")
                }
            
            }
            .navigationTitle("Users")
        } else {
            Text("This fetch retrieves the users.")
                .padding()
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
            
            InputView(title: "Enter order field (none, user, count)", placeholder: "none", text: $order)
                .onChange(of: order) {
                    if order == "user" {
                        model.orderBy = .userId
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

            Button( action: {
                model.update()
                isFetching = true
            }) {
                Text("Fetch users")
            }
            .font(.title)
            .navigationTitle("Users")
            .onAppear {
                isFetching = false
            }

        }
    }

}

#Preview {
    OFFPricesUsersSortedView()
}
