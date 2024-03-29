//
//  OFFPricesPricesEndpoint.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 01/03/2024.
//

import Foundation

class OFFPricesPricesRequest: OFFPricesRequest {
    
    convenience init(page: UInt,
                     size: UInt,
                     orderBy: OFFPricesRequired.PricesOrderBy,
                     orderDirection: OFFPricesRequired.OrderDirection,
                     product_code: String?,
                     product_id: UInt?,
                     product_id__isnull: Bool?,
                     category_tag: String?,
                     location_ism_id: UInt?,
                     location_osm_type: String?,
                     location_id: UInt?,
                     price: Double?,
                     price_is_discounted: Bool?,
                     price__gt: Double?,
                     price__gte: Double?,
                     price__lt: Double?,
                     price__lte: Double?,
                     currency: ISO4217,
                     date: String?,
                     date__gt : String?,
                     date__gte: String?,
                     date__lt: String?,
                     date__lte: String?,
                     proof_id: UInt?,
                     owner: String?,
                     created_gte: String?,
                     created_lte: String?) {
        self.init(api: .prices)
        
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

        if let valid = product_code {
            queryItems.append(URLQueryItem(name: "product_code", value: valid ))
        }
        
        if let valid = product_id {
            queryItems.append(URLQueryItem(name: "product_id", value: "\(valid)" ))
        }
        
        if let valid = product_id__isnull {
            if valid {
                queryItems.append(URLQueryItem(name: "product_id__isnull", value: "true" ))
            } else {
                queryItems.append(URLQueryItem(name: "product_id__isnull", value: "false" ))
            }
        }
        
        if let valid = category_tag {
            queryItems.append(URLQueryItem(name: "category_tag", value: valid ))
        }
        
        if let valid = location_ism_id {
            queryItems.append(URLQueryItem(name: "location_ism_id", value: "\(valid)" ))
        }
        
        if let valid = location_osm_type {
            queryItems.append(URLQueryItem(name: "location_osm_type", value: valid ))
        }

        if let valid = location_id {
            queryItems.append(URLQueryItem(name: "location_id", value: "\(valid)" ))
        }

        if let valid = price {
            queryItems.append(URLQueryItem(name: "price", value: "\(valid)" ))
        }

        if let valid = price_is_discounted {
            if valid {
                queryItems.append(URLQueryItem(name: "price_is_discounted", value: "true" ))
            } else {
                queryItems.append(URLQueryItem(name: "price_is_discounted", value: "false" ))
            }
        }

        if let valid = price__gt {
            queryItems.append(URLQueryItem(name: "price__gt", value: "\(valid)" ))
        }

        if let valid = price__gte {
            queryItems.append(URLQueryItem(name: "price__gte", value: "\(valid)" ))
        }

        if let valid = price__lt {
            queryItems.append(URLQueryItem(name: "price__lt", value: "\(valid)" ))
        }

        if let valid = price__lte {
            queryItems.append(URLQueryItem(name: "price__lte", value: "\(valid)" ))
        }

        queryItems.append(URLQueryItem(name: "currency", value: currency.rawValue ))

        if let valid = date {
            queryItems.append(URLQueryItem(name: "date", value: "\(valid)" ))
        }

        if let valid = date__gt {
            queryItems.append(URLQueryItem(name: "date__gt", value: "\(valid)" ))
        }

        if let valid = date__gte {
            queryItems.append(URLQueryItem(name: "date__gte", value: "\(valid)" ))
        }

        if let valid = date__lt {
            queryItems.append(URLQueryItem(name: "date__lt", value: "\(valid)" ))
        }

        if let valid = date__lte {
            queryItems.append(URLQueryItem(name: "date__lte", value: "\(valid)" ))
        }

        if let valid = proof_id {
            queryItems.append(URLQueryItem(name: "proof_id", value: "\(valid)" ))
        }

        if let valid = owner {
            queryItems.append(URLQueryItem(name: "owner", value: valid ))
        }

        if let valid = created_gte {
            queryItems.append(URLQueryItem(name: "created_gte", value: "\(valid)" ))
        }

        if let valid = created_lte {
            queryItems.append(URLQueryItem(name: "created_lte", value: "\(valid)" ))
        }

    }

