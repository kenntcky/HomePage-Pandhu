import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../local_widget/chat_bubble.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/groq_service.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final groqService = GroqService(apiKey: "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");

  TextEditingController messageController = TextEditingController();

  bool isLoading = false;

  List<ChatBubble> chatBubbles = [
    const ChatBubble(
      direction: Direction.left,
      message: 'Halo! Apakah ada yang ingin dibantu?',
      type: BubbleType.alone,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          child: Image.asset("asset/img/icon/arrow-left.png"),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Image.asset("asset/img/icon/aibot.png"),
                ),
                SizedBox(
                  width: 5,
                ),
                const Column(
                  children: [
                    Text(
                      "SiPandhu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Teman AI Anda',
                      style: TextStyle(
                        color: Color(0xFFFBC1B1),
                        fontSize: 10,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Image.asset("asset/img/icon/more.png")
          ],
        ),
        backgroundColor: const Color(0xFFF6643C),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              reverse: true,
              padding: const EdgeInsets.all(10),
              children: chatBubbles.reversed.toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Ketik Pesan',
                      ),
                    ),
                  ),
                ),
                isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : Stack(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: ShapeDecoration(
                                color: Color(0xFFF6643C),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(58))),
                          ),
                          IconButton(
                            icon: const Image(
                                image: AssetImage("asset/img/icon/send-2.png")),
                            onPressed: () async {
                              if (messageController.text.trim().isEmpty) return;
                              
                              setState(() {
                                isLoading = true;
                              });

                              // Add user message
                              setState(() {
                                chatBubbles = [
                                  ...chatBubbles,
                                  ChatBubble(
                                    direction: Direction.right,
                                    message: messageController.text,
                                    photoUrl: null,
                                    type: BubbleType.alone
                                  )
                                ];
                              });

                              try {
                                // Get response from Groq
                                final response = await groqService.generateResponse(messageController.text);
                                
                                setState(() {
                                  chatBubbles = [
                                    ...chatBubbles,
                                    ChatBubble(
                                      direction: Direction.left,
                                      message: response,
                                      photoUrl: null,
                                      type: BubbleType.alone
                                    )
                                  ];
                                });
                              } catch (e) {
                                setState(() {
                                  chatBubbles = [
                                    ...chatBubbles,
                                    const ChatBubble(
                                      direction: Direction.left,
                                      message: 'Maaf, saya sedang mengalami gangguan',
                                      type: BubbleType.alone
                                    )
                                  ];
                                });
                              }

                              messageController.clear();
                              setState(() {
                                isLoading = false;
                              });
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}