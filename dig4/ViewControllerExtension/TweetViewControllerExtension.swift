//
//  TweetViewControllerExtension.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/21.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import Foundation
import AVFoundation
import Firebase
import FirebaseUI

extension TweetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell") as! TweetTableViewCell
        cell.selectionStyle = .none
        //buttonにUserPageに行くのに必要な情報を送る
        //cell.delegate = self
        cell.userView.delegate = self
        cell.artistView.delegate = self
        cell.tagView.dataSource = self
        cell.favoritesView.delegate = self
        
        let item = tweetArray[indexPath.row]
        cell.setCell(tweet: item, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellSubviewWidth: CGFloat = UIScreen.main.bounds.width * 0.90
        let userViewHeight: CGFloat = cellSubviewWidth * 0.10
        let artistViewHeight: CGFloat = cellSubviewWidth * 0.15
        let tagButtonHeight: CGFloat = cellSubviewWidth * 0.75 * 0.05
        let favoritesViewHeight: CGFloat = cellSubviewWidth * 0.05
        let bottomMargin: CGFloat = 10
        let baseViewHeight: CGFloat = userViewHeight + artistViewHeight + favoritesViewHeight + bottomMargin
        let tagtype: Int = tweetArray[indexPath.row].tagType
        
        
        switch tagtype {
        case 0:
            return baseViewHeight
        case 1:
            return baseViewHeight + tagButtonHeight
        case 2:
            return baseViewHeight + tagButtonHeight * 2 + 5
        case 3:
            return baseViewHeight + tagButtonHeight * 3 + 10
        default:
            return 0
        }
    }
    
    @objc func refreshTweet() {
        firebaseModel.getNewTweet(path: path, child: child!, startAt: newestTimeStamp) { (tweets) in
            guard let afterTweets = tweets else {
                self.refreshControl.endRefreshing()
                return
            }
            let oldTweets = self.tweetArray
            self.tweetArray = afterTweets + oldTweets
            let newTime = self.tweetArray[0].timeStamp
            let oldTime = self.tweetArray.last?.timeStamp
            self.oldestTimeStamp = oldTime
            self.newestTimeStamp = newTime
            self.tableView.reloadData()
            
            if self.path == "TimeLine" {
                self.setNewestTimeStamp(newTime: newTime)
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tableOffsetY = tableView.contentOffset.y
        let tableFrameHeight = tableView.frame.height
        let tableContentHeight = { () -> CGFloat in
            if self.tableView.contentSize.height + 200 < tableFrameHeight {
                return tableFrameHeight + 100
            } else {
                return self.tableView.contentSize.height + 200
            }
        }
        let contentHeight = tableContentHeight()
        if tableOffsetY + tableFrameHeight > contentHeight && tableView.isDragging && flag == true {
            flag = false
            activityIndicator.startAnimating()
            tableView.tableFooterView?.isHidden = false
            self.view.isUserInteractionEnabled = false
            firebaseModel.getOldTweet(path: path, child: child!, endAt: oldestTimeStamp) { (tweets) in
                guard let afterTweets = tweets else {
                    self.activityIndicator.stopAnimating()
                    self.flag = true
                    self.view.isUserInteractionEnabled = true
                    return
                }
                self.tweetArray += afterTweets
                let oldTime = self.tweetArray.last?.timeStamp
                let newTime = self.tweetArray[0].timeStamp
                self.newestTimeStamp = newTime
                self.oldestTimeStamp = oldTime
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.tableView.tableFooterView?.isHidden = true
                self.flag = true
                Thread.sleep(forTimeInterval: 0.70)
                self.view.isUserInteractionEnabled = true
            }
            
        }
    }
    
}

extension TweetViewController: HeaderViewDelegate, ArtistViewDelegate, TagViewDataSource, FooterViewDelegate {
    
    func didTouchUserImage(userId: String, userName: String) {
        let profilePageVC = ProfilePageViewController()
        profilePageVC.userId = userId
        profilePageVC.userName = userName
        self.navigationController?.pushViewController(profilePageVC, animated: true)
    }
    
    func playMusic(previewUrl: URL) {
        if  player != nil {
            
            if player!.isPlaying {
                
                if currentUrl == previewUrl {
                    player?.pause()
                } else {
                    player = AVPlayer(url: previewUrl)
                    player?.play()
                    currentUrl = previewUrl
                }
                
            } else {
                if currentUrl == previewUrl {
                    player?.play()
                } else {
                    player = AVPlayer(url: previewUrl)
                    player?.play()
                    currentUrl = previewUrl
                }
            }
            
        } else {
            player = AVPlayer(url: previewUrl)
            player?.play()
            currentUrl = previewUrl
        }
    }
    
    func didTouchTagButton(_ sender: UIButton) {
        guard let tag = sender.titleLabel?.text else {
            return
        }
        
        if let currentViewController = self.navigationController?.visibleViewController as? TagSearchViewController {
            currentViewController.tag = tag
            currentViewController.didTouchSearchButton(word: tag)
        } else {
            let tagSearchViewController = TagSearchViewController()
            tagSearchViewController.tag = tag
            self.navigationController?.pushViewController(tagSearchViewController, animated: true)
        }
    }
    
    func didTouchFavoritesButton(cellIndexPath: IndexPath) {
        let tweet = tweetArray[cellIndexPath.row]
        let tweetDic = tweet.changeToDictioanary()
        if tweet.canAddFavorites == true {
            firebaseModel.addFavorites(tweetPath: tweet.tweetPath, tweet: tweetDic) {
                self.tweetArray[cellIndexPath.row].canAddFavorites = false
            }
        } else {
            firebaseModel.removeFavorites(tweetPath: tweet.tweetPath) {
                self.tweetArray[cellIndexPath.row].canAddFavorites = true
            }
            
        }
    }
}

extension TweetViewController {
    @objc func buttonDidTapped (_ sender: UIButton) {
        let create = CreateTweetViewController()
        create.postDismissAction = {
            self.firebaseModel.getNewTweet(path: self.path, child: self.child!, startAt: self.newestTimeStamp) { (tweets) in
                guard let afterTweets = tweets else {
                    return
                }
                let oldTweets = self.tweetArray
                self.tweetArray = afterTweets + oldTweets
                let newTime = self.tweetArray[0].timeStamp
                let oldTime = self.tweetArray.last?.timeStamp
                self.oldestTimeStamp = oldTime
                self.newestTimeStamp = newTime
                self.tableView.reloadData()
                
                if self.path == "TimeLine" {
                    self.setNewestTimeStamp(newTime: newTime)
                }
            }
        }
        self.navigationController?.pushViewController(create, animated: true)
    }
}
