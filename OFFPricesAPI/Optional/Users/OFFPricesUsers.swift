//
//  OFFPricesUsers.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 27/02/2024.
//

import Foundation

class OFFPricesUsersRequest: OFFPricesRequest {
    
    convenience init(page: UInt,
                     size: UInt,
                     orderBy: OFFPricesRequired.OrderBy,
                     orderDirection: OFFPricesRequired.OrderDirection,
                     price_count: UInt?,
                     price_count_gte: UInt?,
                     price_count_lte: UInt?) {
        //guard api == .users
        //    else { fatalError("OFFPricesRequest:init(api:page:size:price_count:price_count_gte:price_count:lte:): unallowed API specified") }
        self.init(api: .users)
        
        queryItems.append(URLQueryItem(name: "page", value: "\(page)" ))
        queryItems.append(URLQueryItem(name: "size", value: "\(size)" ))
        /*
         The following three items might contradict each other:
         - price_count!=nil & price_count_gte < price_count : price_count is used
         - price_count!=nil & price_count_gte > price_count : empty result
         - price_count!=nil & price_count_lte < price_count : empty result
         - price_count!=nil & price_count_lte > price_count : price_count is used
         - price_count_gte > price_count_lte : empty result
         */
        if orderBy != .unordered {
            queryItems.append(URLQueryItem(name: "order_by", value: orderDirection.rawValue + orderBy.rawValue ))
        }

        if let validPriceCount = price_count {
            if price_count_gte != nil && price_count_lte != nil { print("OFFPricesRequest:init(api:page:size:price_count:price_count_gte:price_count:lte:): price_count and ranges both specified; can contradict each other")
            }
            queryItems.append(URLQueryItem(name: "price_count", value: "\(validPriceCount)" ))
        }
        if let validPriceCountGTE = price_count_gte {
            if let validPriceCountLTE = price_count_lte,
            validPriceCountLTE > validPriceCountGTE {
                print("OFFPricesRequest:init(api:page:size:price_count:price_count_gte:price_count:lte:): price_count_lte larger than price_count_gte")
            }
            queryItems.append(URLQueryItem(name: "price_count_gte", value: "\(validPriceCountGTE)" ))
        }
        if let validPriceCountLTE = price_count_lte {
            queryItems.append(URLQueryItem(name: "price_count_lte", value: "\(validPriceCountLTE)" ))
        }

    }
}

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
    
}

extension URLSession {
    
/**
Function to retrieve the users and the number of price entries for the users. In addition the output can be ordered by field name and direction.. And the user can limit the output by price count or price count range.

- Parameters:
 - page: the results page (1)
 - size: the size of the results page (50)
 - orderBy: either .unordered, .user_id, .price_count (.unordered)
 - orderDiection: either .increasing, .decreasing (.increasing)
 - priceCount: a specific price count (nil)
 - priceCountLTE: an upper limit to the price counts (nil)
 - priceCountGTE: a lower limit to the proce counts (nil)
     
 - returns:
A completion block with a Result enum (success or failure). The associated value for success is a OFFPricesRequired.UsersResponse struct.
*/
        func OFFPricesUsers(page: UInt,
                            size: UInt,
                            orderBy: OFFPricesRequired.OrderBy = .unordered,
                            orderDirection: OFFPricesRequired.OrderDirection = .increasing,
                            price_count: UInt? = nil,
                            price_count_gte: UInt? = nil,
                            price_count_lte: UInt? = nil,
                            completion: @escaping (_ result: Result<OFFPricesRequired.UsersResponse, OFFPricesError>) -> Void) {
            let request = OFFPricesUsersRequest.init(page: page,
                                                     size: size,
                                                     orderBy: .unordered,
                                                     orderDirection: .increasing,
                                                     price_count: price_count,
                                                     price_count_gte: price_count_gte,
                                                     price_count_lte: price_count_lte)
                fetch(request: request, responses: [200:OFFPricesRequired.UsersResponse.self]) { (result) in
                completion(result)
                return
            }
        }

}
