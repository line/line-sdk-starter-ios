//
//  ViewController.swift
//  LineSDKStarterSwift
//
//  Copyright (c) 2015 Line corp. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    private let adapter = LineAdapter.default()!;

    override func viewDidLoad() {
        super.viewDidLoad()
        startObserveLineAdapterNotification()
    }

    func startObserveLineAdapterNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.authorizationDidChange(_:)),
                                               name: NSNotification.Name.LineAdapterAuthorizationDidChange, object: nil)
    }

    @IBAction func loginWithLine(_ sender: AnyObject) {
        if adapter.isAuthorized {
            alert("Already authorized", message: "")
            return
        }

        if !adapter.canAuthorizeUsingLineApp {
            alert("LINE is not installed", message: "")
            return
        }
        adapter.authorize()
    }

    @IBAction func loginInApp(_ sender: AnyObject) {
        if adapter.isAuthorized {
            alert("Already authorized", message: "")
            return
        }

        let viewController = LineAdapterWebViewController(adapter: adapter, with: LineAdapterWebViewOrientation.all)
        viewController.navigationItem.leftBarButtonItem = LineAdapterNavigationController.barButtonItem(withTitle: "Cancel", target: self, action: #selector(ViewController.cancel(_:)))
        let navigationController = LineAdapterNavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }

    @IBAction func tryApi(_ sender: AnyObject) {
        if !adapter.isAuthorized {
            alert("Login first!", message: "")
            return
        }

        adapter.getLineApiClient().getMyProfile {[unowned self] (profile, error) -> Void in
            if let error = error {
                self.alert("Error occured!", message: error.localizedDescription)
                return
            }

            let displayName = profile?["displayName"] as! String
            self.alert("Your name is \(displayName)", message: "")
        }
    }

    @IBAction func logout(_ sender: AnyObject) {
        adapter.unauthorize()
        alert("Logged out", message: "")
    }

    fileprivate func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let buttonAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
        alert.addAction(buttonAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController {

    func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    func authorizationDidChange(_ notification: Notification) {
        let adapter = notification.object as! LineAdapter

        if adapter.isAuthorized {
            dismiss(animated: true, completion: nil)
            alert("Login success!", message: "")
            return
        }

        if let error = notification.userInfo?["error"] as? NSError {
            dismiss(animated: true, completion: nil)
            alert("Login error!", message: error.localizedDescription)
        }

    }

}
