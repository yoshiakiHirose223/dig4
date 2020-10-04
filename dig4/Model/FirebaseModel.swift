//
//  FirebaseModel.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/11/26.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import Foundation
import Firebase

class FirebaseModel {
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    var myUser: User!
    var dispatchGroup: DispatchGroup!
    
    init() {
        ref = Database.database().reference()
        storageRef = Storage.storage().reference(forURL: "gs://dig4-c8177.appspot.com/")
        myUser = Auth.auth().currentUser
        dispatchGroup = DispatchGroup()
    }
    
    func setUserImage (image: UIImage, completion: @escaping () -> ()) {
        let imageRef = storageRef.child("ProfileImage").child(myUser.uid)
        let imageData = image.jpegData(compressionQuality: 0.3)
        imageRef.putData(imageData!, metadata: nil) { (metaData, error) in
            if error == nil {
                completion()
            } else {
                return
            }
        }
    }
    
    func setProfile (name: String, image: UIImage, completion: @escaping () -> ()) {
        //FirebaseAuthentificationを変える
        setUserImage(image: image) {
            let changeRequest = self.myUser.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges(completion: nil)
            //RDBにユーザー情報をセットする
            self.getUserImageUrl(userId: self.myUser.uid) { (urlString) in
                let userProfile: [String: Any] = ["UserName": name,
                                                  "UserId": self.myUser.uid,
                                                  "UserImageUrlString": urlString,
                                                  "FollowCount": 0,
                                                  "FollowerCount": 0,
                ]
                self.ref.child("Users").child(self.myUser.uid).setValue(userProfile)
                completion()
            }
        }


    }
    
    func getUserImage (userId: String, completion: @escaping (UIImage?) -> ()) {
        let storageRef = Storage.storage().reference(forURL: "gs://dig4-c8177.appspot.com/")
        let userImageRef = storageRef.child("ProfileImage").child(userId)
        //ユーザー画像取得
        userImageRef.getData(maxSize: 1024 * 1024) { (data, error) in
            if data != nil {
                let image = UIImage(data: data!)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    func getUserImageUrl (userId: String, completion: @escaping (String) -> ()) {
        let userImageRef = storageRef.child("ProfileImage").child(userId)
        userImageRef.downloadURL { (url, error) in
            guard let imageUrl = url else {
                return
            }
            let urlString = imageUrl.absoluteString
            completion(urlString)
        }
    }
    
    func getUserProfile(userId: String, completion: @escaping ([String: Any]) -> ()) {
        ref.child("Users").child(userId).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as? [String: Any] ?? nil
            guard let profile = value else {
                return
            }
            completion(profile)
        }
    }

    
    func getNumberOfFollow (userId: String, completion: @escaping (String?) -> ()) {
        //フォローの数取得
        let ref = Database.database().reference()
        ref.child("Users").child(userId).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as? [String: Any] ?? nil
            guard let afterValue = value else {
                completion(nil)
                return
            }
            //let profile = value as! [String: Any]
            let followCount = afterValue["FollowCount"] as! Int
            completion(String(followCount))
            
        }
    }
    
    func getNumberOfFollower (userId: String, completion: @escaping (String?) -> ()) {
        let ref = Database.database().reference()
        ref.child("Users").child(userId).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as? [String: Any] ?? nil
            guard value != nil else {
                completion(nil)
                return
            }
            let profile = snapShot.value as! [String: Any]
            let followerCount = profile["FollowerCount"] as! Int
            completion(String(followerCount))
        }
    }
    
