//
//  SongViewController.swift
//  dig
//
//  Created by 廣瀬由明 on 2019/10/22.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit

class SongViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var itunesApi: iTunesApiModel!
    var searchWord: String!

    var searchResultArray: [SearchResult] = []
    //CreateTweetControllerに戻った時にさせたい処理
    var postDismissAction: (() -> Void)?
    
    //処理順番管理
    var dispatchQueue: DispatchQueue?
    var dispatchQueue_Main: DispatchQueue!
    
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itunesApi = iTunesApiModel()
        dispatchQueue_Main = DispatchQueue.main
        viewInit()
        itunesApi.getArtistData(artistName: searchWord) { (searchResult) in
            self.dispatchQueue_Main.async {
                //self.searchResultArray.append(searchResult)
                self.collectionView.reloadData()
            }
        }
    }

    
    
    override func viewWillLayoutSubviews() {
        //frame と bounds
        collectionView.frame = self.view.bounds
        collectionView.contentSize = self.view.frame.size
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let itemWidthHeight = self.view.bounds.width * 0.4
        let itemMargin = self.view.bounds.width * 0.05
        layout.itemSize = CGSize(width: itemWidthHeight, height: itemWidthHeight)
        layout.sectionInset = UIEdgeInsets(top: itemMargin, left: itemMargin, bottom: itemMargin, right: itemMargin)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        print("SongViewController.view.frame \(self.view.frame)")
        print("SongViewController.view.bounds \(self.view.bounds)")
        print("Collectionview.frame \(collectionView.frame)")

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = searchResultArray[indexPath.row]
        /*
        let navigationController = self.presentingViewController as! UINavigationController
        let nvCount = navigationController.viewControllers.count
        let createVC = navigationController.viewControllers[nvCount - 1] as! CreateTweetViewController*/

        
        let createVC = self.navigationController?.topViewController as! CreateTweetViewController
        
        createVC.didSelectItem = item
        self.dismiss(animated: true) {
            self.postDismissAction!()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongCell", for: indexPath) as! SongCollectionViewCell
        let item = searchResultArray[indexPath.row]
        cell.setCell(artistSong: item.artistSong, artistImageUrlString: item.artistImageUrl)
        return cell
    }
    

    func viewInit() {

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let itemWidthHeight = self.view.frame.width * 0.4
        let itemMargin = self.view.frame.width * 0.05
        layout.itemSize = CGSize(width: itemWidthHeight, height: itemWidthHeight)
        layout.sectionInset = UIEdgeInsets(top: itemMargin, left: itemMargin, bottom: itemMargin, right: itemMargin)
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(SongCollectionViewCell.self, forCellWithReuseIdentifier: "SongCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
    }
    

}
