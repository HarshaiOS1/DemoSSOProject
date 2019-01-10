//
//  File.swift
//  SSODemo
//
//  Created by wfh on 07/01/19.
//  Copyright © 2019 Harsha. All rights reserved.
//

import Foundation

class DashboardViewControllerViewModel: NSObject {
    
    func dummyModelData() -> [UIComponentsModel] {
        
        let uiCompomnent1 = UIComponentsModel.init(componentName: "Core Data With Image Picker")
        let uiCompomnent2 = UIComponentsModel.init(componentName: "Carthage with Lottie Animation")
        let uiCompomnent3 = UIComponentsModel.init(componentName: "Share Activity Controlelr")
        return [uiCompomnent1, uiCompomnent2, uiCompomnent3 ]
    }
    
    
}
