//
//  OFFPricesLocationsEndpoint.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 28/02/2024.
//

import Foundation

class OFFPricesLocationsRequest: OFFPricesRequest {
    
    convenience init(page: UInt,
                     size: UInt,
                     osmName: String?,
                     osmAddressCountry: String?,
                     orderBy: OFFPricesRequired.LocationsOrderBy,
                     orderDirection: OFFPricesRequired.OrderDirection,
                     price_count: UInt?,
                     price_count_gte: UInt?,
                     price_count_lte: UInt?) {
        //guard api == .locations
        //    else { fatalError("OFFPricesLocationsRequest:init(api:page:size:osmName:osmAddressCountry:price_count:price_count_gte:price_count:lte:): unallowed API specified") }
        self.init(api: .locations)
        
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
        if let validOsmName = osmName {
            queryItems.append(URLQueryItem(name: "osm_name__like", value: validOsmName ))
        }
        if let validOsmAddressCountry = osmAddressCountry {
            queryItems.append(URLQueryItem(name: "osm_address_country__like", value: validOsmAddressCountry ))
        }

    }
    
    convenience init(osmType: OFFPricesRequired.OSMtype,
                     osmID: UInt) {
        self.init(api: .locationsOsm)
        self.path += "/"
        self.path += osmType.rawValue
        self.path += "/"
        self.path += "\(osmID)"
    }
    
    convenience init(id: UInt) {
        self.init(api: .locations)
        self.path += "/"
        self.path += "\(id)"
    }

}

extension OFFPricesRequired {
/**
The datastructure retrieved for a 200-reponse  for the Locations endpoint.
     
- Variables:**
 - status: a text string giving the status of the server (vakues values: "running")
*/
    public struct LocationsResponse: Codable {
        var items: [Location]?
        var total: Int?
        var page: Int?
        var size: Int?
        var pages: Int?
    }
    
    public struct Location: Codable {
        var osm_id: Int?
        var osm_type: String?
        var id: Int?
        var osm_name: String?
        var osm_display_name: String?
        var osm_address_postcode: String?
        var osm_address_city: String?
        var osm_address_country: String?
        var osm_lat: Double?
        var osm_lon: Double?
        var price_count: UInt?
        var created: String?
        var updated: String?
    }
    
// The allowed ordering fields. Any other rawValue will give a 422 error
    public enum LocationsOrderBy: String {
        case id = "id"
        case osmId = "osm_id"
        case osmType = "osm_type"
        case osmName = "osm_name"
        case osmDisplayName = "osm_display_name"
        case osmAddressPostcode = "osm_address_postcode"
        case osmAddressCity = "osm_address_city"
        case osmAddressCountry = "osm_address_country"
        case osmLat = "osm_lat"
        case osmLon = "osm_lon"
        case priceCount = "price_count"
        case created = "created"
        case updated = "updated"
        case unordered
    }

    public enum OSMtype: String {
        case node = "node"
        case way = "way"
        case relation = "relation"
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
    func OFFPricesLocations(page: UInt,
                            size: UInt,
                            osmName: String?,
                            osmAddressCountry: String?,
                            priceCount: UInt? = nil,
                            priceCountGte: UInt? = nil,
                            priceCountLte: UInt? = nil,
                            orderBy: OFFPricesRequired.LocationsOrderBy,
                            orderDirection: OFFPricesRequired.OrderDirection,
                            completion: @escaping (_ result: Result<OFFPricesRequired.LocationsResponse, OFFPricesError>) -> Void) {
        let request = OFFPricesLocationsRequest.init(page: page,
                                                     size: size,
                                                     osmName: osmName,
                                                     osmAddressCountry: osmAddressCountry,
                                                     orderBy: orderBy,
                                                     orderDirection: orderDirection,
                                                     price_count: priceCount,
                                                     price_count_gte: priceCountGte,
                                                     price_count_lte: priceCountLte)
            fetch(request: request, responses: [200:OFFPricesRequired.LocationsResponse.self]) { (result) in
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
        func OFFPricesLocations(type: OFFPricesRequired.OSMtype,
                                id: UInt,
                                completion: @escaping (_ result: Result<OFFPricesRequired.Location, OFFPricesError>) -> Void) {
            let request = OFFPricesLocationsRequest(osmType: type,
                                                    osmID: id)
                fetch(request: request, responses: [200:OFFPricesRequired.Location.self]) { (result) in
                completion(result)
                return
            }
        }

    
    /**
    Function to retrieve a single location based on the prices shop id.

    - Parameters:
     - id: the OFF id of the location
         
     - returns:
    A completion block with a Result enum (success or failure). The associated value for success is a OFFPricesRequired.UsersResponse struct.
    */
        func OFFPricesLocations(id: UInt,
                                completion: @escaping (_ result: Result<OFFPricesRequired.Location, OFFPricesError>) -> Void) {
            let request = OFFPricesLocationsRequest(id: id)
                fetch(request: request, responses: [200:OFFPricesRequired.Location.self]) { (result) in
                completion(result)
                return
            }
        }
}
