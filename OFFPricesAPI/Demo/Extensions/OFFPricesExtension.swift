//
//  OFFPricesExtension.swift
//  OFFRobotoffAPIs
//
//  Created by Arnaud Leene on 26/11/2022.
//

// These extensions support in the displaying of the retrieved data

import Foundation

extension OFFPricesRequired.User {
    
    var dict: [String:String] {
        var temp: [String:String] = [:]
        temp["user_id"] = user_id ?? "nil"
        temp["price_count"] = price_count != nil ? "\(price_count!)" : "none"
        return temp
    }
}

extension OFFPricesRequired.Location {
            
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

extension OFFPricesRequired.Product {
    
    var dict: [String:String] {
        var temp: [String:String] = [:]
        temp["code"] = code ?? "nil"
        temp["id"] = id != nil ? "\(id!)" : "nil"
        temp["source"] = source ?? "nil"
        temp["product_name"] = product_name ?? "nil"
        temp["product_quantity"] = product_quantity != nil ? "\(product_quantity!)" : "nil"
        temp["product_quantity_unit"] = product_quantity_unit != nil ? "\(product_quantity_unit!)" : "nil"
        temp["categories_tags"] = categories_tags != nil && !categories_tags!.isEmpty ? categories_tags!.first : "empty"
        temp["brands"] = brands ?? "nil"
        temp["brands_tags"] = brands_tags != nil && !brands_tags!.isEmpty ? brands_tags!.first : "empty"
        temp["image_url"] = image_url ?? "nil"
        temp["unique_scans"] = unique_scans != nil ? "\(unique_scans!)" : "nil"
        temp["price_count"] = price_count != nil ? "\(price_count!)" : "nil"
        temp["created"] = created ?? "nil"
        temp["updated"] = updated ?? "nil"
        
        return temp
    }
}

extension OFFPricesRequired.Price {
    
    var dict: [String:String] {
        var temp: [String:String] = [:]
        temp["product_code"] = product_code ?? "nil"
        temp["product_name"] = product_name ?? "nil"
        temp["category_tag"] = category_tag ?? "nil"
        temp["label_tag"] = label_tag ?? "nil"
        temp["origins_tag"] = origins_tag ?? "nil"
        temp["price"] = price != nil ? "\(price!)" : "nil"
        temp["price_is_discounted"] = price_is_discounted != nil ? (price_is_discounted! ? "true" : "false") : "nil"
        temp["price_wthout_discount"] = price_wthout_discount != nil ? "\(price_wthout_discount!)" : "nil"
        temp["price_per"] = price_per ?? "nil"
        temp["currency"] = currency ?? "nil"
        temp["location_osm_id"] = location_osm_id != nil ? "\(location_osm_id!)" : "nil"
        temp["location_osm_type"] = location_osm_type ?? "nil"
        temp["date"] = date ?? "nil"
        temp["proof_id"] = proof_id != nil ? "\(proof_id!)" : "nil"
        temp["id"] = id != nil ? "\(id!)" : "nil"
        temp["product_id"] = product_id != nil ? "\(product_id!)" : "nil"
        temp["location_id"] = location_id != nil ? "\(location_id!)" : "nil"
        temp["owner"] = owner ?? "nil"
        temp["created"] = created ?? "nil"

        temp = temp.merging(product.dict.newKey(prefix: "product:")) { $1 }
        temp = temp.merging(location.dict.newKey(prefix: "location:")) { $1 }
        temp = temp.merging(proof.dict.newKey(prefix: "proof:")) { $1 }

        return temp
    }
}

extension OFFPricesRequired.Proof {
    
    var dict: [String:String] {
        var temp: [String:String] = [:]
        temp["id"] = id != nil ? "\(id!)" : "nil"
        temp["file_path"] = file_path ?? "nil"
        temp["mimetype"] = mimetype ?? "nil"
        temp["type"] = type ?? "nil"
        temp["owner"] = owner ?? "nil"
        temp["is_public"] = is_public != nil ? (is_public! ? "true" : "false") : "nil"
        temp["price_count"] = price_count != nil ? "\(price_count!)" : "nil"
        temp["created"] = created ?? "nil"
        return temp
    }

}

extension Dictionary {
/**
 Function to prefix the keys of an ordered dictionary with a string.
 
 - Parameters:
    - prefix: string to put in front of all existing keys
 */
    func newKey(prefix: String) -> [String:String] {
        var newDict: [String:String] = [:]
        for (key, value) in self {
            if let keyString = key as? String,
               let valueString = value as? String {
                newDict[prefix + keyString] = valueString
            }
        }
        return newDict
    }
}

