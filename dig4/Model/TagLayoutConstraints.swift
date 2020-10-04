//
//  TagLayoutConstraints.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/25.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import UIKit

class TagLayoutConstraints {
    var widthAnchor: NSLayoutConstraint!
    var heightAnchor: NSLayoutConstraint!
    var leadingAnchor: NSLayoutConstraint!
    var topAnchor: NSLayoutConstraint!
    
    func makeSizeConstraint(tagButton: UIButton, width: CGFloat, height: CGFloat) {
        widthAnchor = tagButton.widthAnchor.constraint(equalToConstant: width)
        heightAnchor = tagButton.heightAnchor.constraint(equalToConstant: height)
    }
    
    func makeWidthConstraint(tagButton: UIButton, width: CGFloat) {
        widthAnchor = tagButton.widthAnchor.constraint(equalToConstant: width)
    }
    
    func makeLeadingConstraint(tagButton: UIButton, xAxisAnchor viewLeadingAnchor: NSLayoutXAxisAnchor, constant distance: CGFloat) {
        leadingAnchor = tagButton.leadingAnchor.constraint(equalTo: viewLeadingAnchor, constant: distance)
    }
    func makeTopConstraint(tagButton: UIButton, yAxisAnchor viewTopAnchor: NSLayoutYAxisAnchor, constant distance: CGFloat) {
        topAnchor = tagButton.topAnchor.constraint(equalTo: viewTopAnchor, constant: distance)
    }
    func allConstraintsActivate() {
        widthAnchor.isActive = true
        heightAnchor.isActive = true
        leadingAnchor.isActive = true
        topAnchor.isActive = true
    }
    
    func updateHeightConstraint(height: CGFloat) {
        heightAnchor.isActive = false
        heightAnchor.constant = height
        heightAnchor.isActive = true
    }
    
    func updateWidthConstraint(width: CGFloat) {
        widthAnchor.isActive = false
        widthAnchor.constant = width
        widthAnchor.isActive = true
    }
    
    func updateTopConstraint(topConstraint: CGFloat) {
        topAnchor.isActive = false
        topAnchor.constant = topConstraint
        topAnchor.isActive = true
    }
    
    func leadingAndTopConstraintDeactivate() {
        leadingAnchor.isActive = false
        topAnchor.isActive = false
    }
    func updateLeadingAndTopAnchorConstant(leadingConstant: CGFloat, topConstant: CGFloat) {
        leadingAnchor.isActive = false
        topAnchor.isActive = false
        leadingAnchor.constant = leadingConstant
        topAnchor.constant = topConstant
        leadingAnchor.isActive = true
        topAnchor.isActive = true
    }
}
