//
//  TagViewExtension.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/21.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import Foundation
import UIKit

extension TagView {
    @objc func didTouchTagButton (_ sender: UIButton) {
        dataSource?.didTouchTagButton(sender)
    }
    
    @objc func deleteTag(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let button = sender.view as! UIButton
            delegate?.didLongPressTagButton(button)
        }
    }
}

extension TagView {
    //TagButtonの生成、レイアウトに関する処理
    func viewReset () {
        //前のボタンが残っていた場合削除する
        if self.subviews.count > 0 {
            self.subviews.forEach { (button) in
                button.removeFromSuperview()
            }
        } else {
            return
        }
    }
    //ボタンを一個作る
    func makeATagButton(tag: String) {
        let button = UIButton(type: .custom)
        button.backgroundColor = .pink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTouchTagButton(_:)), for: .touchUpInside)
        
        let longPressRecognizer = UILongPressGestureRecognizer()
        longPressRecognizer.addTarget(self, action: #selector(deleteTag(_:)))
        button.addGestureRecognizer(longPressRecognizer)
        button.tag = tagButtontag
        
        button.setTitle(tag, for: .normal)
        button.sizeToFit()
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        button.layer.cornerRadius = 5
        self.addSubview(button)
        
        let taglayoutConstraint = TagLayoutConstraints(button: button, parentView: self)
        
        self.tagLayoutConstraintsArray.append(taglayoutConstraint)
        self.tagButtontag += 1
        self.tagButtonArray.append(button)
    }
    
    //ボタンのConstraintの設定
    func setHeightConstraint(buttonHeight: CGFloat) {
        //tagLayoutConstraintsArrayの最後の要素のHeightを設定する
        guard let lastConstraint = tagLayoutConstraintsArray.last else {
            return
        }
        lastConstraint.updateHeightConstraint(height: buttonHeight)
    }
    
    func setAllButton(rightMargin: CGFloat, topMargin: CGFloat) {
        var previousWidth: CGFloat = 0
        var previousHeight: CGFloat = 0
        var times: Int = 0
        
        tagButtonArray.forEach { (button) in
            let tagLayoutConstraints = tagLayoutConstraintsArray[times]
            let buttonWidth = tagLayoutConstraints.widthAnchor.constant
            let buttonHeight = tagLayoutConstraints.heightAnchor.constant
            
            if previousWidth + buttonWidth < self.frame.width {
                //改行されない時の処理
                tagLayoutConstraints.updateLeadingAndTopAnchorConstant(leadingConstant: previousWidth, topConstant: previousHeight)
                previousWidth += buttonWidth + rightMargin
                times += 1
                
            } else {
                //改行された時の処理
                previousWidth = 0
                previousHeight += buttonHeight + topMargin
                tagLayoutConstraints.updateLeadingAndTopAnchorConstant(leadingConstant: previousWidth, topConstant: previousHeight)
                times += 1
                previousWidth += buttonWidth + rightMargin
            }
            
        }
    }


}

extension TagView {
    //Cell表示の際に使う
    func createTag(tagArray: [String], tagLayout: (CGFloat, CGFloat)) {
        print(#function)
        viewReset()
        guard tagArray.isEmpty == false else {
            return
        }
        let topMargin = tagLayout.0 / 3
        let leadingMargin = tagLayout.1

        tagArray.forEach { (tag) in
            self.makeATagButton(tag: tag)
            self.setHeightConstraint(buttonHeight: tagLayout.0)
        }
        setAllButton(rightMargin: leadingMargin, topMargin: topMargin)
    }
}

extension TagView {
    //CreateTweetViewの時に使う
    //ボタンを作成し、レイアウト後にまだボタンをつくれるかBoolで返す
    func setTagforCreate(tag: String, completion: @escaping (Bool) -> ()) {
        //CreteVCではTag Buttonの高さをTagViewの高さを基準に求める
        let tagHeightforCreate: CGFloat = self.frame.height / 4.0
        makeATagButton(tag: tag)
        setHeightConstraint(buttonHeight: tagHeightforCreate)
        tagButtonLayout(from: self.tagButtonArray.count)
        let button = tagButtonArray[tagButtonArray.count - 1]
        let fontSize = UIFont.systemFont(ofSize: 18)
        button.titleLabel?.font = fontSize
        let canMakeNewTag: Bool = checkCanMakeNewTag()
        completion(canMakeNewTag)
    }
    
    func settingTag(tag: String, completion: @escaping (Bool) -> ()) {
        makeATagButton(tag: tag)
        tagButtonLayout(from: self.tagButtonArray.count)
        let canMakeNewTag: Bool = checkCanMakeNewTag()
        completion(canMakeNewTag)
    }
    
