//
//  UIComponentsTableViewCell.swift
//  SSODemo
//
//  Created by wfh on 07/01/19.
//  Copyright © 2019 Harsha. All rights reserved.
//

import Foundation
import UIKit

class UIComponentsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
            titleLabel.textColor = UIColor.darkText
        }
    }
    
    @IBOutlet weak var backGroundView: UIView! {
        didSet {
            layer.cornerRadius = 1.0
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 1.0)
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: 3)
            layer.shadowOpacity = 0.2
            layer.shadowPath = shadowPath.cgPath
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
