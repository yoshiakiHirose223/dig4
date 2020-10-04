//
//  CustomPresentationTransition.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/25.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import UIKit

class CustomPresentationControler: UIPresentationController {
    //呼び出し元のVCの上に重ねるview
    var overlayView = UIView()
    
    // 表示トランジション開始前に呼ばれる
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }
        overlayView.frame = containerView.bounds
        overlayView.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(overlayViewDidTouch(_:)))]
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.0
        containerView.insertSubview(overlayView, at: 0)
        
        //トランジションの実行
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.overlayView.alpha = 0.7
            }, completion: nil)
        
    }
    
    //非表示トランジション開始前に呼ばれる
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.overlayView.alpha = 0.0
            }, completion: nil)
    }
    
    //非表示トランジション開始後に呼ばれる
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            overlayView.removeFromSuperview()
        }
    }
    
    //子のコンテナサイズを返す
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        //表示されるViewControllerのサイズ
        if presentedViewController as? SongTableViewController != nil {
            //SongTableViewController
            let widthMargin = parentSize.width * 0.2
            let saizu = CGSize(width: parentSize.width - widthMargin, height: parentSize.height * 0.60)
            return saizu
        } else {
            return CGSize(width: 0, height: 0)
        }
        
    }
    
    //ContainerViewに入っている遷移先のフレーム
    override var frameOfPresentedViewInContainerView: CGRect {
        
        if presentedViewController as? SongTableViewController != nil {
            var presentedViewFrame = CGRect()
            let containerBounds = containerView!.bounds
            let childContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
            
            let widthMargin = containerBounds.width * 0.10
            let availableHeight: CGFloat = overlayView.frame.height - presentedViewController.view.safeAreaInsets.top
            let heightMargin: CGFloat = (availableHeight - childContentSize.height ) / 2
            presentedViewFrame.size = childContentSize
            presentedViewFrame.origin.x = widthMargin
            presentedViewFrame.origin.y = heightMargin
            
            return presentedViewFrame
        } else {
            return CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }
    
    //レイアウト開始前に呼ばれる
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 10
        presentedView?.clipsToBounds = true
    }
    
    //レイアウト開始後に呼ばれる
    override func containerViewDidLayoutSubviews() {
        
    }
    
    @objc func overlayViewDidTouch (_ sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}
