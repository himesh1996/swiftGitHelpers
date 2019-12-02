//
//  PaypalIntegration.swift
//  Eljebo
//
//  Created by Developer on 1/23/19.
//  Copyright © 2019 YoungBrainz Infotech. All rights reserved.
//

import UIKit

//Paypal Keys
let PaypalTestKey = "AUcf9Pbim2lmQioXCOL8rwBzt4rggf8XCFaU0T6dYvRXtJnzrwgm_DQw_S4rO5uD7PNvOHJ8gYRPDI9A"//"Test ClientID"
let PaypalLiveKey = "AXHJ9aYcjf4Z7W23jrcm-BrTLH_DhrqxdIlE7u1aLPMc6likc4SDSogmfvESG2HIliYfEsHF3pVFVGEw"//"Production ClientID"

//PAYPAL SANDBOX CLIENT ID PERSONAL ACCOUNT
//public static final String PAYPAL_PERSONAL_CLIENT_ID = "AUcf9Pbim2lmQioXCOL8rwBzt4rggf8XCFaU0T6dYvRXtJnzrwgm_DQw_S4rO5uD7PNvOHJ8gYRPDI9A";
//PAYPAL PRODUCTION CLIENT ID PERSONAL ACCOUNT
//public static final String PAYPAL_PERSONAL_CLIENT_ID = "AXHJ9aYcjf4Z7W23jrcm-BrTLH_DhrqxdIlE7u1aLPMc6likc4SDSogmfvESG2HIliYfEsHF3pVFVGEw";

class PaypalIntegration: NSObject, PayPalPaymentDelegate {

    static let sharedClient = PaypalIntegration()
    var payPalConfig = PayPalConfiguration()
    let items:NSMutableArray = NSMutableArray()
    
    var CreditCardAccepted: Bool = true
    
    var blockPaymentStatus: ((Bool,[String:Any])->())!
    var environment:String = PayPalEnvironmentSandbox
    {
        willSet(newEnvironment)
        {
            if (newEnvironment != environment)
            {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }

    func initPaypal()
    {
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction:PaypalLiveKey,PayPalEnvironmentSandbox:PaypalTestKey])
    }
    
    //MARK: Custom Method
    func setItems(strItemName:String?, noOfItem:String?, strPrice:String?, strCurrency:String?, strSku:String?)
    {
        let quantity : UInt = UInt(noOfItem!)!
        
        let item = PayPalItem.init(name: strItemName!, withQuantity: quantity, withPrice: NSDecimalNumber(string: strPrice), withCurrency: strCurrency!, withSku: strSku)
        items.add(item)
        print("\(items)")
    }
    
    //MARK: Configure paypal
    func configurePaypal(strMarchantName:String, acceptCreditCard: Bool, setenvironment:String)
    {
        if items.count>0
        {
            items.removeAllObjects()
        }
        CreditCardAccepted = acceptCreditCard
        environment = setenvironment
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = CreditCardAccepted;
        payPalConfig.merchantName = strMarchantName
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")! as URL
        payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")! as URL
        
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages[0]
        
        payPalConfig.payPalShippingAddressOption = .payPal;
        
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    //MARK: Paypal
    func acceptCreditCards() -> Bool
    {
        return self.payPalConfig.acceptCreditCards
    }
    
    func setAcceptCreditCards(acceptCreditCards: Bool)
    {
        self.payPalConfig.acceptCreditCards = self.acceptCreditCards()
    }
    
    //MARK: Start Payment
    func goforPayNow(shipPrice:String?, taxPrice:String?, totalAmount:String?, strShortDesc:String?, strCurrency:String?)
    {
        var subtotal : NSDecimalNumber = 0
        var shipping : NSDecimalNumber = 0
        var tax : NSDecimalNumber = 0
        if items.count > 0 {
            subtotal = PayPalItem.totalPrice(forItems: items as [AnyObject])
        } else {
            subtotal = NSDecimalNumber(string: totalAmount)
        }
        
        // Optional: include payment details
        if (shipPrice != nil) {
            shipping = NSDecimalNumber(string: shipPrice)
        }
        if (taxPrice != nil) {
            tax = NSDecimalNumber(string: taxPrice)
        }
        
        var description = strShortDesc
        if (description == nil) {
            description = ""
        }
        
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: strCurrency!, shortDescription: description!, intent: .sale)
        
        payment.items = items as [AnyObject]
        payment.paymentDetails = paymentDetails
        
        self.payPalConfig.acceptCreditCards = CreditCardAccepted;
        
        if self.payPalConfig.acceptCreditCards == true {
            print("We are able to do the card payment")
        }
        
        if (payment.processable) {
            let objVC = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            
            findtopViewController()!.present(objVC!, animated: true, completion: { () -> Void in
                print("Paypal Presented")
            })
        }
        else {
            print("Payment not processalbe: \(payment)")
            blockPaymentStatus(false,[:])
            alertController(message: "Whoops!. Something went wrong, Please try again later.", controller: findtopViewController()!)
        }
    }
    
    //MARK:- PayPal Payment Delegate
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController)
    {
        paymentViewController.dismiss(animated: true, completion: nil)
        blockPaymentStatus(false,[:])
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment)
    {
        paymentViewController.dismiss(animated: true) { () -> Void in
            print("and done")
            let paymentResponse = completedPayment.confirmation
            self.blockPaymentStatus(true,(paymentResponse["response"] as? [String:Any])!)
        }
        print("Paymant is going on")
    }
}
