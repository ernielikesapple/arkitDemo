//
//  LogInVC.swift
//  ARKitDemo
//
//  Created by ernie on 3/10/2017.
//  Copyright © 2017 ernie.cheng. All rights reserved.
//

import UIKit

 // https://www.youtube.com/watch?v=Lrc-MX8WgNc
class LogInVC: UIViewController {

    enum LogInError: Error {
        case incompleteForm
        case invaildEmail
        case incorrectPasswordLength
    }
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    
    @IBAction func LogInButtonTapped(_ sender: Any) {
        do {
            try logIn()
            // transion to next screen
            //performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
            
        } catch LogInError.incompleteForm {
            Alert.showBasic(title: "Incomplete Form", message: "Please fill out both email and password fields", vc: self)
        } catch LogInError.invaildEmail {
            Alert.showBasic(title: "Invalid Email Format", message: "Please make sure you format your email correctly", vc: self)
        } catch LogInError.incorrectPasswordLength {
            Alert.showBasic(title: "Password is too short", message: "Password should be at least 8 characters", vc: self)
        } catch {
            // a general error
            Alert.showBasic(title: "Unable To Login", message: "There was an error when attempting to login", vc: self)
        }
        
    }
    
    func logIn() throws {
        let email = emailTF.text!
        let password = PasswordTF.text!
        
        if email.isEmpty || password.isEmpty {
            throw LogInError.incompleteForm
        }
        
        if !email.isValidEmail {
            throw LogInError.invaildEmail
        }
        
        // it will be much more complicated based on real requirements
        if password.count < 8 {
            throw LogInError.incorrectPasswordLength
        }
        
        // LogIn func goes here
        // save to keychain blah blah...
       // Alert.showBasic(title: "Good", message: "😄", vc: self)
        
        performSegue(withIdentifier: "successLogIn", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
