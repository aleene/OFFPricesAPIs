//
//  OFFPricesRequiredProduct.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 01/03/2024.
//

import Foundation

extension OFFPricesRequired {
    
    // Used by the Product endpoint and the Prices endpoint

    public struct Product: Codable {
        var code: String?
        var id: UInt?
        var source: String?
        var product_name: String?
        var product_quantity: Int?
        var product_quantity_unit: Int?
        var categories_tags: [String]?
        var brands: String?
        var brands_tags: [String]?
        var image_url: String?
        var unique_scans: UInt?
        var price_count: UInt?
        var created: String?
        var updated: String?
    }
}
