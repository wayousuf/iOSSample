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
    
    let messageInputContainerView: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor.white
       return view
    }()
    
    let messageTextFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "Enter message..."
        return textFiled
    }()
    
    lazy var sendButton: UIButton = {
       let button = UIButton(type: UIButtonType.system)
        button.setTitle("Send", for: UIControlState.normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: UIControlState.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    @objc func handleSend() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let message = FriendsController.createMessage(text: messageTextFiled.text!, friend: friend!, minutesAgo: 0, context: context, isSender: true)
        
        delegate.saveContext()
        
        messages?.append(message)
        
        let item = (messages?.count)! - 1
        let insertionIndexPath = IndexPath(item: item, section: 0)
        
        collectionView?.insertItems(at: [insertionIndexPath])
        
        collectionView?.scrollToItem(at: insertionIndexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
        messageTextFiled.text = nil

    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    @objc func simulate() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let message = FriendsController.createMessage(text: "Here's a text message that was sent a few min ago..", friend: friend!, minutesAgo: 2, context: context)
        
        delegate.saveContext()
        
        messages?.append(message)
        
        //messages = messages?.sorted(by: {m1, m2 in m1.date!.compare(m2.date!) == .orderedDescending })

        messages = messages?.sorted(by: { (m1, m2) -> Bool in
            return m1.date! > m2.date!
        })
        
        if let item = messages?.index(of: message) {
            let recevingIndexPath = IndexPath(item: item, section: 0)
            collectionView?.insertItems(at: [recevingIndexPath])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: UIBarButtonItemStyle.plain, target: self, action: #selector(simulate))
            
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 55, right: 0)
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView?.backgroundColor = .white
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(messageInputContainerView)
        view.addConstraints(withFormat: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraints(withFormat: "V:[v0(48)]", views: messageInputContainerView)
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardNotification(notification: Notification) {
        
        guard let userInfo = notification.userInfo else {return}
        
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let isKeyboardShowing = notification.name == Notification.Name.UIKeyboardWillShow
        
        bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
        
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (completed) in
            
            //guard count = self.messages?.count else {return}
            if isKeyboardShowing {
            
                let indexPath = IndexPath(item: (self.messages?.count)! - 1, section: 0)
               
                self.collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        messageTextFiled.endEditing(true)
    }
    
    private func setupInputComponents() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        messageInputContainerView.addSubview(messageTextFiled)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        messageInputContainerView.addConstraints(withFormat: "H:|-8-[v0][v1(60)]|", views: messageTextFiled, sendButton)
        messageInputContainerView.addConstraints(withFormat: "V:|[v0]|", views: messageTextFiled)
        messageInputContainerView.addConstraints(withFormat: "V:|[v0]|", views: sendButton)
        
        messageInputContainerView.addConstraints(withFormat: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstraints(withFormat: "V:|[v0(0.5)]", views: topBorderView)
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
//    }
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
