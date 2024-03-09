//
//  OFFPricesSessionEndpoint.swift
//  OFFPricesAPI
//
//  Created by Arnaud Leene on 08/03/2024.
//

import Foundation

extension OFFPricesRequired {
    
    // Used by the Session endpoints
    
    public struct SessionResponse: Codable {
        var user_id: String?
        var created: String?
        var last_used: String?
    }
}

extension URLSession {
    
/**
Function to retrieve the status of the user sessioh

 - Parameters:
    - none

 - returns:
A completion block with a Result enum (success or failure). The associated value for success is a OFFPricesRequired.SessionResponse struct.
*/
    func OFFPricesSession(
                        completion: @escaping (_ result: Result<OFFPricesRequired.SessionResponse, OFFPricesError>) -> Void) {
        let request = OFFPricesRequest.init(api: .session)
        fetch(request: request, responses: [200:OFFPricesRequired.SessionResponse.self]) { (result) in
            completion(result)
            return
        }
    }

}
