//
//  OFFPricesRequiredLocation.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 01/03/2024.
//

import Foundation

extension OFFPricesRequired {
    
    // Used by the Locations endpoint and the Prices endpoint
    
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
}
