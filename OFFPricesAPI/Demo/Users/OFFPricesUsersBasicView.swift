//
//  OFFPricesUsersView.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 27/02/2024.
//

import SwiftUI

class OFFPricesUsersViewModel: ObservableObject {
    
    // variable that needs to be tracked by the view
    @Published var usersResponse: OFFPricesRequired.UsersResponse?

    fileprivate var errorMessage: String?
    fileprivate var page: UInt = 1
    fileprivate var size: UInt = 1

    private var offPricesSession = URLSession.shared
    
    fileprivate var usersDictArray: [[String:String]] {
        guard let items = usersResponse?.items else { return [] }
        return items.map({ $0.dict })
    }

    // get the status
    fileprivate func update() {
        // get the remote data
        offPricesSession.OFFPricesUsers(page: page,
                                        size: size) { (result) in
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

struct OFFPricesUsersView: View {
    
    @StateObject var model = OFFPricesUsersViewModel()

    @State private var page: String = ""
    @State private var size: String = ""

    @State private var isFetching = false
    
    var body: some View {
        if isFetching {
            VStack {
                if let response = model.usersResponse {
                    let validPage = response.page != nil ? "\(response.page!)" : "invalid"
                    let validTotalPages = response.page != nil ? "\(response.pages!)" : "invalid"
                    let text = "Users for page \(validPage)  of \(validTotalPages)"
                    ListView(text: text, dictArray: model.usersDictArray)

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
            InputView(title: "Enter page number", placeholder: "1", text: $page)
                .onChange( of: page)  {
                    if !page.isEmpty {
                        model.page = UInt(page) ?? 0
                    }
                }
            InputView(title: "Enter page size", placeholder: "1", text: $size)
                .onChange( of: size) {
                    if !size.isEmpty {
                        model.size = UInt(size) ?? 0
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
    OFFPricesUsersView()
}
