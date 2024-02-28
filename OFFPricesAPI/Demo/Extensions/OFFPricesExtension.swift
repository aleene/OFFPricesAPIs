//
//  OFFPricesExtension.swift
//  OFFRobotoffAPIs
//
//  Created by Arnaud Leene on 26/11/2022.
//

import Foundation

extension OFFPricesRequired.User {
    
    // We like to keep the presentation order of the elements in OFFPricesRequired.UsersResponse as it maps to the Swagger documentation
    var dict: [String:String] {
        var temp: [String:String] = [:]
        temp["user_id"] = user_id ?? "nil"
        temp["price_count"] = price_count != nil ? "\(price_count!)" : "none"
        return temp
    }
}

extension OFFPricesRequired.Location {
            
    // We like to keep the presentation order of the elements in OFFPricesRequired.LocationsResponse as it maps to the Swagger documentation
    var dict: [String:String] {
        var temp: [String:String] = [:]
        temp["id"] = id != nil ? "\(id!)" : "nil"
        temp["osm_id"] = osm_id != nil ? "\(osm_id!)" : "nil"
        temp["osm_type"] =  osm_type ?? "nil"
        temp["osm_name"] = osm_name ?? "nil"
        temp["osm_display_name"] = osm_display_name ?? "nil"
        temp["osm_address_postcode"] = osm_address_postcode ?? "nil"
        temp["osm_address_city"] = osm_address_city ?? "nil"
        temp["osm_address_country"] = osm_address_country ?? "nil"
        temp["osm_lat"] = osm_lat != nil ? "\(osm_lat!)" : "nil"
        temp["osm_lon"] = osm_lon != nil ? "\(osm_lon!)" : "nil"
        temp["price_count"] = price_count != nil ? "\(price_count!)" : "nil"
        temp["created"] =  created ?? "nil"
        temp["updated"] =  updated ?? "nil"

        return temp
    }

}
