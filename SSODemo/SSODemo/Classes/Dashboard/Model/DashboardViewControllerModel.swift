//
//  DashboardViewControllerModel.swift
//  SSODemo
//
//  Created by wfh on 07/01/19.
//  Copyright © 2019 Harsha. All rights reserved.
//

import Foundation

struct UIComponentsModel {
    var componentName: String?
}

struct cellID {
    static let UIComponentsTableViewCellID = "UIComponentsTableViewCell"
    
    enum cellTag: Int {
        case coredataWithImagePicker = 0
        case carthageWithLottieAnimation = 1
        case shareActivityControlelr = 2
    }
}
