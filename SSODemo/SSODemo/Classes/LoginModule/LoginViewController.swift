//
//  LoginViewController.swift
//  SSODemo
//
//  Created by wfh on 18/12/18.
//  Copyright © 2018 Harsha. All rights reserved.
//

import UIKit
import GoogleSignIn
import Lottie

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            backgroundView.backgroundColor = UIColor.lightText
        }
    }
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.text = "Please Login with your Google Account"
            userNameLabel.backgroundColor = UIColor.white
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signInSilently()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print(err)
        }
        else {
            let lottieLoginAnimationView = LOTAnimationView(name: "preloader")
            lottieLoginAnimationView.frame = CGRect(x: 0.0, y: 0.0, width: 350.0, height: 200.0)
            lottieLoginAnimationView.contentMode = .scaleAspectFit
            lottieLoginAnimationView.isHidden = false
            animationView.addSubview(lottieLoginAnimationView)
            lottieLoginAnimationView.animationSpeed = 1.5
            lottieLoginAnimationView.play { (false) in
                lottieLoginAnimationView.stop()
                lottieLoginAnimationView.isHidden = true
                let storyboard: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                if let vc: DashboardViewController = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController {
                    vc.givenName = user.profile.givenName
                    vc.familyName = user.profile.familyName
                    if user.profile.hasImage {
                        let profileImageURL = user.profile.imageURL(withDimension: 200)
                        vc.profileAvatarImageURL = profileImageURL
                    }
                    let navigationVC = UINavigationController(rootViewController: vc)
                    self.present(navigationVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    deinit {
        NSLog("Login View Controller: Deinit")
    }
}

