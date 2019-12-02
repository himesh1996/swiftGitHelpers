//
//  DateTime.swift
//  Ios_Code_Structure
//
//  Created by Youngbrainz Infotech on 11/01/19.
//  Copyright © 2019 Youngbrainz Infotech. All rights reserved.
//

import Foundation
import UIKit

public class DateTime:NSObject
{
    class func toDate(_ format: String,StrDate:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: StrDate)
        return date!
    }
    
    class func toString(_ format: String, date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.string(from: date)        
        return strDate
    }
}

func stringToDate(strDate: String, withFormat: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = withFormat
    let date = dateFormatter.date(from: strDate)
    return date ?? Date()
}

class DateTimeFormats
{
    static let EEEE_MMM_d_yyyy = "EEEE, MMM d, yyyy"                                    //Wednesday, Sep 12, 2018
    static let EEEE = "EEEE"                                    //Wednesday, Sep 12, 2018
    static let MM_dd_yyyy = "MM/dd/yyyy"                                                // 09/12/2018
    static let MM_dd_yyyy_HH_mm = "MM-dd-yyyy HH:mm"                                    // 09-12-2018 14:11
    static let MMM_d_h_mm_a = "MMM d, h:mm a"                                           // Sep 12, 2:11 PM
    static let MMMM_yyyy = "MMMM yyyy"                                                  // September 2018
    static let MMM_d_yyyy = "MMM d, yyyy"                                               // Sep 12, 2018
    static let E_d_MMM_yyyy_HH_mm_ss_Z = "E, d MMM yyyy HH:mm:ss Z"                     //Wed, 12 Sep 2018 14:11:54 +0000
    static let yyyy_MM_dd_T_HH_mm_ssZ = "yyyy-MM-dd'T'HH:mm:ssZ"                        // 2018-09-12T14:11:54+0000
    static let dd_MM_yy = "dd.MM.yy"                                                    // 12.09.18
    static let HH_mm_ss_SSS = "HH:mm:ss.SSS"                                            // 10:41:02.112
    static let DD_mm_yyyy = "DD/MM/YYYY"
    static let hh_mm_a = "hh:mm a"
    static let hh_mm_ss_a = "hh:mm:ss a"
    static let hh_mm_ss = "hh:mm:ss"
    static let dd_mm_yyyy = "dd-MM-yyyy"                                                // 28-2-2000
    static let yyyy_MM_dd = "yyyy-MM-dd"    
}

