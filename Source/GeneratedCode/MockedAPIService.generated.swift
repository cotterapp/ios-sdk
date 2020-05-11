// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



  public class MockedAPIService: APIService {
      var authCalled: Bool = false

      public func auth(userID: String, issuer: String, event: String, code: String, method: String, pubKey: String?, timestamp: String, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        authCalled = true
      }
      var registerUserCalled: Bool = false

      public func registerUser(userID: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        registerUserCalled = true
      }
      var enrollUserPinCalled: Bool = false

      public func enrollUserPin(code: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        enrollUserPinCalled = true
      }
      var updateUserPinCalled: Bool = false

      public func updateUserPin(oldCode: String, newCode: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        updateUserPinCalled = true
      }
      var getBiometricStatusCalled: Bool = false

      public func getBiometricStatus(cb: @escaping ResultCallback<EnrolledMethods>) -> Void {
        getBiometricStatusCalled = true
      }
      var updateBiometricStatusCalled: Bool = false

      public func updateBiometricStatus(enrollBiometric: Bool, cb: @escaping ResultCallback<CotterUser>) -> Void {
        updateBiometricStatusCalled = true
      }
      var requestTokenCalled: Bool = false

      public func requestToken(codeVerifier: String, challengeID: Int, authorizationCode: String, redirectURL: String, cb: @escaping ResultCallback<CotterIdentity>) -> Void {
        requestTokenCalled = true
      }
      var getUserCalled: Bool = false

      public func getUser(userID: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        getUserCalled = true
      }
      var registerBiometricCalled: Bool = false

      public func registerBiometric(userID: String, pubKey: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        registerBiometricCalled = true
      }
      var requestPINResetCalled: Bool = false

      public func requestPINReset(name: String, sendingMethod: String, sendingDestination: String, cb: @escaping ResultCallback<CotterResponseWithChallenge>) -> Void {
        requestPINResetCalled = true
      }
      var verifyPINResetCodeCalled: Bool = false

      public func verifyPINResetCode(resetCode: String, challengeID: Int, challenge: String, cb: @escaping ResultCallback<CotterBasicResponse>) -> Void {
        verifyPINResetCodeCalled = true
      }
      var resetPINCalled: Bool = false

      public func resetPIN(resetCode: String, newCode: String, challengeID: Int, challenge: String, cb: @escaping ResultCallback<CotterBasicResponse>) -> Void {
        resetPINCalled = true
      }
      var enrollTrustedDeviceCalled: Bool = false

      public func enrollTrustedDevice(userID: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        enrollTrustedDeviceCalled = true
      }
      var getNewEventCalled: Bool = false

      public func getNewEvent(userID: String, cb: @escaping ResultCallback<CotterEvent?>) -> Void {
        getNewEventCalled = true
      }
      var getTrustedDeviceStatusCalled: Bool = false

      public func getTrustedDeviceStatus(userID: String, cb: @escaping ResultCallback<EnrolledMethods>) -> Void {
        getTrustedDeviceStatusCalled = true
      }
      var getTrustedDeviceEnrolledAnyCalled: Bool = false

      public func getTrustedDeviceEnrolledAny(userID: String, cb: @escaping ResultCallback<EnrolledMethods>) -> Void {
        getTrustedDeviceEnrolledAnyCalled = true
      }
      var reqAuthCalled: Bool = false

      public func reqAuth(userID: String, event: String, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        reqAuthCalled = true
      }
      var getEventCalled: Bool = false

      public func getEvent(eventID:String, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        getEventCalled = true
      }
      var approveEventCalled: Bool = false

      public func approveEvent(event: CotterEvent, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        approveEventCalled = true
      }
      var registerOtherDeviceCalled: Bool = false

      public func registerOtherDevice(qrData:String, userID:String, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        registerOtherDeviceCalled = true
      }
      var removeTrustedDeviceStatusCalled: Bool = false

      public func removeTrustedDeviceStatus(userID: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        removeTrustedDeviceStatusCalled = true
      }
      var getNotificationAppIDCalled: Bool = false

      public func getNotificationAppID(cb: @escaping ResultCallback<CotterNotificationCredential>) -> Void {
        getNotificationAppIDCalled = true
      }
  }
