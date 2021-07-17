//
//  ViewController.swift
//  SpotifyClone
//
//  Created by Ahmad on 13/07/2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginBtn.layer.cornerRadius = 13
        title = "Login"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    @IBAction func onClickLoginBtn(_ sender: Any) {
        let authenticationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthenticationViewController") as! AuthenticationViewController
        authenticationViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(authenticationViewController, animated: true)
    }

}

