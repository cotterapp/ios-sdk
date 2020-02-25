//
//  Passwordless.swift
//  Cotter
//
//  Created by Albert Purnama on 2/13/20.
//

import Foundation
import AuthenticationServices

@available(iOS 12.0, *)
class Passwordless: NSObject, ASWebAuthenticationPresentationContextProviding {
    var authSession: ASWebAuthenticationSession?
    var anchorView: UIViewController?

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.anchorView?.view.window ?? ASPresentationAnchor()
    }
    
    override public init() {}
    
    public convenience init(
        view: UIViewController,
        input: String,
        identifierField: String,
        type: String,
        directLogin: String
    ) {
        self.init()
        print("loading Passwordless \(input)")
        self.anchorView = view
        
        // create code challenge
        let codeVerifier = PKCE.createVerifier()
        let codeChallenge = PKCE.createCodeChallenge(verifier: codeVerifier)
        if codeChallenge == nil {
            print("ERROR: code challenge failed to be created")
        }
        
        let initialState = randomString(length: 5)
        
        // start the authentication process
        guard let url = Config.instance.PLBaseURL else { return }
        guard let scheme = Config.instance.PLScheme else { return }
        let queryDictionary = [
            "type": type,
            "api_key": CotterAPIService.shared.apiKeyID,
            "redirect_url": Config.instance.PLRedirectURL,
            "identifier_field": identifierField,
            "input": input,
            "direct_login": directLogin,
            "state": initialState,
            "code_challenge": codeChallenge
        ]
        
        var cs = CharacterSet.urlQueryAllowed
        cs.remove("+")
        
        guard var components = URLComponents(string: url) else { return }
        components.queryItems = queryDictionary.map {
            URLQueryItem(name: $0, value: $1)
        }
        
        // encode all occurences of "+" sign
        components.percentEncodedQuery = components.percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")
        
        let URL = components.url
        
        print(URL!.absoluteString)
        
        guard let authURL = URL else { return }

        self.authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme)
        { callbackURL, error in
            print("CALLED BACK")
            // Handle the callback.
            guard error == nil, let callbackURL = callbackURL else { return }

            // The callback URL format depends on the provider. For this example:
            //   exampleauth://auth?token=1234
            
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            guard let cb = Config.instance.callbackFunc else {
                print("callback is unavailable")
                return
            }

            guard let challengeID = queryItems?.filter({ $0.name == "challenge_id" }).first?.value else {
                cb("", false, CotterError.passwordless("challenge_id is unavailable"))
                return
            }
            
            guard let state = queryItems?.filter({ $0.name == "state" }).first?.value, state == initialState else {
                print()
                cb("", false, CotterError.passwordless("state is unavailable or inconsistent"))
                return
            }
            
            guard let authorizationCode = queryItems?.filter({ $0.name == "code" }).first?.value else {
                cb("", false, CotterError.passwordless("authorization_code is not available"))
                return
            }
            
            // the default callback
            let httpCb = CotterCallback()
            httpCb.successfulFunc = { (response) in
                guard let response = response else {
                    print("ERROR: response body is nil")
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let resp = try decoder.decode(GetIdentityResponse.self, from: response)
                    
                    // parse token
                    let jsonData = try JSONEncoder().encode(resp.token)
                    let tokenString = String(data: jsonData, encoding: .utf8)!
                    
                    // return the token
                    cb(tokenString, true, nil)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            CotterAPIService.shared.requestToken(
                codeVerifier: codeVerifier,
                challengeID: Int(challengeID) ?? -1,
                authorizationCode: authorizationCode,
                redirectURL: Config.instance.PLRedirectURL!,
                cb: httpCb
            )
            return
        }
        
        if #available(iOS 13.0, *) {
            print("here")
            self.authSession?.presentationContextProvider = self
        } else {
            // Fallback on earlier versions
        }
        
        print("authenticating")
        if let started = self.authSession?.start(), started {
            print("successfully started session")
        } else {
            print("FAILED TO START SESSION")
        }
    }
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
