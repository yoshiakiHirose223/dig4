//
//  ProfilePageViewController.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/11/14.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class ProfilePageViewController: UIViewController {
    var profileView: ProfileView!
    var tweetViewButton: UIButton!
    var favoritesViewButton: UIButton!
    var containerView: UIView!
    var pageViewController: UIPageViewController!
    
    var firebaseModel: FirebaseModel!
    var userId: String!
    var userName: String!
    var myUser: User!  
    var viewArray: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseModel = FirebaseModel()
        myUser = Auth.auth().currentUser
        self.view.backgroundColor = .darkPurple
        viewInit()
 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        viewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
   
    func viewLayout () {
        let myView = self.view.frame
        let safeArea = self.view.safeAreaInsets
        
        let profileViewWidth = myView.width
        let profileViewHeight = myView.height * 0.15
        
        let buttonsWidth = myView.width * 0.5
        let buttonsHeight = myView.height * 0.035
        
        profileView.widthAnchor.constraint(equalToConstant: profileViewWidth).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: profileViewHeight).isActive = true
        profileView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeArea.top).isActive = true
        profileView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        tweetViewButton.widthAnchor.constraint(equalToConstant: buttonsWidth).isActive = true
        tweetViewButton.heightAnchor.constraint(equalToConstant: buttonsHeight).isActive = true
        tweetViewButton.topAnchor.constraint(equalTo: profileView.bottomAnchor).isActive = true
        tweetViewButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        favoritesViewButton.widthAnchor.constraint(equalToConstant: buttonsWidth).isActive = true
        favoritesViewButton.heightAnchor.constraint(equalToConstant: buttonsHeight).isActive = true
        favoritesViewButton.topAnchor.constraint(equalTo: profileView.bottomAnchor).isActive = true
        favoritesViewButton.leadingAnchor.constraint(equalTo: tweetViewButton.trailingAnchor).isActive = true

        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: tweetViewButton.bottomAnchor, constant: 10).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

        pageViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        pageViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    func viewInit () {
        setViewControllers()
        profileView = ProfileView()
        profileView.delegate = self
        setProfileView()
        
        tweetViewButton = UIButton(type: .system)
        tweetViewButton.setTitle("Tweet", for: .normal)
        tweetViewButton.setTitleColor(.white, for: .normal)
        tweetViewButton.addTarget(self, action: #selector(didTouchTweetViewButton(_:)), for: .touchUpInside)
        tweetViewButton.backgroundColor = .pink
        tweetViewButton.layer.borderWidth = 3.0
        tweetViewButton.layer.borderColor = UIColor.buttonLayerCgColor
        
        favoritesViewButton = UIButton(type: .system)
        favoritesViewButton.setTitle("Favorites", for: .normal)
        favoritesViewButton.setTitleColor(.white, for: .normal)
        favoritesViewButton.addTarget(self, action: #selector(didTouchFavoritesViewButton(_:)), for: .touchUpInside)
        favoritesViewButton.backgroundColor = .darkPink
        favoritesViewButton.layer.borderWidth = 3.0
        favoritesViewButton.layer.borderColor = UIColor.buttonLayerCgColor
        
        containerView = UIView()
        containerView.backgroundColor = .blue
        
        
        pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.setViewControllers([viewArray[0]], direction: .forward, animated: true, completion: nil)
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        tweetViewButton.translatesAutoresizingMaskIntoConstraints = false
        favoritesViewButton.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(profileView)
        self.view.addSubview(favoritesViewButton)
        self.view.addSubview(tweetViewButton)
        self.view.addSubview(containerView)
        self.addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
    }
    

}
