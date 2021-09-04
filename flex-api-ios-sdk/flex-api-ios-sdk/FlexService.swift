//
//  FlexServiceImpl.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 11/04/21.
//

import Foundation

public class FlexService: FlexServiceProtocol {
    
    private var captureContext: CaptureContext?
    private var tokenGenerator: FlexTokensGenerator
        
    static func standardClient() -> FlexServiceProtocol {
        let httpClient = URLSessionHTTPClient()
        let tokenGenerator = RemoteFlexTokensGenerator(client: httpClient)
        return FlexService(tokenGenerator: tokenGenerator)
    }
    
    public typealias Result = Swift.Result<TransientToken, FlexErrorResponse>

    public enum Error: Swift.Error {
        case invalidCaptureContext
        case invalidData
        case connectivity
    }
    
    public init() {
        let httpClient = URLSessionHTTPClient()
        self.tokenGenerator = RemoteFlexTokensGenerator(client: httpClient)
    }
    
    init(tokenGenerator: RemoteFlexTokensGenerator) {
        self.tokenGenerator = tokenGenerator
    }
    
    init(captureContext: CaptureContext, tokenGenerator: FlexTokensGenerator) {
        self.captureContext = captureContext
        self.tokenGenerator = tokenGenerator
    }
        
    public func flexPublicKey(kid: String) -> SecKey? {
        return LongTermKey.sharedInstance.get(kid: kid)
    }

    public func createTransientToken(from captureContext: String, data: [String: Any], completion: @escaping (Result) -> Void) {
        if captureContext.isEmpty {
            completion(.failure(FlexInternalErrors.emptyCaptureContext.errorResponse))
            return
        } else if data.isEmpty {
            completion(.failure(FlexInternalErrors.emptyCardData.errorResponse))
            return
        }
        do {
            try self.captureContext = CaptureContextImpl(from: captureContext)
        } catch let error as FlexErrorResponse {
            completion(.failure(error))
            return
        } catch {
            completion(.failure(FlexInternalErrors.unknownError.errorResponse))
            return
        }
        
        do {
            try createToken(data: data, completion: completion)
        } catch let error as FlexErrorResponse {
            completion(.failure(error))
        } catch {
            completion(.failure(FlexInternalErrors.unknownError.errorResponse))
        }
    }
    
    func createToken(data: [String: Any], completion: @escaping (Result) -> Void) throws {
        
        guard let kid = self.captureContext?.getJsonWebKey()?.kid else {
            completion(.failure(FlexInternalErrors.missingKid.errorResponse))
            return
        }
        
        var jweString: String?
        do {
            jweString = try self.captureContext?.jwe(kid: kid, data: data)
        } catch let error as FlexErrorResponse {
            throw error
        }
        
        guard let jwe = jweString else {
            completion(.failure(FlexInternalErrors.jweCreationError.errorResponse))
            return
        }
        
        guard let path = self.captureContext?.getTokensPath() else {
            completion(.failure(FlexInternalErrors.invalidFlexServicePath.errorResponse))
            return
        }
        
        guard let origin = self.captureContext?.getFlexOrigin() else {
            completion(.failure(FlexInternalErrors.invalidFlexServiceOrigin.errorResponse))
            return
        }
        
        guard let url = URL(string: origin + path) else {
            completion(.failure(FlexInternalErrors.invalidFlexServiceURL.errorResponse))
            return
        }

        let requestObj = FlexRequest(keyId: jwe)
        var requestData = Data()
        
        do {
            requestData = try JSONEncoder().encode(requestObj)
        } catch {
            completion(.failure(FlexInternalErrors.requestObjectDecodingError.errorResponse))
        }
    
        self.tokenGenerator.generateTransientToken(url: url, payload: requestData) { (result) in
            switch result {
            case let .success(response):
                if (response.isValidResponse()) {
                    do {
                        try DigestHelper.verifyResponseDigest(response: response)
                    } catch {
                        //TODO: remove force unwrap
                        completion(.failure(error as! FlexErrorResponse))
                    }
                    if let responseToken = response.body {
                        completion(.success(TransientToken(token: responseToken)))
                    } else {
                        completion(.failure(Tools.handleErrorResponse(response: response, startTime: 1)))
                    }
                } else {
                    completion(.failure(Tools.handleErrorResponse(response: response, startTime: 1)))
                }
            case let .failure(error):
                completion(.failure(Tools.createErrorObjectFrom(status: 4000, reason: "Connectivity error", message: error.localizedDescription)))
            }
        }
    }
}
