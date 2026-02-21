import 'package:flutter/material.dart';
import 'have_a_talk_screen.dart';

class Message {
  final String text;
  final bool isMe;

  Message(this.text, this.isMe);
}

class TigeScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const TigeScreen({super.key, this.onBack});

  @override
  State<TigeScreen> createState() => _TigeScreenState();
}

class _TigeScreenState extends State<TigeScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Message> _messages = [
    Message('Hello there! How are you feeling today?', false),
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text, true));
    });
    _controller.clear();
    _scrollToBottom();

    // Simulate Tige's response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(Message('I hear you. Tell me more about that.', false));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2A1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2A1D),
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFFE3EED4)),
                tooltip: 'Back',
                onPressed: widget.onBack,
              )
            : null,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFE3EED4),
              child: Icon(Icons.pets, size: 18, color: Color(0xFF0F2A1D)),
            ),
            SizedBox(width: 12),
            Text('Tige',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFFE3EED4))),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.graphic_eq_rounded,
                color: Color(0xFFE3EED4), size: 28),
            tooltip: 'Have a Talk',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const HaveATalkScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
          IconButton(
              icon:
                  const Icon(Icons.more_vert_rounded, color: Color(0xFFE3EED4)),
              onPressed: () {}),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F2A1D),
          image: DecorationImage(
            image: AssetImage('assets/images/chat_bg.png'),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMe = message.isMe;
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: isMe
                            ? const Color(0xFF375534)
                            : const Color(0xFFE3EED4),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(24),
                          topRight: const Radius.circular(24),
                          bottomLeft: isMe
                              ? const Radius.circular(24)
                              : const Radius.circular(4),
                          bottomRight: isMe
                              ? const Radius.circular(4)
                              : const Radius.circular(24),
                        ),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: isMe
                              ? const Color(0xFFE3EED4)
                              : const Color(0xFF0F2A1D),
                          fontSize: 16,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F2A1D),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B9071).withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Color(0xFFE3EED4)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B9071).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: const Color(0xFF6B9071)
                                  .withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: const Icon(Icons.emoji_emotions_outlined,
                                  color: Color(0xFFE3EED4), size: 24),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                style: const TextStyle(
                                    color: Color(0xFFE3EED4), fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: 'Message',
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  hintStyle: TextStyle(
                                      color: const Color(0xFFE3EED4)
                                          .withValues(alpha: 0.5)),
                                ),
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HaveATalkScreen()),
                                );
                              },
                              child: const Icon(Icons.mic_none_rounded,
                                  color: Color(0xFFE3EED4), size: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        height: 44,
                        width: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE3EED4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_upward_rounded,
                            color: Color(0xFF0F2A1D)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
