//
//  ViewController.swift
//  FBFeed
//
//  Created by Waqas Yousuf on 4/27/18.
//  Copyright © 2018 Waqas Yousuf. All rights reserved.
//

import UIKit

let cellId = "cellId"

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //var posts = [Post]()
    var posts = Posts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let postMark = Post()
//        postMark.name = "Mark Zuckerberg"
//        postMark.profileImageName = "zuckprofile"
//        postMark.statusText = "By giving people the power to share, we're making the world more transparent."
//        postMark.statusImageName = "zuckdog"
//        postMark.numLikes = 400
//        postMark.numComments = 123
//        let postSteve = Post()
//        postSteve.name = "Steve Jobs"
//
//        postSteve.profileImageName = "steve_profile"
//        postSteve.statusText = "Design is not just what it looks like and feels like. Design is how it works.\n\n" +
//            "Being the richest man in the cemetery doesn't matter to me. Going to bed at night saying we've done something wonderful, that's what matters to me.\n\n" +
//        "Sometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations."
//        postSteve.statusImageName = "steve_status"
//        postSteve.numLikes = 1000
//        postSteve.numComments = 55
//
//        let postGandhi = Post()
//        postGandhi.name = "Mahatma Gandhi"
//        postGandhi.profileImageName = "gandhi_profile"
//        postGandhi.statusText = "Live as if you were to die tomorrow; learn as if you were to live forever.\n" +
//            "The weak can never forgive. Forgiveness is the attribute of the strong.\n" +
//        "Happiness is when what you think, what you say, and what you do are in harmony."
//        postGandhi.statusImageName = "gandhi_status"
//        postGandhi.numLikes = 333
//        postGandhi.numComments = 22
//
//
//        posts.append(postMark)
//        posts.append(postSteve)
//        posts.append(postGandhi)
//
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024

        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myDiskPath")
        URLCache.shared = urlCache
        
        navigationItem.title = "Facebook Feed"
        
        collectionView?.alwaysBounceVertical = true;
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.numberOfPosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath]
       
        return feedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let statusText = posts[indexPath].statusText {
            
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [.font: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 24 + 8 + 44
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 16)
        }
        
        return CGSize(width: view.frame.width , height: 500)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}







