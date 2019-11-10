'use strict';

var AV = require('leanengine');
var http = require("http").Server(AV);
var io = require("socket.io")(http);
var localStorage = require("localStorage");
AV.init({
  appId: process.env.LEANCLOUD_APP_ID,
  appKey: process.env.LEANCLOUD_APP_KEY,
  masterKey: process.env.LEANCLOUD_APP_MASTER_KEY
});
// 如果不希望使用 masterKey 权限，可以将下面一行删除
AV.Cloud.useMasterKey();

var app = require('./app');

// 端口一定要从环境变量 `LEANCLOUD_APP_PORT` 中获取。
// LeanEngine 运行时会分配端口并赋值到该变量。
var PORT = parseInt(process.env.LEANCLOUD_APP_PORT || process.env.PORT || 3000);
app.listen(PORT, function (err) {
  console.log('Node app is running on port:', PORT);

  // 注册全局未捕获异常处理器
  process.on('uncaughtException', function(err) {
    console.error('Caught exception:', err.stack);
  });
  process.on('unhandledRejection', function(reason, p) {
    console.error('Unhandled Rejection at: Promise ', p, ' reason: ', reason.stack);
  });
});
app.get("/", (req, res) => {
    res.send("You have reached the default route for the Make-ChatRooms Backend!")
});

io.on('connection', function (socket) {
    console.log("New User Has Connected!") // Outputted to terminal to notify you that a new user has connected

    socket.on('chat message', function (message) { // Listening for an incoming chat message
        username = getKeyByValue(localStorage, socket.id)
        parsedMessage = JSON.parse(message) // Converts message JSON string into a JSON Object

        console.log("Incoming Message -> ", parsedMessage)
        console.log("Message sent from -> ( ", username, " ", socket.id, ")")
        socket.broadcast.to(parsedMessage.roomOriginName).emit('chat message', message) // Broadcasts message to everyone in the room that the message was sent from except the sender
    });

    // Listening for when the client sends in a username for the given socket connection!
    socket.on("socketUsername", function (username) {
        console.log(username + " is the username being sent!") // Outputted to terminal

        socket.nickname = username // Assigning the socket nickname to be the username that the client passes

        // Checking if username is already present
        if (localStorage.getItem(username)) {
            console.log("Someone currently connected to the server shares the same username!")
            socket.emit("usernameCollision", username)

        } else { // If we don't see the username
            localStorage.setItem(username, socket.id) // saving the item in local storage

            // Emit that the username chosen because it is a successful username
            socket.emit("validUsername", username)
        }
    });

    // Triggered when a user wants to create/join a room
    socket.on("joinRoom", function (roomName) {
        console.log(socket.id + " has joined the room " + roomName)
        socket.join(roomName)

        io.of("/").in(roomName).clients((error, clients) => {
            if (error) {
                console.log(error)
            }
            for (i = 0; i < clients.length; i++) {
                client = clients[i]
                console.log(" " + " Clients connected " + getKeyByValue(localStorage, client))
            }
        })
    });

    // Triggered when client wants to leave the room they are currently connected to
    socket.on("leaveRoom", function (roomName) {
        console.log("Leaving room " + roomName)
        socket.leave(roomName);
    });

    // Triggered when the user disconnects and their socket connections gets disbanded!
    socket.on('disconnect', function () { 
        console.log("User has disconnected!") // No special teardown needed on our part

        username = getKeyByValue(localStorage, socket.id); // Fetch the username associated with the socket connection

        localStorage.removeItem(username) // Remove that key value pair and print the local storage after the key value pair has been removed
        console.log(localStorage)

    });

});


function getKeyByValue(object, value) { // Helper function to find username given the socket id or connection
    return Object.keys(object).find(key => object[key] === value);
}
