import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static const String appKey = "297a09215f794505a62e71e416b045ad";
  static const String userId = "tfm";
  String token =
      "007eJxTYEjksRDZf+aShtelDX6HFh17ezTt8KOnD1zUdCzDrv3ZZGiowGBkaZ5oYGlkaJpmbmliamCaaGaUam6YamJolmRgYpqY8nZKXmpDICPDrrUdTIwMTAyMQAjiMzOUpOUCAEaMIIY=";

  late ChatClient agoraChatClient;
  bool isJoined = false;

  ScrollController scrollController = ScrollController();
  TextEditingController messageBoxController = TextEditingController();
  String messageContent = "", recipientId = "";
  final List<Widget> messageList = [];

  showLog(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void initState() {
    super.initState();
    setupChatClient();
    setupListeners();
  }

  void setupChatClient() async {
    ChatOptions options = ChatOptions(
      appKey: appKey,
      autoLogin: false,
    );
    agoraChatClient = ChatClient.getInstance;
    await agoraChatClient.init(options);
    await ChatClient.getInstance.startCallback();
  }

  void setupListeners() {
    agoraChatClient.addConnectionEventHandler(
      "CONNECTION_HANDLER",
      ConnectionEventHandler(
          onConnected: onConnected,
          onDisconnected: onDisconnected,
          onTokenWillExpire: onTokenWillExpire,
          onTokenDidExpire: onTokenDidExpire),
    );

    agoraChatClient.chatManager.addEventHandler(
      "MESSAGE_HANDLER",
      ChatEventHandler(onMessagesReceived: onMessagesReceived),
    );
  }

  void displayMessage(String text, bool isSentMessage) {
    messageList.add(Row(children: [
      Expanded(
        child: Align(
          alignment:
              isSentMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.fromLTRB(
                (isSentMessage ? 50 : 0), 5, (isSentMessage ? 0 : 50), 5),
            decoration: BoxDecoration(
              color: isSentMessage
                  ? const Color(0xFFDCF8C6)
                  : const Color(0xFFFFFFFF),
            ),
            child: Text(text),
          ),
        ),
      ),
    ]));

    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent + 50);
    });
  }

  void onMessagesReceived(List<ChatMessage> messages) {
    for (var msg in messages) {
      if (msg.body.type == MessageType.TXT) {
        ChatTextMessageBody body = msg.body as ChatTextMessageBody;
        displayMessage(body.content, false);
        showLog("Message from ${msg.from}");
      } else {
        String msgType = msg.body.type.name;
        showLog("Received $msgType message, from ${msg.from}");
      }
    }
  }

  void onTokenWillExpire() {
    // The token is about to expire. Get a new token
    // from the token server and renew the token.
  }
  void onTokenDidExpire() {
    // The token has expired
  }
  void onDisconnected() {
    // Disconnected from the Chat server
  }
  void onConnected() {
    showLog("Connected");
  }

  void joinLeave() async {
    if (!isJoined) {
      // Log in
      try {
        print("1");
        await agoraChatClient.loginWithAgoraToken(userId, token);
        print("2");
        showLog("Logged in successfully as $userId");
        setState(() {
          isJoined = true;
        });
      } on ChatError catch (e) {
        if (e.code == 200) {
          // Already logged in
          setState(() {
            isJoined = true;
          });
        } else {
          showLog("Login failed, code: ${e.code}, desc: ${e.description}");
        }
      }
    } else {
      // Log out
      try {
        await agoraChatClient.logout(true);
        showLog("Logged out successfully");
        setState(() {
          isJoined = false;
        });
      } on ChatError catch (e) {
        showLog("Logout failed, code: ${e.code}, desc: ${e.description}");
      }
    }
  }

  void sendMessage() async {
    if (recipientId.isEmpty || messageContent.isEmpty) {
      showLog("Enter recipient user ID and type a message");
      return;
    }

    var msg = ChatMessage.createTxtSendMessage(
      targetId: recipientId,
      content: messageContent,
    );
    ChatClient.getInstance.chatManager.addMessageEvent(
      "UNIQUE_HANDLER_ID",
      ChatMessageEvent(
        onSuccess: (msgId, msg) {
          log("on message succeed");
        },
        onProgress: (msgId, progress) {
          log("on message progress");
        },
        onError: (msgId, msg, error) {
          log(
            "on message failed, code: ${error.code}, desc: ${error.description}",
          );
        },
      ),
    );
    ChatClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID");
    agoraChatClient.chatManager.sendMessage(msg);
  }

  @override
  void dispose() {
    agoraChatClient.chatManager.removeEventHandler("MESSAGE_HANDLER");
    agoraChatClient.removeConnectionEventHandler("CONNECTION_HANDLER");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agora Messaging"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter recipient's userId",
                      ),
                      onChanged: (chatUserId) => recipientId = chatUserId,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 80,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: joinLeave,
                    child: Text(isJoined ? "Leave" : "Join"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (_, index) {
                  return messageList[index];
                },
                itemCount: messageList.length,
              ),
            ),
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: messageBoxController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Message",
                    ),
                    onChanged: (msg) => messageContent = msg,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 50,
                height: 40,
                child: ElevatedButton(
                  onPressed: sendMessage,
                  child: const Text(">"),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
