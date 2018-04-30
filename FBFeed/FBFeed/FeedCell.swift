//
//  FeedCellCollectionViewCell.swift
//  FBFeed
//
//  Created by Waqas Yousuf on 4/29/18.
//  Copyright © 2018 Waqas Yousuf. All rights reserved.
//

import UIKit

//var imageCache = [String: UIImage]()

//var imageCache = NSCache<NSString, UIImage>()

class FeedCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            
            statusImageView.image = nil
            
//            if let statusImageName = post?.statusImageName {
//                statusImageView.image = UIImage(named: statusImageName)
//                loader.stopAnimating();
//            }
            
            
            
            if let statusImageUrl = post?.statusImageUrl {
                
//                if let image = imageCache.object(forKey: statusImageUrl as NSString) {
//                    statusImageView.image = image
//
//                } else {
                
                    URLSession.shared.dataTask(with: URL(string: statusImageUrl)!) { (data, response, error) in
                        
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        let image = UIImage(data: data!)
                        
                        //imageCache.setObject(image!, forKey: statusImageUrl as NSString)
                        
                        //imageCache[statusImageUrl] = image
                        
                        DispatchQueue.main.async {
                            self.statusImageView.image = image
                            self.loader.stopAnimating()
                        }
                    }.resume()
                //}
            }
            
            
            setupNameLocationStatusAndProfileImage()
        }
    }
    
    private func setupNameLocationStatusAndProfileImage() {
        
        if let name = post?.name {
            let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.boldSystemFont(ofSize: 14) ] )
            
            attributedText.append(NSAttributedString(string: "\nDecember 18 . San Francisco . ", attributes: [.font: UIFont.systemFont(ofSize: 12),
                                                                                                              .foregroundColor: UIColor.rgb(red: 155, green: 161, blue: 171)]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            
            attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.count))
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "globe_small")
            attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            
            attributedText.append(NSAttributedString(attachment: attachment))
            
            nameLabel.attributedText = attributedText
        }
        
        if let statusText = post?.statusText {
            statusTextView.text = statusText
        }
        
        if let profileImage = post?.profileImageName {
            profileImageView.image = UIImage(named: profileImage)
        }
        
//        if let statusImage = post?.statusImageName {
//            statusImageView.image = UIImage(named: statusImage)
//        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckprofile")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.text  = "Meanwhile, Beast turned to the dark side."
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckdog")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let likesCommetsLabel: UILabel = {
        let label = UILabel()
        label.text = "400 Likes     10.7k Comments"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return view
    }()
    
    let likeButton = buttonForTitle(title: "Like", imageName: "like")
    let commentButton = buttonForTitle(title: "Comment", imageName: "comment")
    let shareButton = buttonForTitle(title: "Share", imageName: "share")
    
    static func buttonForTitle(title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
        
        button.setImage(UIImage(named: imageName), for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }
    
    func setupView(){
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommetsLabel)
        addSubview(dividerLineView)
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        setupStatusImageViewLoader()
        
        addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstraintsWithFormat("H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat("H:|[v0]|", views: statusImageView)
        addConstraintsWithFormat("H:|-12-[v0]|", views: likesCommetsLabel)
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: dividerLineView)
        
        addConstraintsWithFormat("H:|[v0(v1)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)
        
        addConstraintsWithFormat("V:|-12-[v0]", views: nameLabel)
        
        addConstraintsWithFormat("V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", views: profileImageView, statusTextView, statusImageView, likesCommetsLabel, dividerLineView, likeButton)
        
        addConstraintsWithFormat("V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat("V:[v0(44)]|", views: shareButton)
    }
    
    let loader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    func setupStatusImageViewLoader() {
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loader.color = UIColor.black
        statusImageView.addSubview(loader)
        statusImageView.addConstraintsWithFormat("H:|[v0]|", views: loader)
        statusImageView.addConstraintsWithFormat("V:|[v0]|", views: loader)
    }
}


