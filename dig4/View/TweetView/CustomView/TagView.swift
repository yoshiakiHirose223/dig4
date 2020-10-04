//
//  CreateTagView.swift
//  dig
//
//  Created by 廣瀬由明 on 2019/06/24.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit

class TagView: UIView {
    
    weak var delegate: TagViewDelegate?
    weak var dataSource: TagViewDataSource?
    var tagButtonArray: [UIButton] = []
    var tagLayoutConstraintsArray: [TagLayoutConstraints] = []
    var tagButtontag: Int = 1
    var canMakeNewTag: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }


}
