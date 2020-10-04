//
//  UsersViewController.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/11/15.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Followを表示するか、Followerを表示するか受け取る
    var path: String!
    var userId: String!
    
    var firebaseModel: FirebaseModel!

    var tableView: UITableView!
    var usersArray: [UserInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseModel = FirebaseModel()
        viewInit()
        //userのデータを取ってくる処理
        firebaseModel.setUsersView(path: path, userId: userId) { user in
            self.usersArray.append(user)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルがタッチされた時の処理
        let item = usersArray[indexPath.row]
        let userName = item.userName
        let userId = item.userId
        
        let profilePageVC = ProfilePageViewController()
        profilePageVC.userId = userId
        profilePageVC.userName = userName
        
        self.navigationController?.pushViewController(profilePageVC, animated: true)
    }

 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "UserCell")
        cell.backgroundColor = nil
        let item = usersArray[indexPath.row]
        cell.imageView?.image = item.userImage
        cell.textLabel?.text = item.userName
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
  
    
    func viewInit () {
        tableView = UITableView()
        tableView.backgroundColor = .darkPurple
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(tableView)
    }

}
