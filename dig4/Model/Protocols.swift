//
//  Protocols.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/25.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import UIKit

protocol TagViewDelegate: AnyObject {
    func didLongPressTagButton(_ sender: UIButton)
    func updateTagViewHeight(height: CGFloat)
}

protocol TagViewDataSource: AnyObject {
    func didTouchTagButton (_ sender: UIButton)
}


protocol HeaderViewDelegate: AnyObject {
    func didTouchUserImage (userId: String, userName: String)
}

protocol ArtistViewDelegate: AnyObject {
    func playMusic(previewUrl: URL)
}

protocol FooterViewDelegate: AnyObject {
    func didTouchFavoritesButton (cellIndexPath: IndexPath)
}

protocol TagSearchDelegate: AnyObject {
    func didTouchSearchButton(word: String)
    func textFieldisBlank()
}

protocol ProfileViewDelegate: AnyObject {
    func didFollow (isFollowed: Bool)
    func goFollowFollowerPage(_ sender: UIButton)
}
