//
//  FPColorExtension.swift
//  MallAR
//
//  Created by amirhosseinpy on 9/13/1399 AP.
//  Copyright © 1399 AP Farazpardazan. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(netHex: UInt) {
        let red = (netHex >> 16) & 0xff
        let green = (netHex >> 8) & 0xff
        let blue = netHex & 0xff

        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        let p3red = CGFloat(red) / 255.0
        let p3green = CGFloat(green) / 255.0
        let p3blue = CGFloat(blue) / 255.0
        self.init(displayP3Red: p3red, green: p3green, blue: p3blue, alpha: 1.0)
    }
}
