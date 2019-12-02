//
//  Extension.swift
//  Ios_Code_Structure
//
//  Created by Youngbrainz Infotech on 10/01/19.
//  Copyright © 2019 Youngbrainz Infotech. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import AVKit

func IS_INTERNET_AVAILABLE()->Bool{
    var Status:Bool = false
    let url = URL(string: "http://google.com/")
    let request = NSMutableURLRequest(url: url!)
    request.httpMethod = "HEAD"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
    request.timeoutInterval = 10.0
    
    var response: URLResponse?
    _ = try? NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as Data?
    
    if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 200 {
            Status = true
        }
    }
    return Status
}

func findtopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
        return findtopViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
        if let selected = tabController.selectedViewController {
            return findtopViewController(controller: selected)
        }
    }
    if let presented = controller?.presentedViewController {
        return findtopViewController(controller: presented)
    }
    return controller
}


func alertController(message: String , controller: UIViewController)
{
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
    
    let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        controller.dismiss(animated: true, completion: nil)
    }
    
    alertController.addAction(action1)
    controller.present(alertController, animated: true, completion: nil)
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIView
{
    //MARk:- Make Corner radius On Top
    func CorneronTop(cornerRadius: CGFloat, frame: CGRect)
    {
        let path = UIBezierPath(roundedRect:frame,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: cornerRadius, height:  cornerRadius))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    //MARk:- Make Corner radius On Top
    func CorneronBottom(cornerRadius: CGFloat, frame: CGRect)
    {
        let path = UIBezierPath(roundedRect:frame,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: cornerRadius, height:  cornerRadius))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
//    func setShadow(cornerRadius: CGFloat)
//    {
//        //Create Shadow
//        self.layer.cornerRadius = cornerRadius
//        // drop shadow
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        self.layer.shadowOpacity = 0.8
//        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        self.layer.shadowRadius = 3.0
//    }
    
    func setShadow(cornerRadius: CGFloat){
            let shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 5.0
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }

    
    func setUpSahadow()
    {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 3
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
}

func localegetCountryCOde(forfullCountryName : String) -> String {
    let locales : String = ""
    for localeCode in NSLocale.isoCountryCodes {
        let identifier = NSLocale(localeIdentifier: localeCode)
        let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
        if forfullCountryName.lowercased() == countryName?.lowercased() {
            return localeCode
        }
    }
    return locales
}

extension Locale {
    static let currencies = Dictionary(uniqueKeysWithValues: Locale.isoRegionCodes.map {
        region -> (String, (code: String, symbol: String, locale: Locale)) in
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: region]))
        return (region, (locale.currencyCode ?? "", locale.currencySymbol ?? "", locale))
    })
}

func timeAgoSinceDate(_ date:Date) -> String {
    let calendar = NSCalendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let now = Date()
    let earliest = now < date ? now : date
    let latest = (earliest == now) ? date : now
    let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
    if (components.year! >= 1) || (components.month! >= 1) || (components.weekOfYear! >= 1) || (components.day! >= 7){
        return "\(DateTime.toString(DateTimeFormats.dd_mm_yyyy, date: date)) at \(DateTime.toString(DateTimeFormats.hh_mm_a, date: date))"
    }else if (components.day! >= 2){
        return "\(DateTime.toString(DateTimeFormats.EEEE, date: date))"
    }
    else{
        if (components.day! == 1){
            return "Yesterday"
        }else{
            return "Today"
        }
    }
}

extension UIView {
    
    func zoomInWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform.identity
            }, completion: { (completed: Bool) -> Void in
            })
        })
    }
    
}

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

func previewImageForLocalVideo(url:URL) -> UIImage?
{
    let asset = AVAsset(url: url)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    
    var time = asset.duration
    //If possible - take not the first frame (it could be completely black or white on camara's videos)
    time.value = min(time.value, 2)
    
    do {
        let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
        return UIImage(cgImage: imageRef)
    }
    catch let error as NSError
    {
        print("Image generation failed with error \(error)")
        return nil
    }
}

func generateThumbnailcomp(path: URL,completion: @escaping (UIImage) -> Swift.Void) {
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            do {
                let asset = AVURLAsset(url: path, options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                completion(thumbnail)
            } catch _ {
                completion(UIImage (named: "")!)
            }
        }
    }
}

func generateThumbnail(path: URL) -> UIImage? {
    do {
        let asset = AVURLAsset(url: path, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        return thumbnail
    } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return nil
    }
}


func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
    let urlAsset = AVURLAsset(url: inputURL, options: nil)
    guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetLowQuality) else {
        handler(nil)
        
        return
    }
    
    exportSession.outputURL = outputURL
    exportSession.outputFileType = AVFileType.mov
    exportSession.shouldOptimizeForNetworkUse = true
    exportSession.exportAsynchronously { () -> Void in
        handler(exportSession)
    }
}

func dropShadow(view: UIView,color: UIColor, opacity: Float = 0.2, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    view.layer.masksToBounds = false
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOpacity = opacity
    view.layer.shadowOffset = offSet
    view.layer.shadowRadius = radius
}

extension Dictionary {
    func nullKeyRemoval() -> Dictionary {
        var dict = self
        
        let keysToRemove = Array(dict.keys).filter { dict[$0] is NSNull }
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }
        
        return dict
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
        // or use capitalized(with: locale) if you want
    }
}

extension UINavigationController {
    
    func backToViewController(vc: Any) {
        // iterate to find the type of vc
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}

extension Locale {
    static let currency: [String: (code: String?, symbol: String?)] = Locale.isoRegionCodes.reduce(into: [:]) {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $1]))
        $0[$1] = (locale.currencyCode, locale.currencySymbol)
    }
}

