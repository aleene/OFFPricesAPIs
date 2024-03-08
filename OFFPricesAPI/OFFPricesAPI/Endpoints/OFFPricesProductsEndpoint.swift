//
//  OFFPricesProductsEndpoint.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 01/03/2024.
//

import Foundation

class OFFPricesProductsRequest: OFFPricesRequest {
    
    convenience init(page: UInt,
                     size: UInt,
                     code: String?,
                     source: String?,
                     productName: String?,
                     brand: String?,
                     uniqueScansMinimum: UInt?,
                     orderBy: OFFPricesRequired.ProductsOrderBy,
                     orderDirection: OFFPricesRequired.OrderDirection,
                     price_count: UInt?,
                     price_count_gte: UInt?,
                     price_count_lte: UInt?) {
        self.init(api: .products)
        
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
            if price_count_gte != nil && price_count_lte != nil { print("OFFPricesRequest:init(): price_count and ranges both specified; can contradict each other")
            }
            queryItems.append(URLQueryItem(name: "price_count", value: "\(validPriceCount)" ))
        }
        if let validPriceCountGTE = price_count_gte {
            if let validPriceCountLTE = price_count_lte,
            validPriceCountLTE > validPriceCountGTE {
                print("OFFPricesLocationsRequest:init(): price_count_lte larger than price_count_gte")
            }
            queryItems.append(URLQueryItem(name: "price_count_gte", value: "\(validPriceCountGTE)" ))
        }
        if let validPriceCountLTE = price_count_lte {
            queryItems.append(URLQueryItem(name: "price_count_lte", value: "\(validPriceCountLTE)" ))
        }
        if let validCode = code {
            queryItems.append(URLQueryItem(name: "code", value: validCode ))
        }
        if let validSource = source {
            queryItems.append(URLQueryItem(name: "source", value: validSource ))
        }
        if let validProductName = productName {
            queryItems.append(URLQueryItem(name: "product_name__like", value: validProductName ))
        }
        if let validBrand = brand {
            queryItems.append(URLQueryItem(name: "brands__like", value: validBrand ))
        }
        if let validUniqueScansMinimum = uniqueScansMinimum {
            queryItems.append(URLQueryItem(name: "unique_scans_n__gte", value: "\(validUniqueScansMinimum)" ))
        }

    }
    
    convenience init(code: String) {
        self.init(api: .productsCode)
        self.path += "/"
        self.path += code
    }
    
    convenience init(productId: UInt) {
        self.init(api: .products)
        self.path += "/"
        self.path += "\(productId)"
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
    public struct ProductsResponse: Codable {
        var items: [Product]?
        var total: UInt?
        var page: UInt?
        var size: UInt?
        var pages: UInt?
    }
/**
The datastructure retrieved for a 200-reponse  for the Products endpoint.

    Variables:**
        - code: the barcode of the product
        - id: UInt?
        - source: values: (off) String?
        - product_name: String?
        - product_quantity: Int?
        - product_quantity_unit: Int?
        - categories_tags: [String]?
        - brands: String?
        - brands_tags: [String]?
        - image_url: String?
        - unique_scans: UInt?
        - price_count: UInt?
        - created: String?
        - updated: String?

*/
    
// The allowed ordering fields. Any other rawValue will give a 422 error
    public enum ProductsOrderBy: String {
        case code = "code"
        case id = "id"
        case source = "source"
        case product_name = "product_name"
        case product_quantity = "product_quantity"
        case product_quantity_unit = "product_quantity_unit"
        case brands = "brands"
        case brands_tags = "brands_tags"
        case image_url = "image_url"
        case unique_scans = "unique_scans"
        case priceCount = "price_count"
        case created = "created"
        case updated = "updated"
        case unordered
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
    func OFFPricesProducts(page: UInt,
                           size: UInt,
                           code: String?,
                           source: String?,
                           productName: String?,
                           brand: String?,
                           minimumNumberOfScans: UInt?,
                           priceCount: UInt? = nil,
                           priceCountMinimum: UInt? = nil,
                           priceCountMaximum: UInt? = nil,
                           orderBy: OFFPricesRequired.ProductsOrderBy,
                           orderDirection: OFFPricesRequired.OrderDirection,
                           completion: @escaping (_ result: Result<OFFPricesRequired.ProductsResponse, OFFPricesError>) -> Void) {
        let request = OFFPricesProductsRequest(page: page,
                                               size: size,
                                               code: code,
                                               source: source,
                                               productName: productName,
                                               brand: brand,
                                               uniqueScansMinimum: minimumNumberOfScans,
                                               orderBy: orderBy,
                                               orderDirection: orderDirection,
                                               price_count: priceCount,
                                               price_count_gte: priceCountMinimum,
                                               price_count_lte: priceCountMaximum)
            fetch(request: request, responses: [200:OFFPricesRequired.ProductsResponse.self]) { (result) in
            completion(result)
            return
        }
    }
    
    /**
    Function to retrieve the users and the number of price entries for the users. In addition the output can be ordered by field name and direction.. And the user can limit the output by price count or price count range.

    - Parameters:
     - tyoe: OSM type (.way, .node, .relation)
     - id: the size of the results page (50)
         
     - returns:
    A completion block with a Result enum (success or failure). The associated value for success is a OFFPricesRequired.UsersResponse struct.
    */
        func OFFPricesProducts(code: String,
                                completion: @escaping (_ result: Result<OFFPricesRequired.Product, OFFPricesError>) -> Void) {
            let request = OFFPricesProductsRequest(code: code)
                fetch(request: request, responses: [200:OFFPricesRequired.Product.self]) { (result) in
                completion(result)
                return
            }
        }

    
    /**
    Function to retrieve a single product based on the products id.

    - Parameters:
     - id: the OFF id of the location
         
     - returns:
    A completion block with a Result enum (success or failure). The associated value for success is a OFFPricesRequired.ProductsResponse struct.
    */
        func OFFPricesProducts(id: UInt,
                                completion: @escaping (_ result: Result<OFFPricesRequired.Product, OFFPricesError>) -> Void) {
            let request = OFFPricesProductsRequest(productId: id)
                fetch(request: request, responses: [200:OFFPricesRequired.Product.self]) { (result) in
                completion(result)
                return
            }
        }
}
