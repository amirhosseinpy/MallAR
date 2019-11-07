//
//  ServerError.swift
//  MallAR
//
//  Created by amirhosseinpy on 8/15/1398 AP.
//  Copyright © 1398 Farazpardazan. All rights reserved.
//

import Foundation

struct ServerError: Error {
    var code: Int
    var customError: String
    
    init(code: Int) {
        self.code = code
        customError = ""
    }
    
    init(code: Int, customError: String) {
        self.code = code
        self.customError = customError
    }
    
    func getErrMsg() -> String {
        if code == -1 {
            return "error.network".localized
        } else {
            return customError
        }
    }
}

enum ErrorType: LocalizedError {
    case parseUrlFail
    case notFound
    case validationError
    case serverError
    case defaultError
    
    var errorDescription: String? {
        switch self {
        case .parseUrlFail:
            return "Cannot initial URL object."
        case .notFound:
            return "Not Found"
        case .validationError:
            return "Validation Errors"
        case .serverError:
            return "Internal Server Error"
        case .defaultError:
            return "Something went wrong."
        }
    }
}


