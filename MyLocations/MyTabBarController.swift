//
//  MyTabBarController.swift
//  MyLocations
//
//  Created by Wing LeungCHOI on 16/8/15.
//  Copyright (c) 2015 WingLeung CHOI. All rights reserved.
//

import UIKit
class MyTabController: UITabBarController{
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return nil
    }
}
