//
//  AuthWebViewViewController.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import UIKit
import WebKit
import Combine

class AuthWebViewViewController: BaseViewController {
    
    
    @IBOutlet weak var webView: WKWebView!{
        didSet{
            let prefs = WKWebpagePreferences()
            prefs.allowsContentJavaScript = true
            let config = WKWebViewConfiguration()
            config.defaultWebpagePreferences = prefs
        }
    }
    
    
    var token = CurrentValueSubject<String?,Never>(nil)
    var disposeBag : Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.initializeWebView()
        self.loadWebView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.frame = view.bounds
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension AuthWebViewViewController {
    
    private func initializeWebView(){
        webView.navigationDelegate = self
        self.view.addSubview(webView)
    }
    
    private func loadWebView(){
        let finalUrl = Constants.authenticationBaseURL + (Constants.authenticationBody ?? "")
        guard let url = URL(string: finalUrl) else {return}
        debugPrint(url)
        webView.load(URLRequest(url: url))
    }
    
    static func buildController() -> AuthWebViewViewController {
        let controller = AppStoryboard.AuthWebView.viewController(viewControllerClass: AuthWebViewViewController.self)
        return controller
    }
    
}

extension AuthWebViewViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {return}
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else{return}
        webView.isHidden = true
        debugPrint(code)
        self.token.send(code)
        self.navigationController?.popViewController(animated: true)
    }
}
