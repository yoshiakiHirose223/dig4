//
//  TabBarViewController.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/08/30.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    var userId: String!
    var tweetViewController: TweetViewController!
    var tagSearchViewController: TagSearchViewController!
    var profileViewController: ProfilePageViewController!
    
    init(userID: String) {
        userId = userID
        super.init(nibName: nil, bundle: nil)
        self.tabBar.barTintColor = .lightPurple

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
