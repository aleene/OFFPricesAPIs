//
//  OFFPricesRequired.swift
//  OFFPricesSAPIs
//
//  Created by Arnaud Leene on 26/02/2024
//

// This file contains the code that is required by multiple API's

import Foundation

struct OFFPricesRequired {

/** all possible Robotoff API's
 */
    enum APIs {
        case status
        case users
        
        var path: String {
            switch self {
            case .status: return "/status"
            case .users: return "/users"
            }
        }
    }
    
/**
    Some API's (ProductStats) can return a validation error with response code 401.
*/
    public struct Error401: Codable {
        var detail: String?
    }
    
    public struct Detail: Codable {
        var detail: String?
    }

    public struct Error400: Codable {
        var title: String?
        var description: String?
    }
/**
 Some API's (ProductStats) can return a validation error with response code 422.
 */
    public struct ValidationError: Codable {
        var detail: [ValidationErrorDetail] = []
    }
    
    public struct ValidationErrorDetail: Codable {
        var loc: [String] = []
        var msg: String?
        var type: String?
    }
}

extension URLSession {

/// Used for responses
    public func fetch<T>(request: HTTPRequest, responses: [Int : T.Type], completion: @escaping (Result<T, OFFPricesError>) -> Void) where T : Decodable {
        
        load(request: request) { result in
            switch result {
            case .success(let response):
                print("success :", response.response.statusCode)
                if let responsetype = responses[response.status.rawValue],
                   let data = response.body {
                    Decoding.decode(data: data, type: responsetype) { result in
                        switch result {
                        case .success(let gelukt):
                            completion(.success(gelukt))
                        case .failure(let decodingError):
                            switch decodingError {
                            case .dataCorrupted(let context):
                                completion(.failure(.dataCorrupted(context)))
                            case .keyNotFound(let key, let context):
                                completion(.failure(.keyNotFound(key, context)))
                            case .typeMismatch(let type, let context):
                                completion(.failure(.typeMismatch(type, context)))
                            case .valueNotFound(let type, let context):
                                completion(.failure(.valueNotFound(type, context)))
                            @unknown default:
                                completion(.failure(.unsupportedSuccessResponseType))
                            }
                        }
                        return
                    }
                } else if response.response.statusCode == 400 {
                    if let data = response.body {
                        Decoding.decode(data: data, type: OFFPricesRequired.Error400.self) { result in
                            switch result {
                            case .success(let gelukt):
                                completion(.failure(.missingParameter(gelukt.description ?? "no description received")))
                            case .failure(let decodingError):
                                switch decodingError {
                                case .dataCorrupted(let context):
                                    completion(.failure(.dataCorrupted(context)))
                                case .keyNotFound(let key, let context):
                                    completion(.failure(.keyNotFound(key, context)))
                                case .typeMismatch(let type, let context):
                                    completion(.failure(.typeMismatch(type, context)))
                                case .valueNotFound(let type, let context):
                                    completion(.failure(.valueNotFound(type, context)))
                                @unknown default:
                                    completion(.failure(.unsupportedSuccessResponseType))
                                }
                            }
                            return
                        }
                    }
                } else {
                    if let data = response.body {
                        print("failure: ", response.status.rawValue)

                        if let str = String(data: data, encoding: .utf8) {
                            completion( .failure(OFFPricesError.analyse(str)) )
                            return
                        } else {
                            completion(.failure( OFFPricesError.errorAnalysis) )
                            return
                        }
                    } else {
                        completion(.failure( OFFPricesError.noBody) )
                        return
                    }
                }
            case .failure(let error):
                print("error code: \(error.code)")
                completion( .failure( .connectionFailure) )
                    // the original response failed
                    //print (result.response.debugDescription)
                return
            }
        }
    }

}

