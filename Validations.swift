//
//  Validations.swift
//  Ios_Code_Structure
//
//  Created by Youngbrainz Infotech on 11/01/19.
//  Copyright © 2019 Youngbrainz Infotech. All rights reserved.
//

import Foundation
import UIKit

public class Validate:NSObject
{
    //MARK:- Textfield Blank Validation
    class func isEmpty(teststr:UITextField) -> Bool
    {
        if (teststr.text?.isEmpty)!
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    //MARK:- Textfield Whitespace Validation
    class func isWhiteSpace(teststr:UITextField) -> Bool
    {
        if !(((teststr.text?.trimmingCharacters(in: .whitespacesAndNewlines))?.count)! > 0)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    //MARK:- Email Validation
    class func isValidEmail(testStr:String) -> Bool
    {   
        let emailTest = NSPredicate(format:"SELF MATCHES %@", Email_RegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //MARK:- Mobile Validation Format 123-123-1234
    class func isValidPhoneFormat(teststr: String) -> Bool
    {        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", Phone_RegEx_Format)
        return phoneTest.evaluate(with: teststr)
    }
    
    //MARK:- Mobile Validation With Plus(+) Sign And 6 to 10 Digit
    class func isValidPhonePlusSign(testStr:String) -> Bool
    {
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", Phone_RegEx_PlusSign)
        return phoneTest.evaluate(with: testStr)
    }
    
    //MARK:- Mobile Validation With 10 Digit
    class func isValidPhoneDigit(testStr:String) -> Bool
    {
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", Phone_RegEx_10Digit)
        return phoneTest.evaluate(with: testStr)
    }
    
    //MARK:- Zip/Pin Code Validation With 6 Digit
    class func isValidZipcode(testStr:String) -> Bool
    {
        let zipTest = NSPredicate(format:"SELF MATCHES %@", Zip_RegEx)
        return zipTest.evaluate(with: testStr)
    }
    
    //MARK:- Password Validation Format Abv@123 With Atleast 6 Digit
    class func isValidPassword(testStr:String?) -> Bool
    {
        guard testStr != nil else { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", Password_RegEx)
        return passwordTest.evaluate(with: testStr)
    }
}
