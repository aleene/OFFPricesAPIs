//
//  OFFPricesAuth.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 24/10/2022.
//

import Foundation
//
//  Extensions for the Auth API
//
extension OFFPricesRequired {
    /// the datastructure retrieved for reponse 200
    public struct Auth: Codable {
        var access_token: String?
        var token_type: String?
    }
}

// not supported at the moment. Do not know how this works. Needs to added to the auth
class OFFPricesAuthRequest: OFFPricesRequest {
        
    convenience init(cookie: Bool) {
        self.init(api: .auth)
        
        if cookie {
            queryItems.append(URLQueryItem(name: "set_cookie", value: "true" ))
        }
    }

}
extension URLSession {
    
/**
 Function to retrieve an authentication token for a username/password combination.
 - Parameters:
    - username: the username of the user as registered on OpenFoodFacts
    - password: the corresponding password
 - Returns:
 A Result enum, with either a succes Auth Struct or an Error. The Auth Struct has the variables: **access_token** (String), which has to be passed on in other API calls; **token_type** (String).
*/
    func OFFPricesAuth(username: String, password: String, completion: @escaping (_ postResult: Result<OFFPricesRequired.Auth, OFFPricesError>) -> Void) {
        fetch(request: OFFPricesRequest(username: username, password: password), responses: [200:OFFPricesRequired.Auth.self]) { (result) in
            completion(result)
            return
        }
    }
}

extension OFFPricesRequest {
    
/**
 Initialised the request for the Auth-API
- Parameters:
    - username: the username of the user as registered on OFF.
    - password: the password of the user as registerd on OFF.
    
 - Example:
 curl -X 'POST' \
 'https://api.folksonomy.openfoodfacts.org/auth' \
 -H 'accept: application/json' \
 -H 'Content-Type: application/x-www-form-urlencoded' \
 -d 'grant_type=&username=XXXX&password=YYYYY&scope=&client_id=&client_secret='

*/
    convenience init(username: String, password: String) {
        self.init(api: .auth)
        self.headers["accept"] = "application/json"
        
        self.method = .post
        let body = FormBody(["grant_type": "",
                             "username": "\(username)",
                             "password": "\(password)",
                             "client_id": "",
                             "client_secret": ""])
        self.body = body
    }
}
