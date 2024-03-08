//
//  OFFPricesRequiredProof.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 01/03/2024.
//

import Foundation

extension OFFPricesRequired {
    
    // Used by the Proofs endpoint and the Prices endpoint

    public struct Proof: Codable {
        var id: UInt?
        var file_path: String?
        var mimetype: String?
        var type: String?
        var owner: String?
        var is_public: Bool?
        var price_count: UInt?
        var created: String?
    }

}