    convenience init(code: String,
                     name: String?,
                     categoryTag: String?,
                     labelsTags: [String],
                     originsTags: [String],
                     price: Double,
                     isDiscounted: Bool,
                     undiscountedPrice: Double?,
                     per: OFFPricesRequired.PricePer,
                     currency: ISO4217,
                     locationOSMid: UInt,
                     locationOSMtype: OFFPricesRequired.OSMtype,
                     date: Date,
                     proofId: UInt,
                     token: String?) {
        self.init(api: .prices)
        self.headers["accept"] = "application/json"
        self.method = .post
        if let validToken = token {
            self.headers["Authorization"] = "Bearer \(validToken)"
        }
        // The body to send depends on whether the discountedPrice is filled
        if undiscountedPrice != nil {
            let body = JSONBody([ "product_code": "\(code)",
                                  "product_name": name,
                                 // "category_tag": categoryTag ?? "",
                                 // "labels_tags": labelsTags,
                                 // "origins_tags": originsTags,
                                  "price": "\(price)",
                                  "price_is_discounted": "true",
                                  "price_without_discount": "\(undiscountedPrice!)",
                                  "price_per": per.rawValue,
                                  "currency": currency.rawValue,
                                  "location_osm_id": "\(locationOSMid)",
                                  "location_osm_type": locationOSMtype.rawValue,
                                  "date": date.ISO8601Format(.iso8601.year().month().day()),
                                  "proof_id": "\(proofId)"
                                ])
            self.body = body
        } else {
            let body = JSONBody([ "product_code": "\(code)",
                                  "product_name": name,
                                 // "category_tag": categoryTag ?? "",
                                 // "labels_tags": labelsTags,
                                 // "origins_tags": originsTags,
                                  "price": "\(price)",
                                  "price_is_discounted": "false",
                                  //"price_without_discount": "",
                                  "price_per": per.rawValue,
                                  "currency": currency.rawValue,
                                  "location_osm_id": "\(locationOSMid)",
                                  "location_osm_type": locationOSMtype.rawValue,
                                  "date": date.ISO8601Format(.iso8601.year().month().day()),
                                  "proof_id": "\(proofId)"
                                ])
            self.body = body
        }

    }
    
    convenience init(priceID: UInt,
                     price: Double,
                     isDiscounted: Bool = false,
                     undiscountedPrice: Double?,
                     per: OFFPricesRequired.PricePer,
                     currency: ISO4217,
                     date: Date,
                     token: String?) {
        self.init(api: .prices)
        
        self.path += "/"
        self.path += "\(priceID)"
        self.headers["accept"] = "application/json"
        
        self.method = .patch
        if let validToken = token {
            self.headers["Authorization"] = "Bearer \(validToken)"
        }
        let body = JSONBody(["price": "\(price)",
                             "price_is_discounted": isDiscounted ? "true" : "false",
                             "price_without_discount": undiscountedPrice != nil ? "\(undiscountedPrice!)" : "0.001",
                             "price_per": per.rawValue,
                             "currency": currency.rawValue,
                             "date": date.ISO8601Format(.iso8601.year().month().day())])
        self.body = body
    }
    
    convenience init(priceID: UInt,
                     token: String?) {
        self.init(api: .prices)
        
        self.path += "/"
        self.path += "\(priceID)"
        
        self.method = .delete
        if let validToken = token {
            self.headers["Authorization"] = "Bearer \(validToken)"
        }
    }
}

extension OFFPricesRequired {
/**
The datastructure retrieved for a 200-reponse  for the Products endpoint.
     
    Variables:
        - items: an array with a list of products
        - total: the total number of products (UInt)
        - page: the current page number (UInt)
        - size: the maximum number of products per page (UInt)
        - pages: total number of pages (UInt)
*/
    public struct PricesResponse: Codable {
        var items: [Price]?
        var total: UInt?
        var page: UInt?
        var size: UInt?
        var pages: UInt?
    }
    
    public enum PricePer: String {
        case unit = "UNIT"
        case kilogram = "KILOGRAM"
    }
    

/**
The datastructure retrieved for a 200-reponse  for the Products endpoint.

    Variables:**

*/
    public struct Price: Codable {
        var product_code: String?
        var product_name: String?
        var category_tag: String?
        var label_tags: String?
        var origins_tag: String?
        var price: Double?
        var price_is_discounted: Bool?
        var price_wthout_discount: Double?
        var price_per: String?
        var currency: String?
        var location_osm_id: UInt?
        var location_osm_type: String?
        var date: String?
        var proof_id: UInt?
        var id: UInt?
        var product_id: UInt?
        var location_id: UInt?
        var owner: String?
        var created: String?
        var product: OFFPricesRequired.Product
        var proof: OFFPricesRequired.Proof
        var location: OFFPricesRequired.Location
    }
    
// The allowed ordering fields. Any other rawValue will give a 422 error
    public enum PricesOrderBy: String {
        case product_code = "product_code"
        case product_id = "product_id"
        case product_id__isnull = "product_id__isnull"
        case category_tag = "category_tag"
        case location_ism_id = "location_ism_id"
        case location_osm_type = "location_osm_type"
        case location_id = "location_id"
        case price = "price"
        case price_is_discounted = "price_is_discounted"
        case price__gt = "price_gt"
        case price__gte = "price_gte"
        case price__lt = "price__lt"
        case price__lte = "price__lte"
        case currency = "currency"
        case date = "date"
        case date__gt = "date__gt"
        case date__gte = "date__gte"
        case date__lt = "date__lt"
        case date__lte = "date__lte"
        case proof_id = "proof_id"
        case owner = "owner"
        case created_gte = "created_gte"
        case created_lte = "created_lte"
        case unordered
    }
    
