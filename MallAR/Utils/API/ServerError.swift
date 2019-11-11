//
//  ServerError.swift
//  MallAR
//
//  Created by amirhosseinpy on 8/15/1398 AP.
//  Copyright © 1398 Farazpardazan. All rights reserved.
//

import Foundation

struct ServerError: Error {
    var code: Int?
    var message: String?
    var type: ErrorType?
    
    init(customError: String = "", type: ErrorType? = nil) {
        self.message = customError
        self.type = type
    }
    
    func getErrMsg() -> String {
        if code == -1 {
            return "error.network".localized
        } else {
            return self.message ?? ""
        }
    }
}

enum ErrorType: LocalizedError {
    case parseUrlFail
    case notFound
    case validationError
    case serverError
    case defaultError
}


