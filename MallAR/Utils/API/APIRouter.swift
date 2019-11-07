//
//  APIRouter.swift
//  MallAR
//
//  Created by amirhosseinpy on 8/15/1398 AP.
//  Copyright © 1398 Farazpardazan. All rights reserved.
//

import Foundation

enum APIRouter {
    case getContacts
    case getContact(id: Int)
    case createContact(body: [String: Any])
    case updateContact(id: Int, body: [String: Any])
    
    private static let baseURLString = "ar.farazpardazan.com"
    
    private enum HTTPMethod {
        case get
        case post
        case put
        case delete
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .put: return "PUT"
            case .delete: return "DELETE"
            }
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getContacts: return .get
        case .getContact: return .get
        case .createContact: return .post
        case .updateContact: return .put
        }
    }
    
    private var path: String {
        switch self {
        case .getContacts:
            return "/contacts.json"
        case .getContact(let id):
            return "/contacts/\(id).json"
        case .createContact:
            return "/contacts.json"
        case .updateContact(let id, _):
            return "/contacts/\(id).json"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }
    
    func request() throws -> URLRequest {
        let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(APIRouter.baseURLString)\(encodedPath)"
        
        guard let url = URL(string: urlString) else {
            throw ErrorType.parseUrlFail
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        if let token = FPUserManager.token {
//            headers["Authorization"] = "\(token)"
//        }
        
//        request.allHTTPHeaderFields = headers
        
        if let parameters = parameters {
            if method == .post {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    
                    request.httpBody = jsonData
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        return request
    }
}


public typealias Parameters = [String: Any]

