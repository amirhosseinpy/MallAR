//
//  FPAPIRouter.swift
//  PUT
//
//  Created by amirhosseinpy on 1/26/1399 AP.
//  Copyright © 1399 Farazpardazan Inc. All rights reserved.
//

import Foundation

public protocol BasicType: Codable, Hashable, RawRepresentable, CustomStringConvertible, CustomDebugStringConvertible {}

public protocol APIRouter {
    static var method: HTTPMethod { get }
    static var path: String { get }
    static var requestType: RequestType { get }
    static var retriable: Bool { get }
    
    var requestBody: Encodable? { get }
    
    associatedtype ResponseType: Codable
}

extension APIRouter {
    public static var method: HTTPMethod {
        return .post
    }
    
    public static var requestType: RequestType {
        switch method {
        case .post:
            return .jsonBody
        default:
            return .httpHeader
        }
    }
    
    public static var retriable: Bool {
        return true
    }
}

extension Encodable {
    func toJSON() -> Data? { try? JSONEncoder().encode(self) }
}

public struct HTTPMethod: BasicType {
    public let rawValue: String
    public var description: String { return rawValue }
    public var debugDescription: String {
        return "HTTP Method: \(rawValue)"
    }
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    init(_ description: String) {
        self.rawValue = description.uppercased()
    }
    
    public static let get = HTTPMethod(rawValue: "GET")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let delete = HTTPMethod(rawValue: "DELETE")
    public static let head = HTTPMethod(rawValue: "HEAD")
    public static let patch = HTTPMethod(rawValue: "PATCH")
}

public enum RequestType {
    case httpHeader
    case jsonBody
    case multipartFromData
    case urlQuery
}
