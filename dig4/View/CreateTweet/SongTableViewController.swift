//
//  SongTableViewController.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/08/28.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import UIKit

class SongTableViewController: UITableViewController {
    let itunesApi: iTunesApiModel = iTunesApiModel()
    var searchWord: String!
    var searchResultArray: [SearchResult] = []
    var postDismissAction: ( () -> Void)?
    
    var dispatchQueue: DispatchQueue?
    var dispatchQueue_Main: DispatchQueue = DispatchQueue.main

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkPurple
        tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResultArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = nil
        let item = searchResultArray[indexPath.row]
        let imageUrl = URL(string: item.artistImageUrl)
        
        cell.textLabel?.text = item.artistName
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.text = item.artistSong
        cell.detailTextLabel?.textColor = .white
        cell.imageView?.sd_setImage(with: imageUrl, placeholderImage: UIImage.gif(asset: "loading"), options: .retryFailed, completed: nil)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = searchResultArray[indexPath.row]
        let navigationController = self.presentingViewController as! UINavigationController
        let nvCount = navigationController.viewControllers.count
        let pageview = navigationController.viewControllers[nvCount - 1] as! TabBarViewController
        let tweetNavi = pageview.viewControllers![0] as! UINavigationController
        let createVC = tweetNavi.topViewController as! CreateTweetViewController
        
        createVC.didSelectItem = item
        self.dismiss(animated: true) {
            self.postDismissAction!()
        }
    }




}
