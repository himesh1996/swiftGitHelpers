//
//  CountryList.swift
//  Ios_Code_Structure
//
//  Created by Youngbrainz Infotech on 19/01/19.
//  Copyright © 2019 Youngbrainz Infotech. All rights reserved.
//

import Foundation
import CoreTelephony

class CountryList2 : NSObject
{
    static let CountryListSharedManager = CountryList2()
    
    override init ()
    {
        super.init()
    }
    
    func GetCountryList() -> [String]
    {
        //MARK:- Country List
        var countries: [String] = []
        for code in NSLocale.isoCountryCodes as [String]
        {
            //let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.languageCode.rawValue : code])
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
         }        
        return countries
    }
    
    func getcountry(code: String) -> String{
        var networkInfo = CTTelephonyNetworkInfo()
        var carrier: CTCarrier? = networkInfo.subscriberCellularProvider
        
        
        // Get carrier name
        var carrierName = carrier?.carrierName
        if carrierName != nil {
            print("Carrier: \(carrierName ?? "")")
        }
        
        // Get mobile country code
        var mcc = carrier?.mobileCountryCode
        if mcc != nil {
            print("Mobile Country Code (MCC): \(mcc ?? "")")
        }
        
        // Get mobile network code
        var mnc = carrier?.mobileNetworkCode
        
        if mnc != nil {
            print("Mobile Network Code (MNC): \(mnc ?? "")")
        }
        return ""
    }
    
}