class OFFPricesRequest: HTTPRequest {
    
/**
Init for all producttypes supported by OFF. This will setup the correct host and path of the API URL
 
 - Parameters:
    - productType: one of the productTypes (.food, .beauty, .petFood, .product);
    - api: the api required (i.e. .auth, .ping, etc)
*/
    convenience init(for productType: OFFProductType, for api: OFFPricesRequired.APIs) {
        self.init()
        self.host = "prices." + productType.host + ".org"
        self.path = "/api/v1" + api.path
    }
    
/**
 Init for the food prices API. This will setup the correct host and path of the API URL
  
- Parameters:
 - api: the api required (i.e. .auth, .ping, etc)
 */
    convenience init(api: OFFPricesRequired.APIs) {
        self.init(for: .food, for: api)
    }
    convenience init(api: OFFPricesRequired.APIs,
                     page: UInt,
                     size: UInt,
                     orderBy: OFFPricesRequired.OrderBy,
                     orderDirection: OFFPricesRequired.OrderDirection,
                     price_count: UInt?,
                     price_count_gte: UInt?,
                     price_count_lte: UInt?) {
        guard api == .users
            else { fatalError("OFFPricesRequest:init(api:page:size:price_count:price_count_gte:price_count:lte:): unallowed API specified") }
        self.init(api: api)
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
            if price_count_gte != nil && price_count_lte != nil { fatalError("OFFPricesRequest:init(api:page:size:price_count:price_count_gte:price_count:lte:): price_count and ranges both specified; can contradict each other") }
            queryItems.append(URLQueryItem(name: "price_count", value: "\(validPriceCount)" ))
        }
        if let validPriceCountGTE = price_count_gte {
            if let validPriceCountLTE = price_count_lte,
            validPriceCountLTE > validPriceCountGTE {
                fatalError("OFFPricesRequest:init(api:page:size:price_count:price_count_gte:price_count:lte:): price_count_lte larger than price_count_gte")
            }
            queryItems.append(URLQueryItem(name: "price_count_gte", value: "\(validPriceCountGTE)" ))
        }
        if let validPriceCountLTE = price_count_lte {
            queryItems.append(URLQueryItem(name: "price_count_lte", value: "\(validPriceCountLTE)" ))
        }

    }
}

// The specific errors that can be produced by the server
public enum OFFPricesError: Error {
    case authenticationRequired
    case barcodeInvalid
    case connectionFailure
    case dataCorrupted(DecodingError.Context)
    case errorAnalysis
    case keyNotFound(CodingKey, DecodingError.Context)
    case methodNotAllowed
    case missingParameter(String)
    case noBody
    case typeMismatch(Any.Type, DecodingError.Context)
    case unsupportedSuccessResponseType
    case valueNotFound(Any.Type, DecodingError.Context)

    
    static func analyse(_ message: String) -> OFFPricesError {
        if message.contains("Not Found") {
            return .connectionFailure
        } else if message.contains("Method Not Allowed") {
            return .methodNotAllowed
        } else if message.contains("Authentication required") {
            return .authenticationRequired
        } else {
            return .unsupportedSuccessResponseType
        }
    }
    public var description: String {
        switch self {
        case .authenticationRequired:
            return "OFFPricesError: Authentication Required. Log in before using this function"
        case .barcodeInvalid:
            return "OFFPricesError: A valid barcode is required (length 8, 12 or 13)"
        case .connectionFailure:
            return "OFFPricesError: Not able to connect to the server"
        case .errorAnalysis:
            return "OFFPricesError: unexpected error in error json"
        case .methodNotAllowed:
            return "OFFPricesError: Method Not Allowed, probably a missing parameter"
        case .missingParameter(let parameter):
            return "OFFPricesError: \(parameter)"
        case .noBody:
            return ""
        case .unsupportedSuccessResponseType:
            return ""
        case .dataCorrupted(let context):
            return "OFFPricesError:decode " + context.debugDescription
        case .keyNotFound(let key, let context):
            return "OFFPricesError:Key '\(key)' not found: \(context.debugDescription) codingPath:  \(context.codingPath)"
        case .typeMismatch(let value, let context):
            return "OFFPricesError:Value '\(value)' not found \(context.debugDescription) codingPath: \(context.codingPath)"
        case .valueNotFound(let type, let context):
            return "OFFPricesError:Type '\(type)' mismatch: \(context.debugDescription) codingPath:  \(context.codingPath)"
        }
    }
}
