//
//  OFFPricesRequired.swift
//  OFFPricesSAPIs
//
//  Created by Arnaud Leene on 26/02/2024
//

// This file contains the code that is required by multiple API's. Checkout the comments if you want to delete parts.

import Foundation

struct OFFPricesRequired {

/** all possible Price API's
 */
    enum APIs {
        case locations
        case locationsOsm
        case prices
        case products
        case productsCode
        case status
        case users
        
        var path: String {
            switch self {
            case .locations: return "/locations"
            case .locationsOsm: return "/locations/osm"
            case .prices: return "/prices"
            case .products: return "/products"
            case .productsCode: return "/products/code"
            case .status: return "/status"
            case .users: return "/users"
            }
        }
    }
    
    // The default is increasing.
    public enum OrderDirection: String {
        case increasing = ""
        case decreasing = "-"
    }


/**
    Some API's (ProductStats) can return a validation error with response code 401.
*/
    public struct Error401: Codable {
        var detail: String?
    }

    public struct Error404: Codable {
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
        var type: String?
        var loc: [String] = []
        var msg: String?
        var input: [String] = []
        var ctx: ValidationErrorDetailCtx? = nil
        var url: String?
    }
    
    public struct ValidationErrorDetailCtx: Codable {
        var error: String? = nil
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
                } else if response.response.statusCode == 404 {
                    if let data = response.body {
                        Decoding.decode(data: data, type: OFFPricesRequired.Error404.self) { result in
                            switch result {
                            case .success(let gelukt):
                                completion(.failure(.notFound(gelukt.detail ?? "no detail received")))
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
    case notFound(String)
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
        case .notFound(let parameter):
            return "OFFPricesError: \(parameter)"
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