    //削除されたボタンより後ろに配置されているボタンをレイアウトしなおす
    //tagNumber番目のボタンからレイアウトを開始する。
    func tagButtonLayout(from tagNumber: Int) {
        var previousWidth: CGFloat = 0
        var previousHeight: CGFloat = 0
        
        //tagNumber番目が最後のボタンだったら削除するだけで良いので何もしない
        //削除した結果ボタンが残らない場合も何もしない
        if tagNumber - 1 == tagButtonArray.count {
            return
        }
        //最初のボタン以外が削除された場合は前に残っているボタンのレイアウトを考慮する。
        //削除されたボタンが先頭のボタンだったら、previousWidth&Heightは0のままで良い。
        if tagNumber != 1 {
            let previousTagConstraint = tagLayoutConstraintsArray[tagNumber - 2]
            previousWidth += previousTagConstraint.leadingAnchor.constant + previousTagConstraint.widthAnchor.constant + tagButtonHeightLeading!.1
            previousHeight += previousTagConstraint.topAnchor.constant
        }
        
        for times in tagNumber...tagButtonArray.count {
            let tagLayoutConstraint = tagLayoutConstraintsArray[times - 1]
            if previousWidth + tagLayoutConstraint.widthAnchor.constant < self.frame.width {
                //改行が必要ない場合
                tagLayoutConstraint.updateLeadingAndTopAnchorConstant(leadingConstant: previousWidth, topConstant: previousHeight)
                previousWidth += tagLayoutConstraint.widthAnchor.constant + tagButtonHeightLeading!.1
            } else {
                //改行された場合
                previousWidth  = 0
                previousHeight += tagLayoutConstraint.heightAnchor.constant + tagLayoutConstraint.heightAnchor.constant / 2
                tagLayoutConstraint.updateLeadingAndTopAnchorConstant(leadingConstant: previousWidth, topConstant: previousHeight)
                previousWidth += tagLayoutConstraint.widthAnchor.constant + tagButtonHeightLeading!.1
            }
        }
    }
    
    //TagButtonが何行作られたか返す
    func tagViewType() -> Int {
        if tagButtonArray.count == 0 {
            return 0
        }
        
        let tagButtonHeight: CGFloat = tagLayoutConstraintsArray[0].heightAnchor.constant
        let tagMargin: CGFloat = tagButtonHeight / 2.0
        
        let secondStep: CGFloat = tagButtonHeight + tagMargin
        
        let lastLayoutConstraint = tagLayoutConstraintsArray[tagLayoutConstraintsArray.count - 1]
        let lastHeight: CGFloat = lastLayoutConstraint.topAnchor.constant
        
        if lastHeight == 0 {
            return 1
        } else if secondStep - 3 ... secondStep + 3 ~= lastHeight {
            //＝＝にならないかもしれないから、誤差も認めるv
            return 2
        } else  {
            return 3
        }
    }
    
    //まだTagButtonを作ることができるか返す
    func checkCanMakeNewTag() -> Bool {
        let lastTag = tagButtonArray[tagButtonArray.count - 1]
        let lastConstraint = tagLayoutConstraintsArray[tagLayoutConstraintsArray.count - 1]
        
        let lastHeight: CGFloat = lastConstraint.topAnchor.constant
        
        let buttonHeight: CGFloat = lastConstraint.heightAnchor.constant
        let topMargin: CGFloat = buttonHeight / 2
        let limits: CGFloat = buttonHeight * 3 + topMargin * 2
        
        if lastHeight > limits {
            //最後に作られたTagは消さないといけない
            lastTag.removeFromSuperview()
            tagButtonArray.removeLast()
            tagButtontag += -1
            tagLayoutConstraintsArray.removeLast()
            return false
        } else {
            return true
        }
    }
    
    //TagButtonが削除された後、ボタンのtagの数値を直す
    func tagNumberAdjust(from tagNumber: Int) {
        guard tagNumber != tagButtonArray.count + 1 else {
            self.tagButtontag += -1
            return
        }
        
        let arrayNumber: Int = tagNumber - 1
        let arrayCount: Int = tagButtonArray.count - 1
        let tagArray = tagButtonArray[arrayNumber...arrayCount]
        let adjustTagArray = tagArray.map { (button) -> UIButton in
            let newTag = button.tag - 1
            button.tag = newTag
            return button
        }
        tagButtonArray.replaceSubrange(arrayNumber...arrayCount, with: adjustTagArray)
    }
}


extension TagView {
    //tag検索画面専用のレイアウト
    func setTagSuggestion(tagArray: [String]) {
        tagArray.forEach { (tag) in
            makeATagButton(tag: tag)
        }
        setHeaderButton()
        tagButtonArray.forEach { (button) in
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
        
        let tagHeight: CGFloat = self.frame.height / 15.0
        let space: CGFloat = self.frame.height - (tagHeight * CGFloat(tagArray.count))
        let topSpace = space / CGFloat(tagArray.count)
        let tagWidth: CGFloat = self.frame.width / 2.0
        var previousHeight: CGFloat = 0
        print("suggestion = \(tagArray.count)")

       tagLayoutConstraintsArray.forEach { (constraint) in
            constraint.updateHeightConstraint(height: tagHeight)
            constraint.updateWidthConstraint(width: tagWidth)
            constraint.leadingAndTopConstraintDeactivate()
            constraint.updateTopConstraint(topConstraint: previousHeight)
            previousHeight += tagHeight + topSpace
        }
    }
    
    func setHeaderButton() {
        let headerButton: UIButton = UIButton()
        headerButton.setTitle("おすすめのタグ", for: .normal)
        headerButton.backgroundColor = .pink
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.sizeToFit()
        headerButton.layer.cornerRadius = 5
        self.addSubview(headerButton)
        let taglayoutConstraint = TagLayoutConstraints(button: headerButton, parentView: self)
         
        self.tagLayoutConstraintsArray.insert(taglayoutConstraint, at: 0)
        self.tagButtontag += 1
        self.tagButtonArray.insert(headerButton, at: 0)
        
    }
}

