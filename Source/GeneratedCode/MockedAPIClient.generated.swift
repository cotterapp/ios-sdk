// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



  public class MockedAPIClient: APIClient {
      var sendCalled: Bool = false

      public func send<T: APIRequest>(        _ request: T,        completion: @escaping ResultCallback<T.Response>    ) -> Void {
        sendCalled = true
      }
  }
