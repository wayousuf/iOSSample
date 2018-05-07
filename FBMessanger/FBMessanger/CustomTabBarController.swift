//
//  CustomTabBarController.swift
//  FBMessanger
//
//  Created by Waqas Yousuf on 5/7/18.
//  Copyright © 2018 Waqas Yousuf. All rights reserved.
//

import UIKit

class CustomTabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let friendController = FriendsController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: friendController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "recent")

        
        
        viewControllers = [recentMessagesNavController, createDummyNavController(title: "Calls", imageName: "calls"),
         createDummyNavController(title: "Groups", imageName: "groups"), createDummyNavController(title: "People", imageName: "people"),
         createDummyNavController(title: "Settings", imageName: "settings")]
    }
    
    private func createDummyNavController(title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
