//
//  ViewController.swift
//  tcc-swift
//
//  Created by Diego on 8/7/16.
//  Copyright © 2016 ifsp. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //views
    @IBOutlet var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //signInView
    @IBOutlet var signInView: UIView!
    @IBOutlet weak var signInEmailTextField: UITextField!
    @IBOutlet weak var signInPasswordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var goToSignUpButton: UIButton!
    @IBOutlet var goToResetPasswordButton: UIButton!
    
    //signUpView
    @IBOutlet var signUpView: UIView!
    @IBOutlet weak var signUpNameTextField: UITextField!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPassTextField: UITextField!
    @IBOutlet weak var signUpPassConfirmationTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var cancelSignUpButton: UIButton!
    
    //resetPasswordView
    @IBOutlet var resetPasswordView: UIView!
    @IBOutlet weak var resetPasswordEmailTextField: UITextField!
    @IBOutlet var resetPasswordButton: UIButton!
    @IBOutlet var cancelResetPasswordButton: UIButton!
    
    var delegate: AppDelegate!
    var defaults: NSUserDefaults!
    var context: NSManagedObjectContext!
    var urlPath: NSString = ""
    var loggedUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //prepareViewa
        hiddenAllViews()
        showSignInView()
        
        //init defaults vars
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        defaults = NSUserDefaults.standardUserDefaults()
        
        context = delegate.managedObjectContext
        
        urlPath = "http://localhost:3000/api"
        
        //loading settings
        let obj = self.defaults.stringForKey("loggedUser")
        
        let select = NSFetchRequest()
        
        select.predicate = NSPredicate(format: "token == %@", obj!)
        
        select.returnsObjectsAsFaults = false
        
        do {
            let results = try self.context.executeFetchRequest(select)
            
            if results.count > 0 {
                print(results.count)
            }
        }catch{
            print(loggedUser.name)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //signInView
    @IBAction func signIn(sender: UIButton) {
        print("SignIn")
        
        let stringURL = urlPath .stringByAppendingString("/user/sign_in")
        
        let url = NSURL(string: stringURL)!
        
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 10)
        
        request.HTTPMethod = "POST"
        
        var userClass = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as! User
        
        userClass.email = signInEmailTextField.text
        let password = signInPasswordTextField.text
        
        let bodyData = String(format: "user[email]=%@&user[password]=%@", userClass.email!, password!)
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if (error != nil){
                print(error)
            }else{
                do{
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    
                    if (jsonResult is NSArray){
                        print(jsonResult)
                    }
                    else if(jsonResult is NSDictionary){
                        print(jsonResult)
                        
                        let user: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.context)
                        
                        for (key, value) in jsonResult as! NSDictionary {
                                print("Property: \"\(key as! String)\" Value: \"\(value as! String)\" ")
                            
                            user.setValue(value, forKey:key as! String);
                        }
                        
                        userClass = user as! User
                        
                        print (userClass.token)
                        
                        
                        do {
                            try self.context.save()
                            self.defaults.setObject(userClass.token, forKey: "loggedUser")
                        }catch{
                        }
                        
                    }else if(jsonResult is NSString){
                        print(jsonResult)
                    }
                    print(jsonResult)
                }catch {
                    //let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    //self.returnTextView.text = String(datastring)
                    print(error)
                    
                    let select = NSFetchRequest(entityName: "User")
                    
                    select.returnsObjectsAsFaults = false
                    
                    do {
                        let results = try self.context.executeFetchRequest(select)
                        
                        if results.count > 0 {
                            print(results.count)
                        }
                    }catch{
                    }
                }
            }
        }
        
        task.resume()
        
        
        
    }
    
    @IBAction func goToSignUp(sender: UIButton){
        showSignUpView()
    }
    
    @IBAction func goToResetPassword(sender: UIButton){
        showResetPasswordView()
    }
    
    //signUpView
    @IBAction func signUp(sender: UIButton) {
        print("SignUp")
        
        let stringURL = urlPath .stringByAppendingString("/user/sign_up")
        
        let url = NSURL(string: stringURL as String)!
        
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 10)
        
        request.HTTPMethod = "POST"
        
        let userClass = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as! User
        
        userClass.name = signUpNameTextField.text
        userClass.email = signUpEmailTextField.text
        let password = signUpPassTextField.text
        let passwordConfirmation = signUpPassConfirmationTextField.text
        
        let bodyData = String(format: "user[name]=%@&user[email]=%@&user[password]=%@&user[password_confirmation]=%@", userClass.name!, userClass.email!, password!, passwordConfirmation!)
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if (error != nil){
                print(error)
            }else{
                do{
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    
                    if (jsonResult is NSArray){
                        print(jsonResult)
                    }
                    else if(jsonResult is NSDictionary){
                        print(jsonResult)
                        
                        let userObj: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.context)
                        if (jsonResult.count > 1){
                            for (key, value) in jsonResult as! NSDictionary {
                                print("Property: \"\(key as! String)\" Value: \"\(value as! String)\" ")
                                
                                userObj.setValue(value, forKey:key as! String);
                            }
                            
                            do { try self.context.save() }catch{}
                        }else{
                            for (key, value) in jsonResult as! NSDictionary {
                                print("Property: \"\(key as! String)\" Value: \"\(value)\" ")
                            }
                        }
                    }else if(jsonResult is NSString){
                        print(jsonResult)
                    }
                    print(jsonResult)
                }catch {
                    //let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    //self.returnTextView.text = String(datastring)
                    print(error)
                    
                    let select = NSFetchRequest(entityName: "User")
                    
                    select.returnsObjectsAsFaults = false
                    
                    do {
                        let results = try self.context.executeFetchRequest(select)
                        
                        if results.count > 0 {
                            print(results.count)
                        }
                    }catch{
                    }
                }
            }
        }
        
        task.resume()
  
    }
    
    @IBAction func cancelSignUp(sender: UIButton) {
        showSignInView()
    }
    
    //resetPasswordView
    @IBAction func resetPassword(sender: UIButton) {
        showSignInView()
    }
    
    @IBAction func cancelResetPassword(sender: UIButton) {
        showSignInView()
    }
    
    //manipulateViews
    func hiddenAllViews() {
        //signInView
        signInView.hidden = true
        signInEmailTextField.text = ""
        signInPasswordTextField.text = ""
        
        //signUpView
        signUpView.hidden = true
        signUpNameTextField.text = ""
        signUpEmailTextField.text = ""
        signUpPassTextField.text = ""
        signUpPassConfirmationTextField.text = ""
        
        //resetPasswordView
        resetPasswordView.hidden = true
        resetPasswordEmailTextField.text = ""
    }
    
    func showSignInView() {
        hiddenAllViews()
        
        signInView.hidden = false
    }
    
    func showSignUpView() {
        hiddenAllViews()
        
        signUpView.hidden = false
    }
    
    func showResetPasswordView() {
        hiddenAllViews()
        
        resetPasswordView.hidden = false
    }
    
}