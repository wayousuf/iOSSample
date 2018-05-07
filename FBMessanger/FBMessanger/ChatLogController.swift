//
//  ChatLogController.swift
//  FBMessanger
//
//  Created by Waqas Yousuf on 5/7/18.
//  Copyright © 2018 Waqas Yousuf. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            
            messages = friend?.messages?.allObjects as? [Message]
            
            messages = messages?.sorted(by: {m1, m2 in m1.date!.compare(m2.date!) == .orderedAscending })

        }
    }
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = messages?.count else { return 0 }
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        
        cell.messageTextView.text = messages?[indexPath.item].text
        
        guard let message = messages?[indexPath.item] else { return cell }
        
        
        if let messageText = message.text, let profileImageName =  message.friend?.profileImageName {
            
            cell.profileImageView.image = UIImage(named: profileImageName)
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            if message.isSender == false {
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 6)
                
                cell.profileImageView.isHidden = false
                
                //cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                
                cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
                
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                
                cell.messageTextView.textColor = .black

                
            } else {
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                let textBubbleViewXValue = view.frame.width - estimatedFrame.width - 24 - 16 - 10
                let textBubbleViewWithValue = estimatedFrame.width + 24 + 10
                
                cell.textBubbleView.frame = CGRect(x: textBubbleViewXValue, y: -4, width: textBubbleViewWithValue,  height: estimatedFrame.height + 20)
                
                cell.profileImageView.isHidden = true
                
                //cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                
                cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
                
                cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                
                cell.messageTextView.textColor = .white
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text {
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
       let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let textBubbleView: UIView = {
       let view = UIView()
        //view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
     static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    
    let bubbleImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = ChatLogMessageCell.grayBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    override func setupView() {
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
       
        addSubview(profileImageView)
        
        addConstraints(withFormat: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraints(withFormat: "V:[v0(30)]|", views: profileImageView)
        
        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraints(withFormat: "H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraints(withFormat: "V:|[v0]|", views: bubbleImageView)

    }
}
