//
//  ViewController.swift
//  LineSDKStarterSwift
//
//  Copyright (c) 2015 Line corp. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    private let adapter = LineAdapter.adapterWithConfigFile()

    override func viewDidLoad() {
        super.viewDidLoad()
        startObserveLineAdapterNotification()
    }

    func startObserveLineAdapterNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "authorizationDidChange:",
            name: LineAdapterAuthorizationDidChangeNotification, object: nil)
    }

    @IBAction func loginWithLine(sender: AnyObject) {
        if adapter.authorized {
            alert("Already authorized", message: "")
            return
        }

        if !adapter.canAuthorizeUsingLineApp {
            alert("LINE is not installed", message: "")
            return
        }
        adapter.authorize()
    }

    @IBAction func loginInApp(sender: AnyObject) {
        if adapter.authorized {
            alert("Already authorized", message: "")
            return
        }

        let viewController = LineAdapterWebViewController(adapter: adapter, withWebViewOrientation: kOrientationAll)
        viewController.navigationItem.leftBarButtonItem = LineAdapterNavigationController.barButtonItemWithTitle("Cancel", target: self, action: "cancel:")
        let navigationController = LineAdapterNavigationController(rootViewController: viewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }

    @IBAction func tryApi(sender: AnyObject) {
        if !adapter.authorized {
            alert("Login first!", message: "")
            return
        }

        adapter.getLineApiClient().getMyProfileWithResultBlock {[unowned self] (profile, error) -> Void in
            if error != nil {
                self.alert("Error occured!", message: error.localizedDescription)
                return
            }

            let displayName = profile["displayName"] as! String
            self.alert("Your name is \(displayName)", message: "")
        }
    }

    @IBAction func logout(sender: AnyObject) {
        adapter.unauthorize()
        alert("Logged out", message: "")
    }

    private func alert(title: String, message: String) {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }

}

extension ViewController {

    func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func authorizationDidChange(notification: NSNotification) {
        let adapter = notification.object as! LineAdapter

        if adapter.authorized {
            alert("Login success!", message: "")
            dismissViewControllerAnimated(true, completion: nil)
            return
        }

        if let error = notification.userInfo?["error"] as? NSError {
            alert("Login error!", message: error.localizedDescription)
            dismissViewControllerAnimated(true, completion: nil)
        }

    }

}

