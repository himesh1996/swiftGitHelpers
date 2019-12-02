//
//  WebService.swift
//  Wondate
//
//  Created by Himesh Soni on 01/01/19.
//  Copyright © 2019 YoungBrainz Infotech. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Alamofire
import SVProgressHUD

class WebService: NSObject {
    
    static var shared = WebService()
    
    struct UDefault {
        static func save(key : String, value : Any){
            UserDefaults.standard.set(value, forKey: key)
            UserDefaults.standard.synchronize()
        }
        static func get(key : String, value : Any){
            UserDefaults.value(forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    struct Alert {
        
        typealias alertCompletion = ((UIAlertAction)->())
        
        static func showAlert(title: String = "Alert", message: String, viewController : UIViewController, okAction : @escaping alertCompletion){
            let aAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let aAlertOK = UIAlertAction(title: "Ok", style: .default, handler: okAction)
            
            aAlertController.addAction(aAlertOK)
            
            viewController.present(aAlertController, animated: true, completion: nil)
            
        }
        
        static func showAlert(title: String = "Alert", message: String, button : [String], viewController : UIViewController, completionHandler : ((Int)->())? = nil) -> UIAlertController{
            let aAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            for (aIndex,aTitle) in button.enumerated(){
                
                let aAlert = UIAlertAction(title: aTitle, style: .default, handler: { (aAction) in
                    completionHandler?(aIndex)
                })
                
                aAlertController.addAction(aAlert)
            }
            
            viewController.present(aAlertController, animated: true, completion: nil)
            return aAlertController
        }
    }
    
    struct Loader {
        static func show() {
            appDelegate.addProgressView()
        }
        
        static func hide() {
            appDelegate.hideProgrssVoew()
        }
    }
    
    struct Request {
        
        static func patch(url: String, type: HTTPMethod ,parameter : [String:Any]?, callSilently : Bool = false , header : HTTPHeaders? = nil, completionBlock : (([String:Any]?,Error?)->())?){
            
            request(url: url, type: type, parameter: parameter, callSilently :callSilently, header: header, completionBlock: completionBlock)
        }
        
        static func get(url: String, parameter : [String:Any]?, header : HTTPHeaders? = nil, callSilently : Bool = false, encoding:ParameterEncoding = URLEncoding.httpBody, completionBlock : (([String:Any]?,Error?)->())?){
            
            request(url: url, type: .get, parameter: parameter, callSilently :callSilently, header: header, encoding: encoding, completionBlock: completionBlock)
        }
        
        private static func request(url: String, type : HTTPMethod, parameter : [String:Any]?, callSilently : Bool = false, header : HTTPHeaders? = nil,encoding:ParameterEncoding = URLEncoding.httpBody, completionBlock : (([String:Any]?,Error?)->())?){
            
            
            guard let aUrl = URL(string: url) else { return }
            guard checkNetworkConnectivity() else { return }
            
            print("========================================")
            print("API -> \(url)")
            print("Param -> \(parameter ?? [:])")
            print("========================================")
            
            let aController : UIViewController? = appDelegate.window?.rootViewController as? UINavigationController ?? appDelegate.window?.rootViewController
            
            if !callSilently {
                Loader.show()
                aController?.view.isUserInteractionEnabled = false
            }
            
            var urlencoding: ParameterEncoding!
            if url.contains("forgotPassword"){
                urlencoding = URLEncoding.httpBody
            }else{
                urlencoding = URLEncoding.httpBody
            }
            
            Alamofire.request(aUrl, method: type, parameters: parameter, encoding: urlencoding, headers: header).responseJSON { (aResponse) in
                
                if !callSilently {
                    Loader.hide()
                    aController?.view.isUserInteractionEnabled = true
                }
                
                guard aResponse.error == nil else {
                    completionBlock?(nil,aResponse.error)
                    return
                }
                
                guard let aDicResponse = aResponse.result.value as? [String:Any] else {
                    completionBlock?(nil,aResponse.error)
                    return
                }
                if let TempresponseDict:NSDictionary = aResponse.result.value as? NSDictionary
                {
                    if TempresponseDict.object(forKey: "status") != nil {
                        if TempresponseDict.object(forKey: "login_screen") as? Int == 1 {
                            resetDefaults()
                            let stpryboard = UIStoryboard.init(name: "Main", bundle: nil)
                            let objSelect = stpryboard.instantiateViewController(withIdentifier: "SelectUserTypeVC") as? SelectUserTypeVC
                            findtopViewController()?.navigationController?.pushViewController(objSelect!, animated: true)
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
                        }
                        else if appDelegate.selectedUserType == .StoreOwner{
                            if TempresponseDict.object(forKey: "is_payment") as? String == "0"{
                                if ((findtopViewController() as? SubscriptionVC) != nil){
                                    
                                }else{
                                    let stpryboard = UIStoryboard.init(name: "Main", bundle: nil)
                                    let objSelect = stpryboard.instantiateViewController(withIdentifier: "SubscriptionVC") as? SubscriptionVC
                                    objSelect?.isFrom = .SubscriptionExpire
                                    findtopViewController()?.navigationController?.pushViewController(objSelect!, animated: true)
                                }
                            }
                        }
                    }
                }
                completionBlock?(aDicResponse,aResponse.error)
            }
        }
        
        static func checkNetworkConnectivity(isSilent : Bool = false) -> Bool{
            guard ConnectivityNew.isConnectedToInternet() else {
                
                guard !isSilent else { return false }
                
                let _ : UIViewController? = appDelegate.window?.rootViewController as? UINavigationController ?? appDelegate.window?.rootViewController
                Alert.showAlert(message: "No Internet Connection!", viewController: findtopViewController()!) { (action) in
                    
                }
                
                return false
            }
            
            return true
        }
        
        static func uploadFiles(url: String, fileUrls : [URL], parameters:[String:String], isBackgroundPerform:Bool = false, headerForAPICall : [String:String] = ["Content-type": "multipart/form-data"] ,completion : ((DataResponse<Any>?,Error?)->())?) {
            
            guard let aUrl = URL(string: url) else { return }
            guard checkNetworkConnectivity(isSilent: true) else { return }
            
            let aController : UIViewController? = appDelegate.window?.rootViewController as? UINavigationController ?? appDelegate.window?.rootViewController
            
            if !isBackgroundPerform {
                
                aController?.view.isUserInteractionEnabled = false
                appDelegate.addProgressView()
            }
            
            let aFiles = fileUrls.map { (aUrl) -> Data in
                var aData = Data()
                
                do{
                    aData = try Data(contentsOf: aUrl)
                }catch{
                    
                }
                
                return aData
            }
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                for (aIndex,aFileData) in aFiles.enumerated() {
                    let aExtension = fileUrls[aIndex].lastPathComponent.components(separatedBy: ".").last!.lowercased()
                    let aFileName = fileUrls[aIndex].lastPathComponent.components(separatedBy: ".").first!
                    
                    if aExtension == "db" {
                        
                        if fileUrls.count > 0 {
                            
                            if FileManager.default.fileExists(atPath: fileUrls[aIndex].path){
                                if let cert = NSData(contentsOfFile: fileUrls[aIndex].path) {
                                    let aData = cert as Data
                                    print("aFileData: \(aData.count)")
                                    
                                    multipartFormData.append(aData, withName: "file[]", fileName: "\(aFileName + "." + aExtension)", mimeType: "application/octet-stream")
                                }
                            }
                        }
                        
                        
                    } else {
                        let aType = aExtension == "pdf" ? "application/pdf" : "image/\(aExtension)"
                        multipartFormData.append(aFileData, withName: "file[]", fileName: "\(aFileName + "." + aExtension)", mimeType: aType)
                    }
                    
                }
                
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, usingThreshold: UInt64.init(), to: aUrl, method: .post, headers: headerForAPICall) { (aResult) in
                
                func enableInteraction(){
                    DispatchQueue.main.async {
                        aController?.view.isUserInteractionEnabled = true
                        appDelegate.hideProgrssVoew()
                    }
                }
                
                switch aResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (aProgress) in
                        
                        if !isBackgroundPerform {
                        }
                    })
                    
                    upload.responseJSON { response in
                        
                        if !isBackgroundPerform {
                            enableInteraction()
                        }
                        
                        completion?(response,nil)
                    }
                case .failure(let error):
                    print(error)
                    if !isBackgroundPerform {
                        enableInteraction()
                    }
                    
                    completion?(nil,error)
                }
            }
        }

