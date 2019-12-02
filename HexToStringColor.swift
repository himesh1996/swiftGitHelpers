//
//  HexToStringColor.swift
//  Ios_Code_Structure
//
//  Created by Youngbrainz Infotech on 30/01/19.
//  Copyright © 2019 Youngbrainz Infotech. All rights reserved.
//

import Foundation

class HextoStringColor: NSObject
{
    static let HexColorSharedManager = HextoStringColor()
    
    override init ()
    {
        super.init()
    }
    
//    func hexStringToUIColor (hex:String) -> UIColor {
//        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//        
//        if (cString.hasPrefix("#")) {
//            cString.remove(at: cString.startIndex)
//        }
//        
//        if ((cString.count) != 6) {
//            return UIColor.gray
//        }
//        
//        var rgbValue:UInt32 = 0
//        Scanner(string: cString).scanHexInt32(&rgbValue)
//        
//        return UIColor(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
//    }    
}
