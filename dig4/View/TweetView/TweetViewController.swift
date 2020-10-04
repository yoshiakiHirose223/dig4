//
//  HomeViewController.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/11/03.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseUI

class TweetViewController: UIViewController, UITextFieldDelegate {

    var firebaseModel: FirebaseModel!
    
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var tweetButton: UIButton!
    var tweetArray: [CellInfo] = []
    var newestTimeStamp: Int?
    var oldestTimeStamp: Int?
    
    var flag: Bool = true
    
    var player: AVPlayer?
    var currentUrl: URL?

    var path: String!
    var child: String?
    var activityIndicator = UIActivityIndicatorView(style: .gray)
    
    init(kindOfTweet: String, child: String?) {
        self.path = kindOfTweet
        self.child = child
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       /* self.path = aDecoder.decodeObject(forKey: "path") as? String
        self.child = aDecoder.decodeObject(forKey: "child") as? String
        super.init(coder: aDecoder)*/
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)

    }
      /*
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(path, forKey: "path")
        aCoder.encode(child, forKey: "child")
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        coder.encode(path, forKey: "path")
        coder.encode(child, forKey: "child")
    } 
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firebaseModel = FirebaseModel()
        viewInit()
        guard let path = self.path else {
            return
        }
        guard let child = self.child else {
            return
        }
        if path == "TimeLine" {
            tweetButton = UIButton()
            tweetButton.translatesAutoresizingMaskIntoConstraints = false
            tweetButton.addTarget(self, action: #selector(buttonDidTapped(_:)), for: UIControl.Event.touchUpInside)
            tweetButton.setImage(UIImage(named: "create"), for: .normal)
            self.view.addSubview(tweetButton)
        }
        
        firebaseModel.getNewTweet(path: path, child: child) { (tweetArray) in
            guard let afterTweetArray = tweetArray else {
                return
            }
            self.tweetArray += afterTweetArray
            let newTime = self.tweetArray[0].timeStamp
            let oldTime = self.tweetArray.last!.timeStamp
            self.newestTimeStamp = newTime
            self.oldestTimeStamp = oldTime
            self.tableView.reloadData()
        }

}
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print(#function)
        viewLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func viewInit () {
        //viewの生成
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        tableView.backgroundColor = .darkPurple
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTweet), for: .valueChanged)
    
        //viewの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: "ArtistCell")
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        tableView.tableFooterView = activityIndicator

        //viewの追加
        self.view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        
    }
    
    func viewLayout () {
        tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.0).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //ツイートボタンのレイアウト
        guard tweetButton != nil else {
            return
        }
        guard let tabBar = self.tabBarController?.tabBar else {
            return
        }
        
        tweetButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        tweetButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tweetButton.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -10).isActive = true
        tweetButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
    }
    
    func setNewestTimeStamp(newTime: Int?) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(newTime, forKey: "NewestTimeStamp")
        userDefault.synchronize()
    }

    
    func getNewestTimeStamp() -> Int? {
        let userDefault = UserDefaults.standard
        let value = userDefault.integer(forKey: "NewestTimeStamp")
        guard value != 0 else {
            return nil
        }
        return value
    }
    
}
