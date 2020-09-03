//
//  CrossApp.swift
//  Cotter
//
//  Created by Albert Purnama on 6/27/20.
//

import Foundation
import os.log
import AuthenticationServices

@available(iOS 12.0, *)
class CrossApp: NSObject, ASWebAuthenticationPresentationContextProviding {
    var authSession: ASWebAuthenticationSession?
    var anchorView: UIViewController?

    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.anchorView?.view.window ?? ASPresentationAnchor()
    }

    override public init() {}

    // initiallization of email/SMS verification services
    // view - the parent view
    // input - the actual value of email or sms
    // identifierField - email or phone
    // type - EMAIL or PHONE
    // directLogin - true or false
    public convenience init(
        view: UIViewController,
        input: String,
        identifierField: String,
        type: String,
        directLogin: String,
        userID: String?,
        authMethod: AuthMethod?
    ) {
        self.init()
        self.anchorView = view
        
        // create code challenge
        let codeVerifier = PKCE.createVerifier()
        let codeChallenge = PKCE.createCodeChallenge(verifier: codeVerifier)
        if codeChallenge == nil {
            os_log("%{public}@ failed creating code challenge { verifier: %{public}@ }",
                   log: Config.instance.log, type: .error,
                   #function, codeVerifier)
        }
        
        let initialState = randomString(length: 5)
        
        // start the authentication process
        guard let url = Config.instance.PLBaseURL else { return }
        guard let scheme = Config.instance.PLScheme else { return }
        var queryDictionary = [
            "type": type,
            "api_key": CotterAPIService.shared.apiKeyID,
            "redirect_url": Config.instance.PLRedirectURL,
            "identifier_field": identifierField,
            "input": input,
            "direct_login": directLogin,
            "state": initialState,
            "code_challenge": codeChallenge
        ]
        
        if let userID = userID {
            queryDictionary["cotter_user_id"] = userID
        }
        
        if let authMethod = authMethod {
            // provides raw string value to query dictionary
            queryDictionary["auth_method"] = authMethod.rawValue
        }
        
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
        
        os_log("%{public}@ crossApp { url: %{public}@ }",
               log: Config.instance.log, type: .debug,
               #function, URL?.absoluteString ?? "")
        
        guard let authURL = URL else { return }

        self.authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme)
        { callbackURL, error in
            // Handle the callback.
            guard error == nil, let callbackURL = callbackURL else { return }

            // The callback URL format depends on the provider. For this example:
            //   exampleauth://auth?token=1234
            
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            let cb = Config.instance.passwordlessCb

            guard let challengeID = queryItems?.filter({ $0.name == "challenge_id" }).first?.value else {
                cb(nil, CotterError.passwordless("challenge_id is unavailable"))
                return
            }
            
            guard let state = queryItems?.filter({ $0.name == "state" }).first?.value, state == initialState else {
                cb(nil, CotterError.passwordless("state is unavailable or inconsistent"))
                return
            }
            
            guard let authorizationCode = queryItems?.filter({ $0.name == "code" }).first?.value else {
                cb(nil, CotterError.passwordless("authorization_code is not available"))
                return
            }
            
            func httpCb(response: CotterResult<CotterIdentity>) {
                switch response {
                case .success(let resp):
                    cb(resp, nil)
                case .failure(let err):
                    // we can handle multiple error results here
                    os_log("%{public}@ unhandled callback error { err: %{public}@ }",
                           log: Config.instance.log, type: .error,
                           #function, err.localizedDescription)
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
            self.authSession?.presentationContextProvider = self
        } else {
            // Fallback on earlier versions
            os_log("%{public}@ crossApp not supported for <iOS13.0",
                   log: Config.instance.log, type: .fault,
                   #function)
        }
        
        if let started = self.authSession?.start(), started {
            os_log("%{public}@ started session",
                   log: Config.instance.log, type: .debug,
                   #function)
        } else {
            os_log("%{public}@ failed to start session",
                   log: Config.instance.log, type: .fault,
                   #function)
        }
    }
}
