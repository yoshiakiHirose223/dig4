//
//  TagSearchViewControlleExtension.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/21.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import Foundation
import UIKit

extension TagSearchViewController: TagSearchDelegate, UITextFieldDelegate, TagViewDataSource {
  
    func textFieldisBlank() {
        tagSuggestionView.isHidden = false
        reloadTagButton.isHidden = false
        tagTweetViewController.tweetArray.removeAll()
        tagTweetViewController.tableView.reloadData()
    }
    
    @objc func didTouchReloadTagButton(_ sender: UIButton) {
        tagSuggestionView.subviews.forEach { (tagButton) in
            tagButton.removeFromSuperview()
        }
        tagSuggestionView.tagButtonArray = []
        tagSuggestionView.tagLayoutConstraintsArray = []
        tagSuggestionView.tagButtontag = 0
        
        setTagSuggestion()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tagSerchBar.searchTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func didTouchSearchButton(word: String) {
        tagSuggestionView.isHidden = true
        reloadTagButton.isHidden = true
        tagTweetViewController.firebaseModel.getLatestTweet(path: "Tag", child: word) { (tweets) in
            guard let afterTweets = tweets else {
                return
            }
            self.tagTweetViewController.child = word
            self.tagTweetViewController.tweetArray.removeAll()
            self.tagTweetViewController.tweetArray = afterTweets
            self.tagTweetViewController.newestTimeStamp = afterTweets[0].timeStamp
            self.tagTweetViewController.oldestTimeStamp = afterTweets.last!.timeStamp
            self.tagTweetViewController.tableView.reloadData()
        }
    }
    
    func didTouchTagButton(_ sender: UIButton) {
        let word = sender.titleLabel?.text
        self.tagSerchBar.searchTextField.text = word
        didTouchSearchButton(word: word!)
    }
    
    func setTagSuggestion() {
    FirebaseModel().getTagSuggestion { (tagArray) in
        self.tagSuggestionView.setTagSuggestion(tagArray: tagArray)
    }
}
}
