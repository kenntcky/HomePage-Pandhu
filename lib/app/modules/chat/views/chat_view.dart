import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../local_widget/chat_bubble.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/groq_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with SingleTickerProviderStateMixin {
  final groqService = GroqService(apiKey: dotenv.env['GROQ_API_KEY']!);
  final stt.SpeechToText _speech = stt.SpeechToText();
  
  TextEditingController messageController = TextEditingController();
  bool isListening = false;
  bool isLoading = false;
  bool _speechEnabled = false;
  late AnimationController _micAnimationController;
  late Animation<double> _micAnimation;

  List<ChatBubble> chatBubbles = [
    const ChatBubble(
      direction: Direction.left,
      message: 'Halo! Apakah ada yang ingin dibantu?',
      type: BubbleType.alone,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _micAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _micAnimation = Tween(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _micAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _micAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    try {
      _speechEnabled = await _speech.initialize(
        onStatus: (status) {
          print('Speech status: $status');
          if (status == 'notListening' || status == 'done') {
            setState(() => isListening = false);
            _micAnimationController.reverse();
          }
        },
        onError: (error) {
          print('Speech error: $error');
          setState(() {
            isListening = false;
            _micAnimationController.reverse();
          });
          _showErrorSnackBar('Error: ${error.errorMsg}');
        },
      );
      setState(() {});
    } catch (e) {
      print('Speech initialization error: $e');
      _showErrorSnackBar('Failed to initialize speech recognition');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status.isDenied) {
      _showErrorSnackBar('Microphone permission is required for speech recognition');
    }
  }

  Future<void> _startListening() async {
    if (!_speechEnabled) {
      await _initSpeech();
    }

    final micPermission = await Permission.microphone.status;
    if (micPermission.isDenied) {
      await _requestMicrophonePermission();
      return;
    }

    if (!isListening) {
      try {
        final available = await _speech.initialize();
        if (available) {
          setState(() {
            isListening = true;
            messageController.text = ''; // Clear existing text
          });
          _micAnimationController.forward();
          
          await _speech.listen(
            onResult: (result) {
              setState(() {
                // Update text in real-time with interim results
                messageController.text = result.recognizedWords;
                // Move cursor to end
                messageController.selection = TextSelection.fromPosition(
                  TextPosition(offset: messageController.text.length),
                );
              });
            },
            listenFor: const Duration(seconds: 10), // Maximum listening duration
            partialResults: true, // Enable interim results
            localeId: 'id_ID',
            cancelOnError: true,
            listenMode: stt.ListenMode.dictation, // Change to dictation mode for better continuous recognition
          );
        }
      } catch (e) {
        print('Error starting speech recognition: $e');
        _showErrorSnackBar('Failed to start speech recognition');
        setState(() {
          isListening = false;
          _micAnimationController.reverse();
        });
      }
    } else {
      _speech.stop();
      setState(() => isListening = false);
      _micAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get theme and color scheme
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      // Explicitly set background color, as default might be different from AppBar
      backgroundColor: theme.scaffoldBackgroundColor,
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
        backgroundColor: const Color(0xFFF6643C), // Keep fixed orange AppBar
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
            // Set container background to match themed Scaffold background
            color: theme.scaffoldBackgroundColor, 
            child: Row(
              children: [
                ScaleTransition(
                  scale: _micAnimation,
                  child: IconButton(
                    icon: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      // Use theme colors for mic icon states
                      color: isListening ? colorScheme.error : colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: _startListening,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: messageController,
                      // Style TextField based on theme
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'Ketik Pesan',
                        // Use theme hint color
                        hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                        // Use filled style with surface color
                        filled: true,
                        fillColor: colorScheme.surface,
                        // Adjust border based on theme (e.g., subtle or none)
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Keep consistent radius?
                          borderSide: BorderSide.none, // No border for a cleaner look
                        ),
                        // Focused border (optional, can add subtle primary color)
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: colorScheme.primary, width: 1.5), // Subtle primary focus indicator
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust padding
                      ),
                    ),
                  ),
                ),
                isLoading
                    ? CircularProgressIndicator.adaptive( 
                        // Ensure progress indicator color fits theme
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                      )
                    : Stack(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: ShapeDecoration(
                                // Keep fixed orange send button background
                                color: const Color(0xFFF6643C),
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