//
//  MockedCotterClient.swift
//  Cotter
//
//  Created by Raymond Andrie on 5/29/20.
//

import Foundation

// MARK: - Mock APIService Variables
public struct MockAPIServiceVariables {
    public let ID = "MOCK_ID"
    public let intID = 1
    public let userID = "MOCK_USER_ID"
    public let name = "MOCK_NAME"
    public let identifier = "MOCK_IDENTIFIER"
    public let identifierType = "MOCK_IDENTIFIER_TYPE"
    public let publicKey = "MOCK_PUBLIC_KEY"
    public let newPublicKey = "MOCK_NEW_PUBLIC_KEY"
    public let createdAt = "MOCK_CREATED_AT"
    public let updatedAt = "MOCK_UPDATED_AT"
    public let deletedAt = "MOCK_DELETED_AT"
    public let issuer = "MOCK_ISSUER"
    public let clientUserID = "MOCK_CLIENT_USER_ID"
    public let enrolled = true
    public let enrolledArray = ["MOCK_TRUEDT_DEVICE"]
    public let defaultMethod = "MOCK_TRUSTED_DEVICE"
    public let method = "MOCK_METHOD"
    public let eventID = "MOCK_EVENT_ID"
    public let event = "MOCK_EVENT"
    public let ip = "MOCK_IP"
    public let location = "MOCK_LOCATION"
    public let timestamp = "MOCK_TIMESTAMP"
    public let new = false
    public let approved = true
    public let deviceType = "MOCK_DEVICE_TYPE"
    public let deviceName = "MOCK_DEVICE_NAME"
    public let deviceAlgo = "MOCK_DEVICE_ALGO"
    public let expiry = "MOCK_EXPIRY"
    public let receiver = "MOCK_RECEIVER"
    public let expireAt = "MOCK_EXPIRE_AT"
    public let signature = "MOCK_SIGNATURE"
    public let companyID = "MOCK_COMPANY_ID"
    public let appID = "MOCK_APP_ID"
    public let accessToken = "MOCK_ACCESS_TOKEN"
    public let authMethod = "MOCK_AUTH_METHOD"
    public let expiresIn = 1
    public let idToken = "MOCK_ID_TOKEN"
    public let refreshToken = "MOCK_REFRESH_TOKEN"
    public let tokenType = "MOCK_TOKEN_TYPE"
    public let success = true
    public let challengeID = 1
    public let challenge = "MOCK_CHALLENGE"
    public let oldCode = "MOCK_OLD_CODE"
    public let code = "MOCK_CODE"
    public let codeVerifier = "MOCK_CODE_VERIFIER"
    public let redirectURL = "MOCK_REDIRECT_URL"
    public let sendingMethod = "MOCK_SENDING_METHOD"
    public let sendingDestination = "MOCK_SENDING_DESNTINATION"
    public let resetCode = "MOCK_RESET_CODE"
    public let authorizationCode = "MOCK_AUTHORIZATION_CODE"
}

// MARK: - Mocked NetworkSession Implementation
class NetworkSessionMock: NetworkSession {
    var data: Data? = nil
    var response: URLResponse? = nil
    var error: Error? = nil
    
    func loadData(urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completionHandler(data, response, error)
    }
}

public class MockedCotterClient: APIClient {
    
    let mock = MockAPIServiceVariables()
    let session = NetworkSessionMock()
    
    var sendCalled = false
    
