//
//  User.swift
//  Make-ChatRooms-StarterKit
//
//  Created by Yitao Qiu on 2019/11/8.
//  Copyright © 2019 Yitao Qiu. All rights reserved.
//

import Foundation

class User { var username: String; var activeRooms : [Room]?

    init(username: String, activeRooms: [Room]?) {
        self.username = username
        self.activeRooms = activeRooms
    }
}
