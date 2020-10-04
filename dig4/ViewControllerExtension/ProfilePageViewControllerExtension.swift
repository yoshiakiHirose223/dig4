//
//  ProfilePageViewControllerExtension.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/21.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import Foundation
import UIKit

extension ProfilePageViewController {
    func setProfileView () {
        setProfiles()
        setFollowFollowerNumber()
    }
    
    func setProfiles() {
        firebaseModel.getUserProfile(userId: userId) { (profile) in
            let imageUrlString = profile["UserImageUrlString"] as! String
            let userName = profile["UserName"] as! String
            guard let url = URL(string: imageUrlString) else {
                return
            }
            self.profileView.userImageView.sd_setImage(with: url, completed: nil)
            self.profileView.userNameLabel.text = userName
            self.profileView.userNameLabel.textColor = .white
            
        }
        
        if myUser.uid != userId {
            firebaseModel.isFollowed(userId: userId) { (bool) in
                self.profileView.isFollowed = bool
                self.profileView.setFollowButton(followed: bool)
            }
        } else {
            profileView.followButton.isHidden = true
        }
        
    }
    
    func setFollowFollowerNumber() {
        
        firebaseModel.getNumberOfFollow(userId: userId) { (followNumber) in
            if let number = followNumber {
                self.profileView.followUsersButton.setCustomButton(text: "FOLLOW", number: number)
            } else {
                self.profileView.followUsersButton.setCustomButton(text: "FOLLOW", number: "0")
            }
        }
        
        firebaseModel.getNumberOfFollower(userId: userId) { (followersNumber) in
            if let number = followersNumber {
                self.profileView.followerUsersButton.setCustomButton(text: "FOLLOWER", number: number)
            } else {
                self.profileView.followerUsersButton.setCustomButton(text: "FOLLOWER", number: "0")
            }
        }
    }

    
    @objc func didTouchTweetViewButton (_ sender :UIButton) {
        pageViewController.setViewControllers([viewArray[0]], direction: .reverse, animated: true, completion: nil)
        tweetViewButton.backgroundColor = .pink
        favoritesViewButton.backgroundColor = .darkPink
        
    }
    
    @objc func didTouchFavoritesViewButton (_ sender: UIButton) {
        pageViewController.setViewControllers([viewArray[1]], direction: .forward, animated: true, completion: nil)
        favoritesViewButton.backgroundColor = .pink
        tweetViewButton.backgroundColor = .darkPink
        
    }
}

extension ProfilePageViewController: UIPageViewControllerDataSource {
    
    func setViewControllers() {
        let tweetViewController = TweetViewController(kindOfTweet: "MyTweet", child: userId)
        let favoritesTweetViewController = TweetViewController(kindOfTweet: "Favorites", child: userId)
        
        viewArray.append(tweetViewController)
        viewArray.append(favoritesTweetViewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == viewArray[0] {
            tweetViewButton.backgroundColor = .pink
            favoritesViewButton.backgroundColor = .darkPink
            return nil
        } else {
            tweetViewButton.backgroundColor = .pink
            favoritesViewButton.backgroundColor = .darkPink
            return viewArray[0]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == viewArray[1] {
            favoritesViewButton.backgroundColor = .pink
            tweetViewButton.backgroundColor = .darkPink
            return nil
        } else {
            favoritesViewButton.backgroundColor = .pink
            tweetViewButton.backgroundColor = .darkPink
            return viewArray[1]
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewArray.count
    }
}

extension ProfilePageViewController: ProfileViewDelegate {
    func goFollowFollowerPage(_ sender: UIButton) {
        let usersVC = UsersViewController()
        usersVC.userId = self.userId
        if sender.tag == 1 {
            let path = "Follow"
            usersVC.path = path
            self.navigationController?.pushViewController(usersVC, animated: true)
            
        } else {
            let path = "Follower"
            usersVC.path = path
            self.navigationController?.pushViewController(usersVC, animated: true)
            
        }
    }
    
    func didFollow(isFollowed: Bool) {
        if isFollowed == false {
            //false = フォローしていない
            profileView.followButton.isEnabled = false
            firebaseModel.follow(myUser: myUser, userId: userId, userName: userName) {
                self.profileView.isFollowed = true
                self.profileView.followButton.setTitle("フォロー中", for: .normal)
                self.profileView.setFollowButton(followed: true)
                self.profileView.followButton.isEnabled = true
            }
        } else {
            profileView.followButton.isEnabled = false
            firebaseModel.unFollow(myUser: myUser, userId: userId, userName: userName) {
                self.profileView.isFollowed = false
                self.profileView.followButton.setTitle("フォローする", for: .normal)
                self.profileView.setFollowButton(followed: false)
                self.profileView.followButton.isEnabled = true
            }
        }
    }
}