    func isFollowed (userId: String, completion: @escaping (Bool) -> ()) {
        ref.child("Follow").child(myUser.uid).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as? [String: Any]
            guard let afterValue = value else {
                print("snapShot is nil in isFollowed")
                completion(false)
                return
            }
            
                for key in afterValue.keys {
                    let user = afterValue[key] as! [String: String]
                    let uid = user["uid"]!
                    if userId == uid {
                        //一致
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
    }
    
    func follow (myUser: User, userId: String, userName: String, completion: @escaping () -> ()) {
        let myProfile: [String: String] = Dictionary().makeUserInfoDic(name: myUser.displayName!, uid: myUser.uid)
        //相手の情報Get
        let displayedUser: [String: String] = Dictionary().makeUserInfoDic(name: userName, uid: userId)
        
        //フォローする側: 自分のFollow内に相手を入れる、自分のFollow数が増える
        //フォローされる: 相手のFollower内に自分を入れる、　相手のFollower数が増える
        ref.child("Follow").child(myUser.uid).child(userId).setValue(displayedUser)
        ref.child("Follower").child(userId).child(myUser.uid).setValue(myProfile)
        
        //Follow数とFollower数を取ってきてプラス１して返す
        dispatchGroup.enter()
        ref.child("Users").child(myUser.uid).observeSingleEvent(of: .value) { (snapShot) in
            var profile = snapShot.value as? [String: Any] ?? nil
            guard profile != nil else {
                self.dispatchGroup.leave()
                return
            }
            
            //Plus 1
            let followCount = profile!["FollowCount"] as! Int
            let changedFollowCount = followCount + 1
            //Profileにplusした値を入れて、戻す
            profile!["FollowCount"] = changedFollowCount
            self.ref.child("Users").child(myUser.uid).setValue(profile)
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        ref.child("Users").child(userId).observeSingleEvent(of: .value) { (snapShot) in
            var profile = snapShot.value as? [String: Any] ?? nil
            guard profile != nil else {
                self.dispatchGroup.leave()
                return
            }
            //Plus 1
            let followCount = profile!["FollowerCount"] as! Int
            let changedFollowCount = followCount + 1
            //Profileにplusした値を入れて、戻す
            profile!["FollowerCount"] = changedFollowCount
            self.ref.child("Users").child(userId).setValue(profile)
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func unFollow (myUser: User, userId: String, userName: String, completion: @escaping () -> ()) {
        
        ref.child("Follow").child(myUser.uid).child(userId).removeValue()
        ref.child("Follower").child(userId).child(myUser.uid).removeValue()
        
        //Follow数とFollower数を取ってきてプラス１して返す
        dispatchGroup.enter()
        ref.child("Users").child(myUser.uid).observeSingleEvent(of: .value) { (snapShot) in
            var profile = snapShot.value as? [String: Any] ?? nil
            guard profile != nil else {
                print("profile is nil")
                self.dispatchGroup.leave()
                return
            }
            //Plus 1
            let followCount = profile!["FollowCount"] as! Int
            let changedFollowCount = followCount - 1
            //Profileにplusした値を入れて、戻す
            profile!["FollowCount"] = changedFollowCount
            self.ref.child("Users").child(myUser.uid).setValue(profile)
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        ref.child("Users").child(userId).observeSingleEvent(of: .value) { (snapShot) in
            var profile = snapShot.value as? [String: Any] ?? nil
            guard profile != nil else {
                self.dispatchGroup.leave()
                return
            }
            //Plus 1
            let followerCount = profile!["FollowerCount"] as! Int
            let changedFollowCount = followerCount - 1
            //Profileにplusした値を入れて、戻す
            profile!["FollowerCount"] = changedFollowCount
            self.ref.child("Users").child(userId).setValue(profile)
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func setUsersView (path: String, userId: String, completion: @escaping (UserInfo) -> ()) {
        ref.child(path).child(userId).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as? [String: Any] ?? nil
            guard value != nil else {
                return
            }
            for key in value!.keys {
                //情報の取得
                let user:[String: String] = value![key] as! [String: String]
                let userName: String = user["Name"]!
                let userId: String = user["uid"]!
                //ユーザーの画像を取得
                let storageRef = Storage.storage().reference(forURL: "gs://dig4-c8177.appspot.com/")
                let userImageRef = storageRef.child("ProfileImage").child(userId)
                userImageRef.getData(maxSize: 1024 * 1024, completion: { (data, error) in
                    if data != nil {
                        let userImage = UIImage(data: data!)
                        let user = UserInfo(name: userName, image: userImage!, id: userId)
                        completion(user)
                    } else {
                        print(error)
                    }
                })
            }
        }
    }
    
    func addFavorites (tweetPath: String, tweet: [String: Any], completion: @escaping () -> ()) {
        //いいねできる
        dispatchGroup.enter()
        ref.child("FavoritesNumber").child(tweetPath).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as! Int
            let favNumber = value + 1
            let updateValue = ["/\(tweetPath)/": favNumber]
            print("Hell")
            self.ref.child("FavoritesNumber").updateChildValues(updateValue)
            print("o")
            self.dispatchGroup.leave()
        }
        ref.child("CanAddFavorites").child(tweetPath).setValue(false)
        
        let favoritesRef = ref.child("Favorites").child(myUser.uid).child(tweetPath)
        favoritesRef.setValue(tweet)
        favoritesRef.child("TimeStamp").setValue(ServerValue.timestamp())
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func removeFavorites (tweetPath: String, completion: @escaping () -> ()) {
        //いいねされている
        dispatchGroup.enter()
        ref.child("FavoritesNumber").child(tweetPath).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as! Int
            let favNumber = value - 1
            self.ref.child("FavoritesNumber").child(tweetPath).setValue(favNumber)
            self.dispatchGroup.leave()
        }
        ref.child("CanAddFavorites").child(tweetPath).setValue(true)
        ref.child("Favorites").child(myUser!.uid).child(tweetPath).removeValue()
        dispatchGroup.notify(queue: .main) {
            completion()
        }
}

    func setTweetData (path: String, child: String, completion: @escaping ([CellInfo]?) -> ()) {
        //self に入っている userプロパティは　”誰の” 情報
        //path は　”何の” 情報
        //ツイートが完成されるごとにTweetArrayに入れられて、reloadされる
        let dispatchGroup = DispatchGroup()
        ref.child(path).child(child).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as? [String: Any] ?? nil
            guard let valueResult = value else {
                print("何もなかった")
                completion(nil)
                return
            }
            let array = valueResult.map({ (key: String, value: Any) -> [String: Any] in
                let tweet = valueResult[key] as! [String: Any]
                return tweet
            })
            
            let tweets = array.map({(tweet) -> CellInfo in
                dispatchGroup.enter()
                let tweetPath: String = tweet["TweetPath"] as! String
                let cell = CellInfo()
                var favNumber: Int = 0
                var canfavorites: Bool = false
                
                self.ref.child("FavoritesNumber").child(tweetPath).observeSingleEvent(of: .value, with: { (snapShot) in
                    let value = snapShot.value as? Int ?? nil
                    guard let afterValue = value else {
                        return
                    }
                    favNumber = afterValue
                })
                
                self.ref.child("CanAddFavorites").child(tweetPath).observeSingleEvent(of: .value, with: { (snapShot) in
                    let value = snapShot.value as? Bool ?? nil
                    guard let afterValue = value else {
                        return
                    }
                    canfavorites = afterValue
                    cell.createCell(tweet: tweet, NumberOfFavorites: favNumber, canAddFavorites: canfavorites)
                    dispatchGroup.leave()
                })
                
                return cell
            })
            dispatchGroup.notify(queue: .main, execute: {
                completion(tweets)
            })

        }
    }
    
    func getLatestTweet(path: String, child: String, completion: @escaping ([CellInfo]?) -> ()) {
        ref.child(path).child(child).queryLimited(toFirst: 20).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as? [String: Any] ?? nil
            guard let valueResult = value else {
                completion(nil)
                return
            }
            self.changeValueToTweets(afterValue: valueResult, completion: { (tweets) in
                completion(tweets)
            })
        }
    }
    
    func checkCanFavorites (tweetPath: String, completion: @escaping (Bool) -> ()) {
        //自分のFavoritesに入っているかどうか
        ref.child("Favorites").child(myUser.uid).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as? [String: Any] ?? nil
            guard value != nil else {
                //ツイートがない　-> 何もいいねしてない -> いいねできる
                completion(true)
                return
            }
            //ツイートがある場合
            //いいねしているツイートか判断
            for key in value!.keys {
                let tweet = value![key] as! [String: Any]
                let path = tweet["TweetPath"] as! String
                    if path == tweetPath {
                        //いいねしているツイートがある　-> いいねできない
                        completion(false)
                    } else {
                        //いいねしているツイートがない -> いいねできる
                        completion(true)
                    }
                
            }
        }
    }
    
    func getFollower (completion: @escaping ([String]) -> ()) {
        ref.child("Follower").child(myUser.uid).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as? [String: Any] ?? nil
            guard value != nil else {
                return
            }
            let follower = value!.keys.map({ (uid) -> String in
                print("map")
                return uid
            })

            completion(follower)
        }
    }
    
    func upTweet (tweet: [String: Any], completion: @escaping () -> ()) {
        
        //MyTweet
        let tweetPath = tweet["TweetPath"] as! String
        let tweetRef = ref.child("MyTweet").child(myUser.uid).child(tweetPath)
        tweetRef.setValue(tweet)
        tweetRef.child("TimeStamp").setValue(ServerValue.timestamp())
        //Tag
        let tagArray = tweet["Tag"] as! [String]
        
        tagArray.forEach { (tag) in
            if tag != "" {
                let tagRef = ref.child("Tag").child(tag).child(tweetPath)
                tagRef.setValue(tweet)
                tagRef.child("TimeStamp").setValue(ServerValue.timestamp())
            }
        }
        //Favorites
        ref.child("FavoritesNumber").child(tweetPath).setValue(0)
        ref.child("CanAddFavorites").child(tweetPath).setValue(true)
        
        //自分のTLにも入れる
        let timeLineRef = ref.child("TimeLine").child(myUser.uid).child(tweetPath)
        timeLineRef.setValue(tweet)
        timeLineRef.child("TimeStamp").setValue(ServerValue.timestamp())
        
        //FollowerのTLに入れる
        dispatchGroup.enter()
        getFollower { (followerArray) in
            followerArray.forEach({ (follower) in
                self.dispatchGroup.enter()
                let followerRef = self.ref.child("TimeLine").child(follower).child(tweetPath)
                followerRef.setValue(tweet)
                followerRef.child("TimeStamp").setValue(ServerValue.timestamp())
                self.dispatchGroup.leave()
            })
            self.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func getNewTweet(path: String, child: String, startAt newTimeStamp: Int?,completion: @escaping ([CellInfo]?) -> ()) {
        //上に引っ張って更新
        //20取ってくる
        ref.child(path).child(child).queryOrdered(byChild: "TimeStamp").queryStarting(atValue: newTimeStamp).queryLimited(toFirst: 20).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as? [String: Any] ?? nil
            guard let valueResult = value else {
                completion(nil)
                return
            }
            self.changeValueToTweets(afterValue: valueResult, completion: { (tweets) in
                var tweetArray = tweets
                tweetArray.removeLast()
                guard tweetArray.count != 0 else {
                    completion(nil)
                    return
                }
                completion(tweetArray)
            })
        }
    }
    
    func getOldTweet(path: String, child: String, endAt oldTimeStamp: Int?,completion: @escaping ([CellInfo]?) -> ()) {
        //上に引っ張って更新
        //20取ってくる
        ref.child(path).child(child).queryOrdered(byChild: "TimeStamp").queryEnding(atValue: oldTimeStamp).queryLimited(toFirst: 20).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as? [String: Any] ?? nil
            guard let valueResult = value else {
                completion(nil)
                return
            }
            self.changeValueToTweets(afterValue: valueResult, completion: { (tweets) in
                var tweetArray = tweets
                tweetArray.removeFirst()
                guard tweetArray.count != 0 else {
                    completion(nil)
                    return
                }
                completion(tweetArray)
            })
        }
    }
    
    func getNewTweet(path: String, child: String,completion: @escaping ([CellInfo]?) -> ()) {
        //上に引っ張って更新
        //20取ってくる
        ref.child(path).child(child).queryOrdered(byChild: "TimeStamp").queryLimited(toLast: 3).observeSingleEvent(of: .value) { (snapShot) in
            let value = snapShot.value as? [String: Any] ?? nil
            guard let valueResult = value else {
                completion(nil)
                return
            }
            self.changeValueToTweets(afterValue: valueResult, completion: { (tweets) in
                completion(tweets)
            })
        }
    }
    
    func getTagSuggestion(completion: @escaping ([String]) -> ()) {
        ref.child("Tag").queryLimited(toFirst: 9).observeSingleEvent(of: .value) { (snapShot) in
            guard let afterValue = snapShot.value as? [String: Any] ?? nil else {
                return
            }
            let tagSuggestions = afterValue.map({ (key: String, value: Any) -> String in
                let tag = key
                return tag
            })
            completion(tagSuggestions)
        }
    }
    
    private func changeValueToTweets(afterValue: [String: Any], completion: @escaping ([CellInfo]) -> ()) {
        let array = afterValue.map({ (key: String, value: Any) -> [String: Any] in
            let tweet = afterValue[key] as! [String: Any]
            return tweet
        })
        
        let tweets = array.map({(tweet) -> CellInfo in
            dispatchGroup.enter()
            let tweetPath: String = tweet["TweetPath"] as! String
            let cell = CellInfo()
            var favNumber: Int = 0
            var canfavorites: Bool = false
            
            self.ref.child("FavoritesNumber").child(tweetPath).observeSingleEvent(of: .value, with: { (snapShot) in
                let value = snapShot.value as? Int ?? nil
                guard let afterValue = value else {
                    return
                }
                favNumber = afterValue
            })
            
            self.ref.child("CanAddFavorites").child(tweetPath).observeSingleEvent(of: .value, with: { (snapShot) in
                let value = snapShot.value as? Bool ?? nil
                guard let afterValue = value else {
                    return
                }
                canfavorites = afterValue
                cell.createCell(tweet: tweet, NumberOfFavorites: favNumber, canAddFavorites: canfavorites)
                self.dispatchGroup.leave()
            })
            
            return cell
        })
        
        dispatchGroup.notify(queue: .main) {
            let tweetArray = tweets.sorted(by: { (tweetA, tweetB) -> Bool in
                return tweetA.timeStamp > tweetB.timeStamp
            })
            completion(tweetArray)
        }
        
    }
    
}
