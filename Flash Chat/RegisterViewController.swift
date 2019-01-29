//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        

        
        //TODO: Set up a new user on our Firbase database
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: self.emailTextfield.text!, password: self.passwordTextfield.text!) { (result, error) in
            if(error != nil){
                print(error!)
            }
            else {
                print("registration success")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "gotoChat", sender: self)
            }
        }
        

        
        
    } 
    
    
}
