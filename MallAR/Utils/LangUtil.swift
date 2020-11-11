//
//  LangUtil.swift
//  MallAR
//
//  Created by amirhosseinpy on 8/15/1398 AP.
//  Copyright © 1398 Farazpardazan. All rights reserved.
//

import Foundation

class LangUtil: NSObject {
    static var lang = "Base"
    
    static func changeLanguage(newLang: String) {
        UserDefaults.standard.setValue(newLang, forKey: "selectedLanguage")
        UserDefaults.standard.synchronize()
        
        lang = newLang
    }
    
    static func loadLanguage() {
        let targetLang = UserDefaults.standard.object(forKey: "selectedLanguage") as? String
        lang = targetLang ?? "Base"
    }
}
