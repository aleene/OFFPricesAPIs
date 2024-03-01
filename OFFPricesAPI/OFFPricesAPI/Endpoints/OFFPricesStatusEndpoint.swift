//
//  OFFPricesStatusEndpoint.swift
//  OFFPricesAPIs
//
//  Created by Arnaud Leene on 26/02/2024
//

// Use this file if you want to get the status of the server

import Foundation

extension OFFPricesRequired {
/**
The datastructure retrieved for a 200-reponse 200 for the Status endpoint.
     
- Variables:**
 - status: a text string giving the status of the server (vakues values: "running")
*/
    public struct StatusResponse: Codable {
        var status: String?
    }
}

extension URLSession {
    
/**
Function to retrieve the status of the prices server

 - Parameters:
    - none

 - returns:
A completion block with a Result enum (success or failure). The associated value for success is a OFFPricesRequired.StatusResponse struct.
*/
    func OFFPricesStatus(
                        completion: @escaping (_ result: Result<OFFPricesRequired.StatusResponse, OFFPricesError>) -> Void) {
        let request = OFFPricesRequest.init(api: .status)
        fetch(request: request, responses: [200:OFFPricesRequired.StatusResponse.self]) { (result) in
            completion(result)
            return
        }
    }

}
