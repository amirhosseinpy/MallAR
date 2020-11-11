//
//  FPNetworkAgent.swift
//  PUT
//
//  Created by amirhosseinpy on 1/26/1399 AP.
//  Copyright © 1399 Farazpardazan Inc. All rights reserved.
//

import UIKit
import RxSwift

class NetworkAgent {
    
    private let baseURL: URL?
    private var decoder: JSONDecoder!
    private var encoder: JSONEncoder!
    private var session: URLSession!
    
    init(baseUrl: URL?) {
        baseURL = baseUrl
        setupURLSessionConfiguration()
        setupDecoder()
        setupEncoder()
    }

    func setupURLSessionConfiguration() {
        let config = URLSessionConfiguration.default
        config.httpShouldSetCookies = false
        config.httpCookieAcceptPolicy = .never
        config.networkServiceType = .responsiveData
        config.shouldUseExtendedBackgroundIdleMode = true
        self.session = URLSession(configuration: config, delegate: nil, delegateQueue: .main)
    }
    
    func setupDecoder() {
        let decoder =  JSONDecoder()
        decoder.dataDecodingStrategy = .base64
        decoder.dateDecodingStrategy = .millisecondsSince1970
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
            positiveInfinity: "Infinity",
            negativeInfinity: "-Infinity",
            nan: "NaN")
        
        self.decoder = decoder
    }
    
    func setupEncoder() {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base64
        encoder.dateEncodingStrategy = .custom({ (date, encoder) in
            var container = encoder.singleValueContainer()
            try container.encode(Int64(date.timeIntervalSinceNow * 1000))
        })
        
        self.encoder = encoder
    }

    func request<R: APIRouter>(_ router: R) -> Observable<R.ResponseType?> {
        let decodableType = type(of: router)
        
        do {
            guard let url = self.baseURL else {
                throw NetworkError.parsing
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = decodableType.method.rawValue
            switch decodableType.requestType {
            case .jsonBody:
                if let data = router.requestBody?.toJSON() {
                    request.httpBody = data
                }
            case .httpHeader:
                request.httpBody = nil
            default:
                fatalError()
            }
            
            return run(request)
            
        } catch {
            return Observable<R.ResponseType?>.create { observer in
                observer.onError(error)
                return Disposables.create()
            }.observeOn(MainScheduler.instance)
        }
    }
    
    func run<C: Codable>(_ request: URLRequest) -> Observable<C?> {
        return Observable<C?>
            .create { observer in
                let task = self.session.dataTask(with: request) { (data, response, error) in
                    do {
                        if let error = error { throw error }
                        guard let response = response as? HTTPURLResponse else { throw NetworkError.server }
                        
                        let data = try self.validate(response: response, data: data)
                        let model = try self.decoder.decode(C.self, from: data)
                        
                        observer.onNext(model)
                    } catch {
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
                
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
        }.observeOn(MainScheduler.instance)
    }
    
    private func validate(response: HTTPURLResponse, data: Data?) throws -> Data {
        
        if response.statusCode == 500 {
            throw NetworkError.server
        }
        
        guard let data = data else { throw NetworkError.server }
        return data
    }
}



