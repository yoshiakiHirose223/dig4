//
//  TabBarViewControllerExtension.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/21.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import Foundation
import UIKit

extension TabBarViewController {
    func setViewControllers() {
        tweetViewController = TweetViewController(kindOfTweet: "TimeLine", child: userId)
        let tweetNavigationController = UINavigationController(rootViewController: tweetViewController)
        
        tagSearchViewController = TagSearchViewController()
        let tagSearchNavigationController = UINavigationController(rootViewController: tagSearchViewController)
        
        profileViewController = ProfilePageViewController()
        profileViewController.userId = self.userId
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        tweetViewController.tabBarItem = .init(title: "TimeLine", image: UIImage(named: "TimeLine"), tag: 1)
        
        tagSearchViewController.tabBarItem = .init(tabBarSystemItem: .search, tag: 2)
        
        profileViewController.tabBarItem = .init(title: "MyPage", image: UIImage(named: "MyPage"), tag: 3)
        
        let tabs: [UIViewController] = [tweetNavigationController, tagSearchNavigationController, profileNavigationController]
        
        setViewControllers(tabs, animated: false)
    }
}
