//
//  OFFPricesUsers.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 27/02/2024.
//

import Foundation

extension OFFPricesRequired {
/**
The datastructure retrieved for a 200-reponse 200 for the Status endpoint.
     
- Variables:**
 - status: a text string giving the status of the server (vakues values: "running")
*/
    public struct UsersResponse: Codable {
        var items: [User]?
        var total: Int?
        var page: Int?
        var size: Int?
        var pages: Int?
    }
    
    public struct User: Codable {
        var user_id: String?
        var price_count: Int?
    }
    
    public enum OrderBy: String {
        case userId = "user_id"
        case priceCount = "price_count"
        case unordered
    }
    
    public enum OrderDirection: String {
        case increasing = ""
        case decreasing = "-"
    }


}

extension URLSession {
    
/**
Function to retrieve the users and the number of price entries for the users

 - Parameters:
    - page: the results page
    - size: the size of the results page

 - returns:
A completion block with a Result enum (success or failure). The associated value for success is a OFFPricesRequired.UsersResponse struct.
*/
    func OFFPricesUsers(page: UInt, size: UInt,
                        completion: @escaping (_ result: Result<OFFPricesRequired.UsersResponse, OFFPricesError>) -> Void) {
        let request = OFFPricesRequest.init(api: .users, page: page, size: size, orderBy: .unordered,    orderDirection:.increasing, price_count: nil, price_count_gte: nil, price_count_lte: nil)
        fetch(request: request, responses: [200:OFFPricesRequired.UsersResponse.self]) { (result) in
            completion(result)
            return
        }
    }

/**
Function to retrieve the users and the number of price entries for the users. In addition the output can be ordered by field name and direction.

- Parameters:
 - page: the results page
 - size: the size of the results page
 - orderBy: either .unordered, .user_id, .price_count
 - orderDiection: either .increasing, .decreasing
 - returns:
A completion block with a Result enum (success or failure). The associated value for success is a OFFPricesRequired.UsersResponse struct.
*/
    func OFFPricesUsers(page: UInt,
                        size: UInt,
                        orderBy: OFFPricesRequired.OrderBy,
                        orderDirection: OFFPricesRequired.OrderDirection,
                        completion: @escaping (_ result: Result<OFFPricesRequired.UsersResponse, OFFPricesError>) -> Void) {
        let request = OFFPricesRequest.init(api: .users, page: page, size: size, orderBy: orderBy,    orderDirection: orderDirection, price_count: nil, price_count_gte: nil, price_count_lte: nil)
            fetch(request: request, responses: [200:OFFPricesRequired.UsersResponse.self]) { (result) in
            completion(result)
            return
        }
    }
    
/**
Function to retrieve the users and the number of price entries for the users. In addition the output can be ordered by field name and direction.. And the user can limit the output by price count or price count range.

- Parameters:
 - page: the results page
 - size: the size of the results page
 - orderBy: either .unordered, .user_id, .price_count
 - orderDiection: either .increasing, .decreasing
 - priceCount: a specific price count
 - priceCountLTE: an upper limit to the price counts
 - priceCountGTE: a lower limit to the proce counts
     
 - returns:
A completion block with a Result enum (success or failure). The associated value for success is a OFFPricesRequired.UsersResponse struct.
*/
        func OFFPricesUsers(page: UInt,
                            size: UInt,
                            orderBy: OFFPricesRequired.OrderBy,
                            orderDirection: OFFPricesRequired.OrderDirection,
                            price_count: UInt,
                            price_count_gte: UInt,
                            price_count_lte: UInt,
                            completion: @escaping (_ result: Result<OFFPricesRequired.UsersResponse, OFFPricesError>) -> Void) {
            let request = OFFPricesRequest.init(api: .users, page: page, size: size, orderBy: .unordered,    orderDirection:.increasing, price_count: nil, price_count_gte: nil, price_count_lte: nil)
                fetch(request: request, responses: [200:OFFPricesRequired.UsersResponse.self]) { (result) in
                completion(result)
                return
            }
        }

}
