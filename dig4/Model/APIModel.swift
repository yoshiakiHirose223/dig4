//
//  APIModel.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/11/27.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit

class APIModel:NSObject, XMLParserDelegate {

    
    //parserの準備
    var parser = XMLParser()
    //パース中の現在の要素名
    var currentElementName: String!
    //現在の階層
    var currentStage: String!
    //追加されるべきreleaseID
    var currentReleaseID: String!
    //パースした結果を入れる。
    var parseResult: [SongInfo] = []
    
    var continueFlag: Bool = true
    
    var searchResult: [SongInfo] = []
    var dispatchQueue_Main: DispatchQueue!
    
    override init() {
        super.init()
        dispatchQueue_Main = DispatchQueue.main
    }
 
       /*
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongCell", for: indexPath) as! SongCollectionViewCell
        
        let result = searchResult[indexPath.row]
        cell.setCell(songTitle: result.title, thumbnails: result.thumbnails)
        
        return cell
    }
    
    func searchArtist (searchWord: String, completion: @escaping ([SongInfo]) -> ()) {
        let urlString = "https://musicbrainz.org/ws/2/recording/?query=artist:\(searchWord)"
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encodedUrl!)
        parser = XMLParser(contentsOf: url!)!
        parser.delegate = self
        parser.parse()
        completion(self.parseResult)
    }
 */
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    
        currentElementName = nil
        //要素のnil チェック
        if parseResult.count > 0 {
            let lastItem = parseResult.last
            if lastItem?.title == nil || lastItem?.releaseID == nil {
                //title,releaseID 一方でも欠けていたら、その要素は削除する
                parseResult.removeLast(0)
            }
        }
        
        if elementName == "recording" {
            //<recording>毎にNewsItemが作成される。
            self.parseResult.append(SongInfo())
            currentElementName = elementName
            currentStage = elementName
        } else if elementName == "release" {
            //releaseIDは一曲につき複数ある場合がある。
            //その場合、サムネの画像を確実に取るには最後のreleaseIDを取る必要があるため、
            //releaseIDがある分更新し続ける。
            currentReleaseID = attributeDict["id"]
            currentElementName = elementName
        } else if elementName == "name-credit" {
            currentElementName = elementName
            currentStage = elementName
        } else {
            currentElementName = elementName
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.parseResult.count > 0 {
            let lastItem = self.parseResult[parseResult.count - 1]
            if currentElementName == "title" && currentStage == "recording" {
                lastItem.title = string
                //currentStageは、<recording>直下の<title>を取るため、
                //<recording>開始時にcurrentStage = recording になり、<title>が追加されたと同時に、nilになる。
                currentStage = nil
            } else if currentElementName == "name" && currentStage == "name-credit" {
                lastItem.name = string
                currentStage = nil
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElementName = nil
        if elementName == "release-list" {
            //<release-list>のEndタグがあったら、最新のreleaseIDを要素に入れる。
            let lastItem = self.parseResult[parseResult.count - 1]
            lastItem.releaseID = currentReleaseID
            currentReleaseID = nil
        }
    }
    
    func getThumbnailsUrl (parseResult: [SongInfo], completion: @escaping () -> ()) {
        var times: Int = 0
        parseResult.forEach { (result) in
            let releaseId: String? = result.releaseID
            let url: URL = URL(string: "https://coverartarchive.org/release/\(releaseId!)/")!
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                guard self.continueFlag else {
                    return
                }
                print(url)
                print("現在　\(times) 回目の処理です")
                do {
                    print("② \(result.title) の　JSON解析　開始")
                    //ThumbnailsのURLを取得
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                    let images = json!["images"] as? [[String:Any]]
                    let thumbnails = images?[0]["thumbnails"] as? [String:String]
                    var smallThumbnails:String = thumbnails!["small"]!
                    if let range = smallThumbnails.range(of: "http") {
                        smallThumbnails.replaceSubrange(range, with: "https")
                        result.thumbnailsURL = smallThumbnails
                        print("③ \(result.title) の　サムネURL取得完了　::\(result.thumbnailsURL)")
                        //取得したThumbnailsのURLを使って画像を撮りに行く
                        self.getThumbnailsImage(result: result, index: times, completion: {
                            self.dispatchQueue_Main.async {
                                completion()
                            }
                        })
                        times += 1
                    }
                } catch {
                    print("⑶ \(result.title) の　サムネURL取得失敗　(T . T)")
                    result.thumbnailsURL = nil
                    self.getThumbnailsImage(result: result, index: times, completion: {
                        self.dispatchQueue_Main.async {
                            completion()
                        }
                    })
                    times += 1
                }
            })
            task.resume()
            print("① \(result.title) の　解析開始")
        }
    }
    
    func getThumbnailsImage (result: SongInfo, index: Int, completion: @escaping () -> ()) {
        if let urlString = result.thumbnailsURL {
            let url = URL(string: urlString)
            do {
                //print("URLから画像のDLに成功！")
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                result.thumbnails = image
                print("④ \(result.title)のサムネ取得に成功")
                
                guard continueFlag else {
                    return
                }
                searchResult[index] = result
                completion()
            } catch {
                // print("URLを探しても画像がなかった。。。")
                result.thumbnails = nil
                print("⑷ \(result.title)のサムネ取得に失敗")
                guard continueFlag else {
                    return
                }
                searchResult[index] = result
                completion()
            }
        } else {
            //thumbnailsURLを発見することができず、thumbnailsArrayにnilが入っていた場合、
            //画像を探すことができないため、itemsにnilを入れる。
            result.thumbnails = nil
            print("⑷ \(result.title)のサムネ取得に失敗")
            guard continueFlag else {
                return
            }
            searchResult[index] = result
            completion()
        }
    }
    
    func makeLoadingCollectionView (count:Int, completion: @escaping () -> ()) {
        for _ in 0..<count {
            let noImageElement = SongInfo()
            noImageElement.thumbnails = nil
            noImageElement.title = "ロード中"
            searchResult.append(noImageElement)
        }
        completion()
    }
    
}
