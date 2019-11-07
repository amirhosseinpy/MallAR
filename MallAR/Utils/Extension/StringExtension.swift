//
//  StringExtension.swift
//  MallAR
//
//  Created by amirhosseinpy on 8/15/1398 AP.
//  Copyright © 1398 Farazpardazan. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: LangUtil.lang, bundle: Bundle.main, value: "", comment: "")
    }
}
