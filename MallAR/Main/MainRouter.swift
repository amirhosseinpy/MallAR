//
//  MainRouter.swift
//  MallAR
//
//  Created by amirhosseinpy on 6/13/1399 AP.
//  Copyright © 1399 Farazpardazan. All rights reserved.
//

import Foundation

struct MainRouter: APIRouter {
    typealias ResponseType = [EntityModel]
    static var method: HTTPMethod = .get
    static var path: String = ""
    
    var requestBody: Encodable?
}

struct EntityModel: Codable {
    let name: String?
    let url: String?
}
