//
//  ServerError.swift
//  MallAR
//
//  Created by amirhosseinpy on 8/15/1398 AP.
//  Copyright © 1398 Farazpardazan. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case parsing
    case network
    case server
    case invalidResponse
    case authorizationFailed
    case badRequest(message: String?)
    
    var localizedDescription: String {
        switch self {
        case .server:
            return "request.failed".localized
        case .badRequest(let message):
            return message ?? ""
        default:
            return "something.wrong".localized
        }
    }
}

enum FPAppError: Error {
    case nilValue
}


