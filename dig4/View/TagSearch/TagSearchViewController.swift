//
//  TagSearchViewController.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/11/21.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import Firebase

class TagSearchViewController: UIViewController{
    var tag: String?
    
    var tagSerchBar: SearchBar!
    var tagTweetViewController: TweetViewController!
    var tagSuggestionView: TagView!
    
    var reloadTagButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewInit()
        setTagSuggestion()

        if tag != nil {
            tagSuggestionView.isHidden = true
            reloadTagButton.isHidden = true
        }

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tagSerchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        tagSerchBar.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        tagSerchBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tagSerchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        let tagSearchView = tagTweetViewController.view!
        tagSearchView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        tagSearchView.topAnchor.constraint(equalTo: tagSerchBar.bottomAnchor).isActive = true
        tagSearchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tagSearchView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
        
        tagSuggestionView.widthAnchor.constraint(equalTo: tagSearchView.widthAnchor).isActive = true
        tagSuggestionView.topAnchor.constraint(equalTo: tagSearchView.topAnchor).isActive = true
        tagSuggestionView.bottomAnchor.constraint(equalTo: tagSearchView.bottomAnchor).isActive = true
        tagSuggestionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        reloadTagButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.08).isActive = true
        reloadTagButton.heightAnchor.constraint(equalTo: reloadTagButton.widthAnchor, multiplier: 1.0).isActive = true
        reloadTagButton.topAnchor.constraint(equalTo: tagSerchBar.bottomAnchor, constant: 20)
        .isActive = true
        reloadTagButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
    }
    
    func viewInit() {
        tagSerchBar = SearchBar()
        tagSerchBar.translatesAutoresizingMaskIntoConstraints = false
        tagSerchBar.delegate = self
        
        tagTweetViewController = TweetViewController(kindOfTweet: "Tag", child: tag)
        tagTweetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        tagSuggestionView = TagView()
        tagSuggestionView.dataSource = self
        tagSuggestionView.translatesAutoresizingMaskIntoConstraints = false
        
        reloadTagButton = UIButton()
        reloadTagButton.setImage(UIImage(named: "reload"), for: .normal)
        reloadTagButton.addTarget(self, action: #selector(didTouchReloadTagButton(_:)), for: .touchUpInside)
        reloadTagButton.translatesAutoresizingMaskIntoConstraints = false
        
        let barFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.1)
        let tweetVCFrame = CGRect(x: 0, y: barFrame.height, width: self.view.frame.width, height: self.view.frame.height - barFrame.height)
        tagSuggestionView.frame = tweetVCFrame
        
        
        self.view.addSubview(tagSerchBar)
        self.view.addSubview(tagTweetViewController.view)
        self.addChild(tagTweetViewController)
        tagTweetViewController.didMove(toParent: self)
        tagTweetViewController.view.addSubview(tagSuggestionView)
        tagTweetViewController.view.addSubview(reloadTagButton)
    }
    
}
