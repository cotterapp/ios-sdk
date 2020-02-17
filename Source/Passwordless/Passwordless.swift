//
//  Passwordless.swift
//  Cotter
//
//  Created by Albert Purnama on 2/13/20.
//

import Foundation
import AuthenticationServices

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
        type: String
    ) {
        self.init()
        print("loading Passwordless \(input)")
        self.anchorView = view
        
        // start the authentication process
        guard let url = Config.instance.PLBaseURL else { return }
        guard let scheme = Config.instance.PLScheme else { return }
        let queryDictionary = [
            "type": type,
            "api_key": CotterAPIService.shared.apiKeyID,
            "redirect_url": Config.instance.PLRedirectURL,
            "identifier_field": identifierField,
            "input": input
        ]
        
        guard var components = URLComponents(string: url) else { return }
        components.queryItems = queryDictionary.map {
             URLQueryItem(name: $0, value: $1)
        }
        let URL = components.url
        print(URL!.absoluteString)
        
        guard let authURL = URL else { return }

        self.authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme)
        { callbackURL, error in
            // Handle the callback.
            guard error == nil, let callbackURL = callbackURL else { return }

            // The callback URL format depends on the provider. For this example:
            //   exampleauth://auth?token=1234
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            guard let token = queryItems?.filter({ $0.name == "token" }).first?.value else {
                print("token is unavailable")
                return
            }
            guard let cb = Config.instance.callbackFunc else {
                print("callback is unavailable")
                return
            }

            // handle token
            cb(token)

            return
        }
        
        if #available(iOS 13.0, *) {
            print("here")
            self.authSession?.presentationContextProvider = self
        } else {
            // Fallback on earlier versions
        }
        
        print("authenticating")
        self.authSession?.start()
    }
}