        //MARK Upload Multiple Image
        static func uploadMultipleFiles(url: String, singleImage: Any, images : [Any],other_images_key:String,profile_images_key:String, parameters:[String:String], isBackgroundPerform:Bool = false, headerForAPICall : [String:String] = ["Content-type": "multipart/form-data"] ,completion : (([String:Any]?,Error?)->())?) {
            
            guard let aUrl = URL(string: url) else { return }
            guard checkNetworkConnectivity(isSilent: true) else { return }
            
            if !isBackgroundPerform {
                appDelegate.addProgressView()
            }
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for i in 0..<images.count {
                    if ((images[i] as? UIImage) != nil){
                        let image = images[i] as? UIImage
                        multipartFormData.append(image!.jpegData(compressionQuality: 0.75)!, withName: "\(other_images_key)[\(i)]", fileName: "\(Date())file.jpeg", mimeType: "image/jpeg")
                    }else{
                    }
                }
                
                if singleImage as? UIImage != nil {
                    let image = singleImage as? UIImage
                    multipartFormData.append(image!.jpegData(compressionQuality: 0.75)!, withName: "\(profile_images_key)", fileName: "\(Date())file.jpeg", mimeType: "image/jpeg")
                }
                
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, usingThreshold: UInt64.init(), to: aUrl, method: .post, headers: headerForAPICall) { (aResult) in
                
                func enableInteraction(){
                    DispatchQueue.main.async {
                        appDelegate.hideProgrssVoew()
                    }
                }
                
                switch aResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (aProgress) in
                        
                        if !isBackgroundPerform {
                        }
                    })
                    
                    upload.responseJSON { response in
                        
                        if !isBackgroundPerform {
                            enableInteraction()
                        }
                        
                        guard let aDicResponse = response.result.value as? [String:Any] else {
                            completion?(nil,response.error)
                            return
                        }
                        completion?(aDicResponse,response.error)

                    }
                case .failure(let error):
                    print(error)
                    if !isBackgroundPerform {
                        enableInteraction()
                    }
                    
                    completion?(nil,error)
                }
            }
        }
        
        //MARK:- Single Image Upload
        //MARK Upload Multiple Image
        static func uploadSingleFiles(url: String, images : UIImage, withName: String, parameters:[String:String], isBackgroundPerform:Bool = false, headerForAPICall : [String:String] = ["Content-type": "multipart/form-data"] ,completion : (([String:Any]?,Error?)->())?){
            
            guard let aUrl = URL(string: url) else { return }
            guard checkNetworkConnectivity(isSilent: true) else { return }
            
            if !isBackgroundPerform {
                appDelegate.addProgressView()
            }
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                multipartFormData.append(images.jpegData(compressionQuality: 0.75)!, withName: withName, fileName: "\(Date())file.jpeg", mimeType: "image/jpeg")
               
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, usingThreshold: UInt64.init(), to: aUrl, method: .post, headers: headerForAPICall) { (aResult) in
                
                func enableInteraction(){
                    DispatchQueue.main.async {
                        appDelegate.hideProgrssVoew()
                    }
                }
                
                switch aResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (aProgress) in
                        
                        if !isBackgroundPerform {
                        }
                    })
                    
                    upload.responseJSON { response in
                        
                        if !isBackgroundPerform {
                            enableInteraction()
                        }
                        guard let aDicResponse = response.result.value as? [String:Any] else {
                            completion?(nil,response.error)
                            return
                        }
                        completion?(aDicResponse,response.error)
                        //completion?(response,nil)
                    }
                case .failure(let error):
                    print(error)
                    if !isBackgroundPerform {
                        enableInteraction()
                    }
                    
                    completion?(nil,error)
                }
            }
        }
    }
}

class ConnectivityNew
{
    class func isConnectedToInternet() ->Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}

extension UIViewController
{
    func alertOk(title:String, message:String, buttonTitle:String = "OK", completion: ((_ result:Bool) -> Void)? = nil)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        findtopViewController()?.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { action in
            completion?(true) } ))
    }
    
    func alertTwoButton(title:String,titleButtonAccept:String = "Yes", titleButtonReject:String = "No", message:String, completion: ((_ result:Bool) -> Void)? = nil)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: titleButtonAccept, style: .default, handler: { action in
            completion?(true) } ))
        alert.addAction(UIAlertAction(title: titleButtonReject, style: .default, handler: { action in
            completion?(false) } ))

    }

}

extension String
{
    func htmlAttributed(family: String?, size: CGFloat) -> NSAttributedString?
    {
        do
        {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                
                "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        }
        catch
        {
            print("error: ", error)
            return nil
        }
    }
    
    var htmlToAttributedString: NSAttributedString?
    {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do
        {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch
        {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String
    {
        return htmlToAttributedString?.string ?? ""
    }
}
