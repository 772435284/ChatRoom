//
//  ShareInstance.swift
//  Make-ChatRooms-StarterKit
//
//  Created by Yitao Qiu on 2019/11/8.
//  Copyright © 2019 Yitao Qiu. All rights reserved.
//

import Foundation
class SharedUser {
    static var shared = SharedUser()
    var user: User?
}
