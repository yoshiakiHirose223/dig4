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
        let buttonWidth: CGFloat = button.frame.width
        let buttonHeight: CGFloat = self.frame.width * 0.05
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        button.layer.cornerRadius = 5
        
        self.addSubview(button)
        
        let taglayoutConstraint = TagLayoutConstraints()
        taglayoutConstraint.makeSizeConstraint(tagButton: button, width: buttonWidth, height: buttonHeight)
        taglayoutConstraint.makeLeadingConstraint(tagButton: button, xAxisAnchor: self.leadingAnchor, constant: 0)
        taglayoutConstraint.makeTopConstraint(tagButton: button, yAxisAnchor: self.topAnchor, constant: 0)
        taglayoutConstraint.allConstraintsActivate()
        
        self.tagLayoutConstraintsArray.append(taglayoutConstraint)
        self.tagButtontag += 1
        self.tagButtonArray.append(button)
    }
    //配列内のボタンをまとめてレイアウト
    func allButtonsLayout() {
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
                previousWidth += buttonWidth + 10
                times += 1
                
            } else {
                //改行された時の処理
                previousWidth = 0
                previousHeight += buttonHeight + 5
                tagLayoutConstraints.updateLeadingAndTopAnchorConstant(leadingConstant: previousWidth, topConstant: previousHeight)
                times += 1
                previousWidth += buttonWidth + 10
            }
        }
    }

}

extension TagView {
    //Cell表示の際に使う
    func createTag(tagArray: [String]) {
        viewReset()
        guard tagArray.isEmpty == false else {
            self.delegate?.updateTagViewHeight(height: 0)
            return
        }
        tagArray.forEach { (tag) in
            self.makeATagButton(tag: tag)
        }
        allButtonsLayout()
        let lastLayoutConstraint: CGFloat = tagLayoutConstraintsArray[tagLayoutConstraintsArray.count - 1].topAnchor.constant
        
        let tagViewHeight: CGFloat = lastLayoutConstraint + self.frame.width * 0.05
        delegate?.updateTagViewHeight(height: tagViewHeight)
    }
}

extension TagView {
    //CreateTweetViewの時に使う
    //ボタンを作成し、レイアウト後にまだボタンをつくれるかBoolで返す
    func settingTag(tag: String, completion: @escaping (Bool) -> ()) {
        makeATagButton(tag: tag)
        tagButtonLayout(from: self.tagButtonArray.count)
        let canMakeNewTag: Bool = checkCanMakeNewTag()
        completion(canMakeNewTag)
    }
    
    //削除されたボタンより後ろに配置されているボタンをレイアウトしなおす
    func tagButtonLayout(from tagNumber: Int) {
        var previousWidth: CGFloat = 0
        var previousHeight: CGFloat = 0
        
        if tagNumber > tagButtonArray.count {
            return
        }
        
        if tagNumber != 1 {
            let previousTag = tagButtonArray[tagNumber - 2]
            previousWidth += previousTag.frame.maxX + 10
            previousHeight += previousTag.frame.minY
        }
        
        for times in tagNumber...tagButtonArray.count {
            let tag = tagButtonArray[times - 1]
            let tagLayoutConstraint = tagLayoutConstraintsArray[times - 1]
            
            if previousWidth + tag.frame.width < self.frame.width {
                tagLayoutConstraint.updateLeadingAndTopAnchorConstant(leadingConstant: previousWidth, topConstant: previousHeight)
                previousWidth += tag.frame.width + 10
            } else {
                previousWidth  = 0
                previousHeight += tagLayoutConstraint.heightAnchor.constant + 5
                tagLayoutConstraint.updateLeadingAndTopAnchorConstant(leadingConstant: previousWidth, topConstant: previousHeight)
                previousWidth += tag.frame.width + 10
            }
        }
    }
    
    //TagButtonが何行作られたか返す
    func tagViewType() -> Int {
        if tagButtonArray.count == 0 {
            print("Tagなし")
            return 0
        }
        
        let tagButtonHeight: CGFloat = tagLayoutConstraintsArray[0].heightAnchor.constant
        let tagMargin: CGFloat = 5
        
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
        let lastHeight:CGFloat = lastConstraint.topAnchor.constant
        let limits: CGFloat = lastConstraint.heightAnchor.constant * 3 + 10
        
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
        tagButtonArray[0].titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        let tagHeight: CGFloat = self.frame.height / 15.0
        let space: CGFloat = self.frame.height - (tagHeight * CGFloat(tagArray.count))
        let topSpace = space / CGFloat(tagArray.count)
        var previousHeight: CGFloat = topSpace
        tagLayoutConstraintsArray.forEach { (constraint) in
            constraint.updateHeightConstraint(height: tagHeight)
            constraint.updateWidthConstraint(width: self.frame.width * 0.5)
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
        let buttonWidth: CGFloat = headerButton.frame.width
        let buttonHeight: CGFloat = self.frame.width * 0.05
        headerButton.layer.cornerRadius = 5
        self.addSubview(headerButton)
        
        let taglayoutConstraint = TagLayoutConstraints()
        taglayoutConstraint.makeSizeConstraint(tagButton: headerButton, width: buttonWidth, height: buttonHeight)
        taglayoutConstraint.makeLeadingConstraint(tagButton: headerButton, xAxisAnchor: self.leadingAnchor, constant: 0)
        taglayoutConstraint.makeTopConstraint(tagButton: headerButton, yAxisAnchor: self.topAnchor, constant: 0)
        taglayoutConstraint.allConstraintsActivate()
        
        self.tagLayoutConstraintsArray.insert(taglayoutConstraint, at: 0)
        self.tagButtontag += 1
        self.tagButtonArray.insert(headerButton, at: 0)
        
    }
}
