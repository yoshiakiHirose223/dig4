//
//  FooterView.swift
//  dig
//
//  Created by 廣瀬由明 on 2019/08/26.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import Firebase

class FooterView: UIView {
    var firebaseModel: FirebaseModel!
    
    weak var delegate: FooterViewDelegate?
    var cellIndexPath: IndexPath!
    
    var favoritesButton: UIButton!
    var goodNumberLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        firebaseModel = FirebaseModel()
        viewInit()
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        viewLayout()
}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTouchFavoritesButton (_ sender: UIButton) {
        if favoritesButton.currentImage == UIImage(named: "afterFavorites") {
            favoritesButton.setImage(UIImage(named: "beforeFavorites"), for: .normal)
        } else {
            favoritesButton.setImage(UIImage(named: "afterFavorites"), for: .normal)
        }
        delegate?.didTouchFavoritesButton(cellIndexPath: cellIndexPath)
    }
    

}

extension FooterView {
    
    func viewInit () {
        //各部品の生成
        favoritesButton = UIButton(type: .custom)
        goodNumberLabel = UILabel()
        
        //コードからレイアウトの設定、ContentModeの設定
        favoritesButton.translatesAutoresizingMaskIntoConstraints = false
        goodNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let favoritesImage = UIImage(named: "いいね")
        favoritesButton.setImage(favoritesImage, for: .normal)
        favoritesButton.addTarget(self, action: #selector(didTouchFavoritesButton(_:)), for: .touchUpInside)
        favoritesButton.contentMode = .scaleToFill
        //貼り付ける
        self.addSubview(favoritesButton)
        self.addSubview(goodNumberLabel)
    }
    
    func viewLayout() {
        //goodImageのレイアウト
        //大きさはViewImageと同じ
        favoritesButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        favoritesButton.widthAnchor.constraint(equalTo: favoritesButton.heightAnchor).isActive = true
        favoritesButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 250).isActive = true
        favoritesButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        //goodNumberのレイアウト
        goodNumberLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        goodNumberLabel.leadingAnchor.constraint(equalTo: favoritesButton.trailingAnchor).isActive = true
        goodNumberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        goodNumberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    func createFooterView (goodNumer: Int, tweetPath: String, indexPath: IndexPath, canAddFavorites: Bool) {
        
        firebaseModel.ref.child("FavoritesNumber").child(tweetPath).observeSingleEvent(of: .value
            , with: { (snapShot) in
                guard let value = snapShot.value as? Int else {
                    return
                }
                self.goodNumberLabel.text = value.withComma
                self.goodNumberLabel.textColor = .white
                self.goodNumberLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        })
        
        cellIndexPath = indexPath
        //いいねしてないツイートか否か判断
            if canAddFavorites {
                self.favoritesButton.setImage(UIImage(named: "beforeFavorites"), for: .normal)
            } else {
                self.favoritesButton.setImage(UIImage(named: "afterFavorites"), for: .normal)
            }
        }
    }
