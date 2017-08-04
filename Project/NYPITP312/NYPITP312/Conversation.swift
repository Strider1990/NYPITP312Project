//
//  Conversation.swift
//  NYPITP312
//
//  Created by Jervis Ang on 3/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Conversation {
    
    // PROPERTIES
    let user: User
    var lastMessage: Message
    
    
    // RETIREVE CONVERSATION
    class func showConversations(completion: @escaping ([Conversation]) -> Swift.Void) {
        if let currentUserID = FIRAuth.auth()?.currentUser?.uid {
            var conversations = [Conversation]()
            FIRDatabase.database().reference().child("users").child(currentUserID).child("conversations").observe(.childAdded, with: { (snapshot) in
                if snapshot.exists() {
                    let fromID = snapshot.key
                    let values = snapshot.value as! [String: String]
                    let location = values["location"]!
                    User.info(forUserID: fromID, completion: { (user) in
                        let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true)
                        let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
                        conversations.append(conversation)
                        conversation.lastMessage.downloadLastMessage(forLocation: location, completion: { (_) in
                            completion(conversations)
                        })
                    })
                }
            })
        }
    }
    
    // INISTALIZATION
    init(user: User, lastMessage: Message) {
        self.user = user
        self.lastMessage = lastMessage
    }
}
