//
//  CommonFunction.swift
//  Aeropa
//
//  Created by Himesh Soni on 25/03/19.
//  Copyright © 2019 youngbrainz. All rights reserved.
//

import Foundation
import UIKit
import KWDrawerController
import GooglePlaces

class CommonFunction: NSObject {
    
    static func setContiner(VC aVC: String, parent : UIViewController, container : UIView, newController : ((UIViewController)->())? = nil){
        guard let aVC = parent.storyboard?.instantiateViewController(withIdentifier: aVC) else { return }
        
        newController?(aVC)
        
        for aView in container.subviews{
            aView.removeFromSuperview()
        }
        
        for aChildVC in parent.children{
            aChildVC.removeFromParent()
        }
        
        aVC.view.frame = container.bounds
        container.addSubview(aVC.view)
        parent.addChild(aVC)
    }
    
    static func setContinerOther(VC aVC: String, storyboardName:String, parent : UIViewController, container : UIView, newController : ((UIViewController)->())? = nil){
        let st = UIStoryboard.init(name: storyboardName, bundle: nil)
        let aVC = st.instantiateViewController(withIdentifier: aVC)
        
        newController?(aVC)
        
        for aView in container.subviews{
            aView.removeFromSuperview()
        }
        
        for aChildVC in parent.children{
            aChildVC.removeFromParent()
        }
        
        aVC.view.frame = container.bounds
        container.addSubview(aVC.view)
        parent.addChild(aVC)
    }
    
    static func getDatefromString(strdate:String) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let date = dateFormatter.date(from: strdate)!
            return date
        }
    
    static func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String
           {
               let calendar = NSCalendar.current
               let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
               let now = Date()
               let earliest = now < date ? now : date
               let latest = (earliest == now) ? date : now
               let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
          
               if (components.year! >= 2) {
                   return "\(components.year!) years ago"
               } else if (components.year! >= 1){
                   if (numericDates){
                       return "1 year ago"
                   } else {
                       return "Last year"
                   }
               } else if (components.month! >= 2) {
                   return "\(components.month!) months ago"
               } else if (components.month! >= 1){
                   if (numericDates){
                       return "1 month ago"
                   } else {
                       return "Last month"
                   }
               } else if (components.weekOfYear! >= 2) {
                   return "\(components.weekOfYear!) weeks ago"
               } else if (components.weekOfYear! >= 1){
                   if (numericDates){
                       return "1 week ago"
                   } else {
                       return "Last week"
                   }
               } else if (components.day! >= 2) {
                   return "\(components.day!) days ago"
               } else if (components.day! >= 1){
                   if (numericDates){
                       return "1 day ago"
                   } else {
                       return "Yesterday"
                   }
               } else if (components.hour! >= 2) {
                   return "\(components.hour!) hours ago"
               } else if (components.hour! >= 1){
                   if (numericDates){
                       return "1 hour ago"
                   } else {
                       return "An hour ago"
                   }
               } else if (components.minute! >= 2) {
                   return "\(components.minute!) minutes ago"
               } else if (components.minute! >= 1) {
                   if (numericDates){
                       return "1 minute ago"
                   } else {
                       return "A minute ago"
                   }
               } else if (components.second! >= 3) {
                   return "\(components.second!) seconds ago"
               } else {
                   return "Just now"
               }
           }
    
   static func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        
        return dateFormatter.string(from: dt!)
    }
}

func resetDefaults() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
        defaults.removeObject(forKey: key)
    }
}

func getSymbolForCurrencyCode(code: String) -> String {
    var candidates: [String] = []
    let locales: [String] = NSLocale.availableLocaleIdentifiers
    for localeID in locales {
        guard let symbol = findMatchingSymbol(localeID: localeID, currencyCode: code) else {
            continue
        }
        if symbol.count == 1 {
            return symbol
        }
        candidates.append(symbol)
    }
    let sorted = sortAscByLength(list: candidates)
    if sorted.count < 1 {
        return ""
    }
    return sorted[0]
}

func findMatchingSymbol(localeID: String, currencyCode: String) -> String? {
    let locale = Locale(identifier: localeID as String)
    guard let code = locale.currencyCode else {
        return nil
    }
    if code != currencyCode {
        return nil
    }
    guard let symbol = locale.currencySymbol else {
        return nil
    }
    return symbol
}

func sortAscByLength(list: [String]) -> [String] {
    return list.sorted(by: { $0.count < $1.count })
}

//Alert Popup

func switchRootViewController()
{
    let appDelObj = UIApplication.shared.delegate as! AppDelegate
    let status = false
    var sideMenuVC : SideMenuVC!
    let aStory = UIStoryboard.init(name: "Main", bundle: nil)
    var mainViewController = UIViewController()
    var menuViewController = UIViewController()
    
    if status {
        mainViewController = aStory.instantiateViewController(withIdentifier: "")
    } else {
        mainViewController = aStory.instantiateViewController(withIdentifier: "")
    }
    
    menuViewController = aStory.instantiateViewController(withIdentifier: "sideMenuVC")
    sideMenuVC = menuViewController as? SideMenuVC
    
    let aDrawer = DrawerController()
    aDrawer.setViewController(mainViewController, for: .none)
    aDrawer.setViewController(menuViewController, for: .left)
    appDelObj.window?.rootViewController = aDrawer
    appDelObj.window?.makeKeyAndVisible()
}