    public func send<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<T.Response>) {
        // Create mock url request
        let urlrequest = URLRequest(url: URL(fileURLWithPath: "url"))
        
        // Create mock data and tell session to always return it
        session.data = createMockData(type: T.Response.self)
        
        // Perform the request and verify the result
        session.loadData(urlRequest: urlrequest) { data, response, error in
            do {
                let resp = try JSONDecoder().decode(T.Response.self, from: self.session.data!)
                print("success")
                completion(.success(resp))
            } catch {
                print("fail")
                completion(.failure(CotterAPIError.general(message: "Mock Error")))
            }
        }
        
        // Mark sendCalled to be true
        sendCalled = true
    }
    
    private func createMockData<T>(type: T.Type) -> Data {
        switch type {
        case is EnrolledMethods.Type:
            // MARK: - EnrolledMethods Response
            let enrolledMethods = EnrolledMethods(enrolled: mock.enrolled, method: mock.method)
            return encodedMockObject(obj: enrolledMethods)
        case is CotterEvent.Type:
            // MARK: - CotterEvent Response
            let event = CotterEvent(id: mock.intID, createdAt: mock.createdAt, updatedAt: mock.updatedAt, deletedAt: mock.deletedAt, clientUserID: mock.clientUserID, issuer: mock.issuer, event: mock.event, ip: mock.ip, location: mock.location, timestamp: mock.timestamp, method: mock.method, new: mock.new, approved: mock.approved, oauthToken: nil)
            return encodedMockObject(obj: event)
        case is Optional<CotterEvent>.Type:
            // MARK: - Optional CotterEvent Response
            let event = CotterEvent(id: mock.intID, createdAt: mock.createdAt, updatedAt: mock.updatedAt, deletedAt: mock.deletedAt, clientUserID: mock.clientUserID, issuer: mock.issuer, event: mock.event, ip: mock.ip, location: mock.location, timestamp: mock.timestamp, method: mock.method, new: mock.new, approved: mock.approved, oauthToken: nil)
            return encodedMockObject(obj: event)
        case is CotterIdentity.Type:
            // MARK: - CotterIdentity Response
            let identifier = Identifier(id: mock.ID, createdAt: mock.createdAt, updatedAt: mock.updatedAt, deletedAt: mock.deletedAt, identifier: mock.identifier, identifierType: mock.identifierType, publicKey: mock.publicKey, deviceType: mock.deviceType, deviceName: mock.deviceName, expiry: mock.expiry)
            let token = Token(identifier: mock.identifier, identifierType: mock.identifierType, receiver: mock.receiver, expireAt: mock.expireAt, signature: mock.signature)
            let identity = CotterIdentity(identifier: identifier, token: token)
            return encodedMockObject(obj: identity)
        case is CotterNotificationCredential.Type:
            // MARK: - CotterNotificationCredential Response
            let notifCred = CotterNotificationCredential(id: mock.intID, createdAt: mock.createdAt, updatedAt: mock.updatedAt, deletedAt: mock.deletedAt, companyID: mock.companyID, appID: mock.appID)
            return encodedMockObject(obj: notifCred)
        case is CotterOAuthToken.Type:
            // MARK: - CotterOAuthToken Response
            let oauthToken = CotterOAuthToken(accessToken: mock.accessToken, authMethod: mock.authMethod, expiresIn: mock.expiresIn, idToken: mock.idToken, refreshToken: mock.refreshToken, tokenType: mock.tokenType)
            return encodedMockObject(obj: oauthToken)
        case is CotterBasicResponse.Type:
            // MARK: - CotterBasicResponse Response
            let resp = CotterBasicResponse(success: mock.success)
            return encodedMockObject(obj: resp)
        case is CotterResponseWithChallenge.Type:
            // MARK: - CotterResponseWithChallenge
            let resp = CotterResponseWithChallenge(success: mock.success, challengeID: mock.challengeID, challenge: mock.challenge)
            return encodedMockObject(obj: resp)
        case is CotterUser.Type:
            // MARK: - CotterUser Response
            let user = CotterUser(id: mock.ID, createdAt: mock.createdAt, updatedAt: mock.updatedAt, deletedAt: mock.deletedAt, issuer: mock.issuer, clientUserID: mock.clientUserID, enrolled: mock.enrolledArray, defaultMethod: mock.defaultMethod)
            return encodedMockObject(obj: user)
        default:
            return Data()
        }
    }
    
    private func encodedMockObject<T: Encodable>(obj: T) -> Data {
        do {
            let jsonData = try JSONEncoder().encode(obj)
            return String(data: jsonData, encoding: .utf8)!.data(using: .utf8)!
        } catch {
            return Data()
        }
    }
}
