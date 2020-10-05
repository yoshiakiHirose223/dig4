//
//  CreateTweetViewControllerExtension.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/25.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import UIKit

extension CreateTweetViewController: AlertViewProtocol {
    
    @objc func didTouchBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func didTapAddTagButton (_ sender: UIButton) {
        let alert = UIAlertController(title: "タグ付けしましょう", message: nil, preferredStyle: .alert)
        var tagTextField: UITextField = UITextField()
        alert.addTextField { (textField) in
            textField.placeholder = "15文字以内で入力してください"
            tagTextField = textField
        }
        alert.addAction(.init(title: "OK", style: .default, handler: { (_) in
            guard let tag = tagTextField.text?.trimmingCharacters(in: .whitespaces) else {
                return
            }
            guard tag.isEmpty == false else {
                return
            }
            let center = self.view.center
            if tag.count < 16 {
                self.tagView.settingTag(tag: tag, completion: { (canMakeNewTag) in
                    if canMakeNewTag == true {
                        self.tagArray.append(tag)
                    } else {
                        self.showAlert(text: "タグの数を減らしてください。", center: center)
                    }
                })
                
            } else {
                self.showAlert(text: "15文字以内で入力してください", center: center)
            }
            
        }))
        alert.addAction(.init(title: "CANCEL", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func didTapTweetButton (_ sender: UIButton) {
        //まず追加するデータを作る。
        //自分のユーザー情報取得
        let userId = firebaseModel.myUser.uid
        let userName = firebaseModel.myUser.displayName!
        let tweetPath = firebaseModel.ref.childByAutoId().key!
        guard let item = self.didSelectItem else {
            return
        }
        let tagType: Int = tagView.tagViewType()
        
        firebaseModel.getUserImageUrl(userId: userId) { (imageUrlString) in
            //ツイートを作成
            let tweet: [String: Any] = Dictionary().makeTweet(userName: userName, userId: userId, userImageUrlString: imageUrlString, artistImageUrlString: item.artistImageUrl, artistName: item.artistName, artistSong: item.artistSong, tag: self.tagArray, tagType: tagType, canAddFavorites: true, previewUrl: item.previewUrl, isStreamable: item.isStreamable, tweetPath: tweetPath)
            self.firebaseModel.upTweet(tweet: tweet, completion: {
            })
            self.postDismissAction!()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func reloadArtistView () {
        if let item = didSelectItem {
            artistImage.setArtistImage(imageUrlString: item.artistImageUrl, name: item.artistName, title: item.artistSong)
            tweetButton.isEnabled = true
            tweetButton.backgroundColor = UIColor(displayP3Red: 236 / 255, green: 64 / 255, blue: 122 / 255, alpha: 1.0)
        }
        
    }

}

extension CreateTweetViewController: TagSearchDelegate {
    func textFieldisBlank() {
        
    }
    

    func didTouchSearchButton(word: String) {
        iTunesApi.getArtistData(artistName: self.searchBar.searchTextField.text!) { (resultArray) in
            guard let afterResult = resultArray else {
                DispatchQueue.main.async {
                    let center = self.view.center
                    self.showAlert(text: "他のキーワードをお試しください。", center: center)
                }
                return
            }
            
            let songTableViewController = SongTableViewController()
            songTableViewController.searchResultArray = afterResult
            songTableViewController.modalPresentationStyle = .custom
            songTableViewController.transitioningDelegate = self
            songTableViewController.postDismissAction = { self.reloadArtistView() }
            self.present(songTableViewController, animated: true, completion: nil)
        }
    }
}

extension CreateTweetViewController: TagViewDelegate {
    func updateTagViewHeight(height: CGFloat) {
    }
    
    func didLongPressTagButton(_ sender: UIButton) {
        print(#function)
        let alert = UIAlertController(title: "削除しますか？", message: nil, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: { (_) in
            let tagNumber = sender.tag
            sender.removeFromSuperview()
            self.tagArray.remove(at: tagNumber - 1)
            self.tagView.tagButtonArray.remove(at: tagNumber - 1)
            self.tagView.tagLayoutConstraintsArray.remove(at: tagNumber - 1)
            self.tagView.tagButtonLayout(from: tagNumber)
            self.tagView.tagNumberAdjust(from: tagNumber)
            self.tagView.canMakeNewTag = true
            
        }))
        alert.addAction(.init(title: "CANCEL", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension CreateTweetViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.searchTextField.resignFirstResponder()
        return true
    }
}

extension CreateTweetViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationControler(presentedViewController: presented, presenting: presenting)
    }
}
