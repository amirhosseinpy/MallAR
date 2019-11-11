//
//  NetworkConnection.swift
//  MallAR
//
//  Created by amirhosseinpy on 8/15/1398 AP.
//  Copyright © 1398 Farazpardazan. All rights reserved.
//

import UIKit
import RxSwift

class NetworkConnection {
    
    static var shared = NetworkConnection()
    
    func send<T: Codable>(apiRequest: APIRouter, printDebugResp: Bool = true, key: String? = nil) -> Observable<T> {
        
        return Observable<T>
            .create { observer in
                do {
                    let task = try URLSession.shared.dataTask(with: apiRequest.request()) { (data, response, error) in
                        do {
                            let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: .fragmentsAllowed)
                            let validationError = ServerError(type: ErrorType.validationError)
                            observer.onError(validationError)
                            
                            guard JSONSerialization.isValidJSONObject(json) else {
                                let error = ServerError(type: ErrorType.validationError)
                                observer.onError(error)
                                return
                            }
                            
                            if let err = error {
                                observer.onError(ServerError(customError: err.localizedDescription))
                                //                            observer.onCompleted()
                                return
                            }
                            
                            let urlResp = (response as? HTTPURLResponse)
                            //                let respCode = urlResp?.statusCode ?? -1
                            
                            //                if respCode == 403 || respCode == 401 {
                            //                    FPBaseInfo.shared.clearAll()
                            //                    observer.onError(FPServerError(code: respCode))
                            //                    observer.onCompleted()
                            //                    return
                            //                }
                            
                            do {
                                
                                self.printDebugInfo(resp: urlResp, data: data, debug: printDebugResp)
                                
                                //                    if let tokenHeader = urlResp?.allHeaderFields["Authorization"] as? String {
                                //
                                //                        var user = FPBaseInfo.shared.currentUser.value
                                //                        user.token = tokenHeader
                                //                        FPBaseInfo.shared.currentUser.accept(user)
                                //                        FPBaseInfo.shared.saveAll()
                                //                    }
                                if let key = key, let keyedJson = (json as? [String: Any])?[key] {
                                    let keyedData = try JSONSerialization.data(withJSONObject: keyedJson, options: .fragmentsAllowed)
                                    let model: T = try JSONDecoder().decode(T.self, from: keyedData)
                                    observer.onNext(model)
                                } else {
                                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                                    observer.onNext(model)
                                }
                                
                                
                            } catch let error {
                                observer.onError(error)
                            }
                            observer.onCompleted()
                            
                        } catch let error {
                            observer.onError(error)
                        }
                    }
                    task.resume()
                    
                    return Disposables.create {
                        task.cancel()
                    }
                } catch let error {
                    print(error)
                    return Disposables.create()
                }
        }.observeOn(MainScheduler.instance)
    }
    
    func downloadImage(apiRequest: APIRouter, printDebugResp: Bool = true) -> Observable<UIImage?> {
        
        return Observable<UIImage?>
            .create { observer in
                do {
                    let task = try URLSession.shared.dataTask(with: apiRequest.request()) { (data, response, error) in
                        
                        if let err = error {
                            observer.onError(ServerError(customError: err.localizedDescription))
                        } else {
                            self.printDebugInfo(resp: (response as? HTTPURLResponse),data: data, debug: printDebugResp)
                            
                            let image = UIImage(data: data ?? Data())
                            observer.onNext(image)
                        }
                        observer.onCompleted()
                    }
                    task.resume()
                    
                    return Disposables.create {
                        task.cancel()
                    }
                } catch let error {
                    print(error)
                    return Disposables.create()
                }
        }.observeOn(MainScheduler.instance)
    }
    
    func printDebugInfo(resp: HTTPURLResponse?, data: Data?, debug: Bool) {
        if !debug {
            return
        }
        
        print(String(repeating: "-", count: 70))
        print((resp?.url?.absoluteString ?? "") + "\n")
        
        if let data = data {
            if let printStr = String(data: data, encoding: .utf8) {
                print(printStr)
            } else {
                print("cruppted or non string data")
            }
        } else {
            print("cruppted data")
        }
        
        print(String(repeating: "-", count: 70))
    }
}

struct ServerRespWrapper<T>: Codable {
    var status: String?
    var reason: String?
}



