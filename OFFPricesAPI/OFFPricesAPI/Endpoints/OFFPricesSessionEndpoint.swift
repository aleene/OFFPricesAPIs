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
    
    public struct SessionDeleteResponse: Codable {
        var status: String?
    }

    public enum SessionRequestType {
        case status
        case delete
    }
}

class OFFPricesSessionRequest: OFFPricesRequest {
        
    convenience init(type: OFFPricesRequired.SessionRequestType) {
        self.init(api: .session)
        switch type {
        case .status:
            self.method = .get
        case .delete:
            self.method = .delete
        }
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
    func OFFPricesSession(completion: @escaping (_ result: Result<OFFPricesRequired.SessionResponse, OFFPricesError>) -> Void) {
        let request = OFFPricesSessionRequest.init(type: .status)
        fetch(request: request, responses: [200:OFFPricesRequired.SessionResponse.self]) { (result) in
            completion(result)
            return
        }
    }

/**
Function to delete a user session

- Parameters:
 - none

- returns:
A completion block with a Result enum (success or failure). The associated value for success is a OFFPricesRequired.SessionResponse struct.
*/
        func OFFPricesDeleteSession(
                            completion: @escaping (_ result: Result<OFFPricesRequired.SessionDeleteResponse, OFFPricesError>) -> Void) {
            let request = OFFPricesSessionRequest.init(type: .delete)
            fetch(request: request, responses: [200:OFFPricesRequired.SessionDeleteResponse.self]) { (result) in
                completion(result)
                return
            }
        }

}
