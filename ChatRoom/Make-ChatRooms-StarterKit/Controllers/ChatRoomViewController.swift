//
//  ChatRoomViewController.swift
//  Make-ChatRooms-StarterKit
//
//  Created by Yitao Qiu on 2019/11/9.
//  Copyright © 2019 Yitao Qiu. All rights reserved.
//

import Foundation
import UIKit

class ChatRoomViewController: UIViewController {
    
    let chatRoom = ChatRoom()
    var roomName = ""
    let tableView = UITableView() // The messages are going to be organized using a UITableView
    
    // Instantiate the message input view that adds itself as a subview
    let messageInputBar = MessageInputView()
    
    var messages = [Message]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ChatRoom.shared.delegate = self 
    }
    
}

extension ChatRoomViewController : MessageInputDelegate {
        func sendWasTapped(message: String) {
            guard let username = SharedUser.shared.user?.username else {return}
           print("Sent Message \(message)")
            let messageObject = Message(messageContent: message, senderUsername: username , messageSender: true, roomOriginName: self.roomName)
           ChatRoom.shared.sendMessage(message: messageObject)
           insertNewMessageCell(messageObject)
        }

}


 extension ChatRoomViewController: ChatRoomDelegate {
    
    func recievedMessage(message: Message) {
        message.messageSender = false // Will always be false due to us broadcasting messages ... therefore if we receive a message we couldn't have possibly sent it.
        
        // If we are connected to multiple rooms we only want to display messages that are being sent to the current room we are visually in!
        if message.roomOriginName == self.roomName {
            insertNewMessageCell(message)
        }
        
    }
}
