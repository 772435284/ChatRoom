//
//  RoomsTableViewController.swift
//  Make-ChatRooms-StarterKit
//
//  Created by Yitao Qiu on 2019/11/8.
//  Copyright © 2019 Yitao Qiu. All rights reserved.
//

import Foundation
import UIKit

class ConfigureCell: UITableViewCell {}

class RoomsTableViewController: UITableViewController {
    var rooms: [Room] = [Room]()
    lazy var createRoomButton: UIBarButtonItem = {
        let createJoinRoomButton = UIBarButtonItem(title: "Create Room", style: .plain, target: self, action: #selector(createRoom(sender:)))
        return createJoinRoomButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = createRoomButton
        tableView.register(ConfigureCell.self, forCellReuseIdentifier: "RoomTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoomViewController = ChatRoomViewController()
        chatRoomViewController.roomName = SharedUser.shared.user?.activeRooms?[indexPath.row].roomName ?? "Empty Room"
        self.navigationController?.pushViewController(chatRoomViewController, animated: true)
    }

       
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

           let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTableViewCell", for: indexPath)

            if let user = SharedUser.shared.user {
                cell.textLabel?.text = user.activeRooms?[indexPath.row].roomName
                cell.detailTextLabel?.text = "Test Text"
            }
           return cell
   }
       
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       let rooms = SharedUser.shared.user?.activeRooms ?? [Room]()
       return rooms.count
   }
    
    @objc func createRoom(sender: UIBarButtonItem) {
        print("User wants to create a room")
        
        // The initial message and creating of text field in charge of grabbing user input

        let createRoomAlert = UIAlertController(title: "Enter Room Name", message: "Please enter the name of the room you'd like to join or create!", preferredStyle: .alert)
        createRoomAlert.addTextField { (roomNameTextField) in
            roomNameTextField.placeholder = "Room Name?"
        }

        let saveAction = UIAlertAction(title: "Create/Join Room", style: .default) { (action) in
            guard let roomName = createRoomAlert.textFields?[0].text
            else {return}
            let room = Room(roomName: roomName)
            

            print("Name of the room user wants to create/join \(roomName)")
            
            ChatRoom.shared.room = room
            ChatRoom.shared.joinRoom()
            

            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("User has canceled the action to create/join a room")
        }
        createRoomAlert.addAction(saveAction)
        createRoomAlert.addAction(cancelAction)
        self.present(createRoomAlert, animated: true, completion: nil)
    }
}

