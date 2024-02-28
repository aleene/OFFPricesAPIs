//
//  RBTFExtension.swift
//  OFFRobotoffAPIs
//
//  Created by Arnaud Leene on 26/11/2022.
//

import Foundation

extension OFFPricesRequired.UsersResponse {
        
    // We like to keep the presentation order of the elements in OFFPricesRequired.UsersResponse as it maps to the Swagger documentation
    var dict: [String:String] {
        var temp: [String:String] = [:]
        temp["barcode"] = barcode ?? "nil"
        temp["type"] = questionType.rawValue
        temp["value"] = value ?? "nil"
        temp["question"] = question ?? "nil"
        temp["insight_id"] = insight_id ?? "nil"
        temp["insight_type"] = insightType.rawValue
        temp["value_tag"] = value_tag ?? "nil"
        temp["source_image_url"] = source_image_url ?? "nil"
        return temp
    }

}