    public struct PricePostPatchResponse: Codable {
        var product_code: String?
        var product_name: String?
        var category_tag: [String]?
        var labels_tags: [String]?
        var origins_tags: [String]?
        var price: Double?
        var price_is_discounted: Bool?
        var price_without_discount: Double?
        var price_per: String?
        var currency: String?
        var location_osm_id: UInt?
        var location_osm_type: String?
        var date: String?
        var proof_id: UInt?
        var id: UInt?
        var product_id: UInt?
        var location_id: UInt?
        var owner: String?
        var created: String?
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
    func OFFPricesPrices(page: UInt,
                         size: UInt,
                         orderBy: OFFPricesRequired.PricesOrderBy,
                         orderDirection: OFFPricesRequired.OrderDirection,
                         product_code: String?,
                         product_id: UInt?,
                         product_id__isnull: Bool?,
                         category_tag: String?,
                         location_ism_id: UInt?,
                         location_osm_type: String?,
                         location_id: UInt?,
                         price: Double?,
                         price_is_discounted: Bool?,
                         price__gt: Double?,
                         price__gte: Double?,
                         price__lt: Double?,
                         price__lte: Double?,
                         currency: ISO4217,
                         date: String?,
                         date__gt : String?,
                         date__gte: String?,
                         date__lt: String?,
                         date__lte: String?,
                         proof_id: UInt?,
                         owner: String?,
                         created_gte: String?,
                         created_lte: String?,
                         completion: @escaping (_ result: Result<OFFPricesRequired.PricesResponse, OFFPricesError>) -> Void) {
        let request = OFFPricesPricesRequest(page: page,
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
                                             created_lte: created_lte)
            fetch(request: request, responses: [200:OFFPricesRequired.PricesResponse.self]) { (result) in
            completion(result)
            return
        }
    }
    
    func OFFPricesPatchPrice(priceID: UInt,
                             price: Double,
                             isDiscounted: Bool,
                             undiscountedPrice: Double?,
                             per: OFFPricesRequired.PricePer,
                             currency: ISO4217,
                             date: Date,
                             token: String?,
                             completion: @escaping (_ result: Result<OFFPricesRequired.PricePostPatchResponse, OFFPricesError>) -> Void) {
        let request = OFFPricesPricesRequest(priceID: priceID,
                                             price: price,
                                             isDiscounted: isDiscounted,
                                             undiscountedPrice: undiscountedPrice,
                                             per: per,
                                             currency: currency,
                                             date: date,
                                             token: token)
        fetch(request: request, responses: [200:OFFPricesRequired.PricePostPatchResponse.self]) { (result) in
            completion(result)
            return
        }
    }

    func OFFPricesPostPrice(code: String,
                            name: String?,
                            categoryTag: String?,
                            labelsTags: [String],
                            originsTags: [String],
                            price: Double,
                            isDiscounted: Bool,
                            undiscountedPrice: Double?,
                            per: OFFPricesRequired.PricePer,
                            currency: ISO4217,
                            locationOSMid: UInt,
                            locationOSMtype: OFFPricesRequired.OSMtype,
                            date: Date,
                            proofId: UInt,
                            token:  String,
                            completion: @escaping (_ result: Result<OFFPricesRequired.PricePostPatchResponse, OFFPricesError>) -> Void) {
        let request = OFFPricesPricesRequest(code: code,
                                             name: name,
                                             categoryTag: categoryTag,
                                             labelsTags: labelsTags,
                                             originsTags: originsTags,
                                             price: price,
                                             isDiscounted: isDiscounted,
                                             undiscountedPrice: undiscountedPrice,
                                             per: per,
                                             currency: currency,
                                             locationOSMid: locationOSMid,
                                             locationOSMtype: locationOSMtype,
                                             date: date,
                                             proofId: proofId,
                                             token: token)
        fetch(request: request, responses: [200:OFFPricesRequired.PricePostPatchResponse.self]) { (result) in
            completion(result)
            return
        }
    }

    func OFFPricesDeletePrice(priceID: UInt,
                            token:  String,
                            completion: @escaping (_ result: Result<String, OFFPricesError>) -> Void) {
        let request = OFFPricesPricesRequest(priceID: priceID,
                                             token: token)
        fetch(request: request, responses: [204:String.self]) { (result) in
            completion(result)
            return
        }
    }

}
