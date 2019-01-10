//
//  CarthageWithLottieAnimationViewController.swift
//  SSODemo
//
//  Created by wfh on 08/01/19.
//  Copyright © 2019 Harsha. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class CarthageWithLottieAnimationViewController: UIViewController {
    @IBOutlet weak var animationBackGroundView: UIView!
    let animationView = LOTAnimationView(name: "airplane")
    var backButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView() {
        animationView.frame = CGRect(x:0.0, y:0.0, width: 335.0, height: 400.0)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1.0
        animationView.loopAnimation = true
        self.animationBackGroundView.addSubview(animationView)
        animationView.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        animationView.stop()
        super.viewWillDisappear(true)
    }
    
    deinit {
        NSLog("CarthageWithLottieAnimationViewController: Denit")
    }
}
