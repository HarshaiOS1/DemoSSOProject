//
//  ShareActivityViewController.swift
//  SSODemo
//
//  Created by wfh on 08/01/19.
//  Copyright © 2019 Harsha. All rights reserved.
//

import Foundation
import UIKit

class ShareActivityViewController: UIViewController {
    @IBOutlet weak var shareDownloadButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "ImageToShare")
    }
    
    func shareData() {
        let image = UIImage(named: "ImageToShare")
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [image as Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func shareDownloadButtonAction(_ sender: Any) {
        shareData()
    }
    
    deinit {
        NSLog("ShareActivityViewController: Dinit")
    }
}
