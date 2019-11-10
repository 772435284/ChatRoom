//
//  Message.swift
//  Make-ChatRooms-StarterKit
//
//  Created by Yitao Qiu on 2019/11/9.
//  Copyright © 2019 Yitao Qiu. All rights reserved.
//

import Foundation
class Message:Codable {
    let messageContent: String
    let senderUsername: String
    var messageSender: Bool?
    var roomOriginName: String
    
    init(messageContent: String, senderUsername: String, messageSender: Bool?, roomOriginName: String) {
        self.messageContent = messageContent
        self.senderUsername = senderUsername
        self.messageSender = messageSender
        self.roomOriginName = roomOriginName
    }
    
    private enum CodingKeys: String,CodingKey {
        case messageContent
        case senderUsername
        case messageSender
        case roomOriginName
    }
    
    required convenience init(from decoder: Decoder) {
           // ACTION: Change these from let to var
           let container = try? decoder.container(keyedBy: CodingKeys.self)
           let messageContent = try? container?.decode(String.self, forKey: .messageContent) ?? ""
           let senderUsername = try? container?.decode(String.self, forKey: .senderUsername) ?? ""
           let messageSender = try? container?.decodeIfPresent(Bool.self, forKey: .messageSender) ?? false
           let roomOriginName = try? container?.decode(String.self, forKey: .roomOriginName) ?? ""
           
           // Force unwrapping may prove to hurt in the future, let's see how we can safely unwrap these values!
           self.init(messageContent: messageContent ?? "", senderUsername: senderUsername ?? "", messageSender: messageSender, roomOriginName: roomOriginName ?? "")
       }

}
