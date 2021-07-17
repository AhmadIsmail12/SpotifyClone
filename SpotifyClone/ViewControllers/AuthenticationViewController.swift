//
//  AuthenticationViewController.swift
//  SpotifyClone
//
//  Created by Ahmad on 13/07/2021.
//

import UIKit
import WebKit

class AuthenticationViewController : UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webKitView: WKWebView!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        self.webKitView.navigationDelegate = self
        guard let url = AuthenticationManager.shared.loginUrl else {
            return
        }
        self.webKitView.load(URLRequest(url: url))
    }
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard  let url = webView.url else {
            return
        }
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code" })?.value else {
            return
        }
        AuthenticationManager.shared.getTokenFromCode(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.webKitView.isHidden = true
                guard success else {
                    let alertVC = UIAlertController(title: "Opps", message: "Something went wrong!!", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self?.present(alertVC, animated: true, completion: nil)
                    return
                }
                
                let searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
                searchViewController.navigationController?.navigationBar.prefersLargeTitles = true
                searchViewController.navigationItem.setHidesBackButton(true, animated: true)
                searchViewController.navigationItem.largeTitleDisplayMode = .automatic
                self?.navigationController?.pushViewController(searchViewController, animated: true)
            }
        }
    }
}
