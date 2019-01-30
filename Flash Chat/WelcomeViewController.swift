//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit



class WelcomeViewController: UIViewController {

   
    @IBOutlet var appName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appName.alpha = 0
    
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 5) {
            self.appName.alpha = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
