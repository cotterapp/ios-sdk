//
//  CotterJWT.swift
//  Cotter
//
//  Created by Albert Purnama on 7/12/20.
//

import Foundation

struct CotterAccessTokenJWT: Codable {
    var aud: String
    var authenticationMethod: String
    var clientUserID: String
    var exp: Int
    var iat: Int
    var iss: String
    var scope: String
    var sub: String
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case aud
        case authenticationMethod = "authentication_method"
        case clientUserID = "client_user_id"
        case exp
        case iat
        case iss
        case scope
        case sub
        case type
    }
}

func decodeBase64AccessTokenJWT(_ from: String) -> CotterAccessTokenJWT? {
    let components = from.components(separatedBy: ".")
    if components.count < 3 {
        // malformed accessToken
        print("FATAL ERROR: accesToken is malformed. Please contact Cotter Customer support")
        return nil
    }
    let base64Encoded = components[1] // the token body
    
    // base64Encoded strings count must be multiple of 4. If not, pad it with =
    let paddedBase64Encoded = base64Encoded.padding(toLength: ((base64Encoded.count+3)/4)*4,
        withPad: "=",
        startingAt: 0)

    guard let decodedData = Data(base64Encoded: paddedBase64Encoded, options: .ignoreUnknownCharacters) else {
        return nil
    }
    let decodedString = String(data: decodedData, encoding: .utf8)!
    
    // from string to json.
    let data = decodedString.data(using: .utf8)!
    let jsonDecoder = JSONDecoder()
    do {
        let token = try jsonDecoder.decode(CotterAccessTokenJWT.self, from: data)
        
        // return the subject
        return token
    } catch let error as NSError {
        print(error.localizedDescription)
        return nil
    }
}
