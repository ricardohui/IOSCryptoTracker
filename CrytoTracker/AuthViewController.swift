//
//  AuthViewController.swift
//  CrytoTracker
//
//  Created by Ricardo Hui on 29/5/2019.
//  Copyright © 2019 Ricardo Hui. All rights reserved.
//

import UIKit
import LocalAuthentication
class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        presentAuth()

        // Do any additional setup after loading the view.
    }
    
    func presentAuth(){
        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Your crypto is protected by biometics") { (success, error) in
            if success{
                DispatchQueue.main.async {
                    let cryptoTableVC = CryptoTableViewController()
                    let navController = UINavigationController(rootViewController: cryptoTableVC)
                    self.present(navController, animated: true, completion: nil)
                }
                
            }else{
                self.presentAuth()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
