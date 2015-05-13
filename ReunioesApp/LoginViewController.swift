//
//  LoginViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/8/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit
import Parse
import iAd

class LoginViewController: UIViewController, UITextFieldDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, ADBannerViewDelegate {

    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var product_id: NSString?;
    @IBOutlet weak var banner: ADBannerView!
    var iad:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.product_id = "Pope.ReunioesApp"
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.enableInputs()
        self.activityIndicator.stopAnimating()
        if User.getCurrentUser() != nil {
            self.performSegueWithIdentifier("showMainMenu", sender: nil)
        }
        
        if(iad.boolForKey("iad")){
            banner.hidden = true
        }
    }
    
    func disableInputs(){
        for subview in self.view.subviews {
            if subview.isKindOfClass(UIButton) {
                (subview as! UIButton).enabled = false
            }
        }
    }
    
    func enableInputs(){
        for subview in self.view.subviews {
            if subview.isKindOfClass(UIButton) {
                (subview as! UIButton).enabled = true
            }
        }
    }
    
    func login(){
        
        self.activityIndicator.startAnimating()
        
        self.disableInputs()
        
        let closure = {(succeeded:Bool) -> Void in
            
            self.enableInputs()
            
            self.activityIndicator.stopAnimating()
            
            if (succeeded) {
                self.performSegueWithIdentifier("showMainMenu", sender: nil)
            } else {
                var alert = UIAlertView(title: "Error", message: "Parse error", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            
        }
        
        User.login(txfUsername.text, password: txfPassword.text, closure: closure)
        
        self.txfPassword.text = ""

    }
    
    @IBAction func didPressLogin(sender: AnyObject) {
        
        var username = self.txfUsername.text
        var password = self.txfPassword.text
        
        if password == "" || username == ""{
            var alert = UIAlertView(title: "Error", message: "You must inform username and password", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
            return
        }
        
        self.login()
        
    }

    @IBAction func didPressSignUp(sender: AnyObject) {
        self.performSegueWithIdentifier("showSignUp", sender: nil)
    }

    @IBAction func unwindFromSignUpSegue(segue:UIStoryboardSegue) {
        let vc:SignUpViewController = segue.sourceViewController as! SignUpViewController
        if vc.didCreateNewAccount {
            self.login()
        }
    }
    
    @IBAction func unwindFromMainMenuSegue(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func didEndEditing(sender: AnyObject) {
        sender.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.returnKeyType == UIReturnKeyType.Next {
            self.txfPassword.becomeFirstResponder()
        }
        if textField.returnKeyType == UIReturnKeyType.Go {
            self.login()
        }
        
        return true
    }
    
    @IBAction func buyConsumable(sender: UIButton) {
        if (SKPaymentQueue.canMakePayments())
        {
            var productID:NSSet = NSSet(object: self.product_id!);
            var productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>);
            productsRequest.delegate = self;
            productsRequest.start();
            println("Buscando Produtos");
        }else{
            println("Não é possível fazer compras");
        }
    }
    
    func buyProduct(product: SKProduct){
        var payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment);
        
    }
    
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        var count : Int = response.products.count
        if (count>0) {
            var validProducts = response.products
            var validProduct: SKProduct = response.products[0] as! SKProduct
            if (validProduct.productIdentifier == self.product_id) {
                println(validProduct.localizedTitle)
                println(validProduct.localizedDescription)
                println(validProduct.price)
                buyProduct(validProduct);
            } else {
                println(validProduct.productIdentifier)
            }
        } else {
            println("nada")
        }
    }
    
    
    func request(request: SKRequest!, didFailWithError error: NSError!) {
        println("Falha");
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!)    {
        println("Pagamento recebido da apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .Purchased:
                    println("Produto comprado");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    iad.setBool(true, forKey: "iad")
                    iad.synchronize()
                    self.banner.hidden = true
                    break;
                case .Failed:
                    println("Compra falhou");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                    
                default:
                    break;
                }
            }
        }
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!){
        
    }
}
