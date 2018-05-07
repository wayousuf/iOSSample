//
//  FriendsControllerHelper.swift
//  FBMessanger
//
//  Created by Waqas Yousuf on 5/6/18.
//  Copyright © 2018 Waqas Yousuf. All rights reserved.
//

import UIKit
import CoreData

//class Friend: NSObject {
//    var name: String?
//    var profileImageName: String?
//}
//
//class Message: NSObject {
//    var text: String?
//    var date: Date?
//
//    var friend: Friend?
//}

extension FriendsController {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            do {
            
                let entityNames = ["Friend", "Message"]
                
                for entityName in entityNames {
                    
                    let fetchRrquest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    
                    let objects = try context.fetch(fetchRrquest) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.delete(object)
                    }
                }
                
                delegate?.saveContext()
                
            } catch let err {
                print(err)
            }
        }
    }
    
    func setupDate() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            
            //let mark = Friend()
            mark.name = "Mark Zuckerberg"
            mark.profileImageName = "zuckprofile"
            
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            message.friend = mark
            message.text = "Hello, my name is Mark, Nice to meet you...."
            message.date = Date()
            
            
            createSteveMessages(context: context)
            
            
            let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            donald.name = "Donald Trump"
            donald.profileImageName = "donald_profile"
            
            createMessage(text: "You're fired", friend: donald, minutesAgo: 5, context: context)

            let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            gandhi.name = "Mahatma Gandhi"
            gandhi.profileImageName = "gandhi_profile"
            
            createMessage(text: "Love, Pease, and Joy", friend: gandhi, minutesAgo: 60 * 24, context: context)

            
            let hillary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            hillary.name = "Hillary Clinton"
            hillary.profileImageName = "hillary_profile"
            
            createMessage(text: "Please vote for me, you did for Billy!", friend: hillary, minutesAgo: 8 * 60 * 24, context: context)
            
            
            delegate?.saveContext()
            
            //messages = [message, messageSteve]
        }
        
        loadData()
    }
    
    private func createSteveMessages(context: NSManagedObjectContext) {
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve_profile"
        
        createMessage(text: "Good morning..", friend: steve, minutesAgo: 3, context: context)
        createMessage(text: "Hello, how are you?", friend: steve, minutesAgo: 2, context: context)
        createMessage(text: "Are you intrested in buying an Apple device? We have a wide variety of Apple devices that will suit your needs. Please make your purchanse with us",friend: steve, minutesAgo: 1,context: context)
        
        // response message
        createMessage(text: "Yes, totally looking to by an iPhone 8.",friend: steve, minutesAgo: 1,context: context, isSender: true)
        
        createMessage(text: "Totally understand that you want the new iPhone 8, but you'll have to wait until September for the new release. Sorry but thats just how Apple likes to do things.",friend: steve, minutesAgo: 1,context: context)
        
        createMessage(text: "Absolutely, I'll just use my gigantic iPhone 7 Plus until then!!!",friend: steve, minutesAgo: 1,context: context, isSender: true)


    }
    
    private func createMessage(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = Date().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            guard let friends = fetchFriends() else { return }
            
            messages = [Message]()
            
            for friend in friends {
                let fetchRrquest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                fetchRrquest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                fetchRrquest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                fetchRrquest.fetchLimit = 1
                do {
                    let fetchMessage = try context.fetch(fetchRrquest) as? [Message]
                    messages?.append(contentsOf: fetchMessage!)
                } catch let err {
                    print(err)
                }
                
                messages = messages?.sorted(by: {m1, m2 in m1.date!.compare(m2.date!) == .orderedDescending })
            }
        }
    }
    
    private func fetchFriends() -> [Friend]? {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            
            do {
                
                return try context.fetch(request) as? [Friend]
                
            } catch let err {
                print(err)
            }
        }
        return nil
    }
}
