import 'package:flutter/material.dart';

class SupportChatPage extends StatefulWidget {
  const SupportChatPage({Key? key}) : super(key: key);

  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final List<_Message> _messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _messages.add(
      _Message(
        "Welcome to KeyGo Support Center! How can I help you today?",
        false,
      ),
    );
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text, true));
      _controller.clear();

      Future.delayed(const Duration(milliseconds: 300), () {
        final botResponse = _getBotResponse(text);
        setState(() {
          _messages.add(_Message(botResponse, false));
        });
      });
    });
  }

  String _getBotResponse(String userInput) {
    final input = userInput.toLowerCase();
    if (input.contains('file') && input.contains('claim')) {
      return 'To file a claim, go to the Claims tab and upload photos and details.';
    } else if (input.contains('cancel') &&
        (input.contains('booking') || input.contains('reservation'))) {
      return 'To cancel your car booking, go to "My Reservations" section and select the booking you want to cancel.';
    } else if (input.contains('cancel') && input.contains('insurance')) {
      return 'To cancel your insurance, please call us at 123-456-7890.';
    } else if (input.contains('policy')) {
      return 'You can find your policy details under the "My Policy" section.';
    } else if (input.contains('help')) {
      return 'Sure! I can help with bookings, claims, policy info, or cancellations. What would you like to know?';
    } else if (input.contains('contact') ||
        input.contains('phone') ||
        input.contains('call')) {
      return 'You can reach our customer service at 123-456-7890 or email us at support@keygo.com';
    } else if (input.contains('booking') ||
        input.contains('reserve') ||
        input.contains('rent')) {
      return 'To book a car, browse our available vehicles on the home screen and select "Book Now" on the car you like.';
    } else if (input.contains('payment') || input.contains('pay')) {
      return 'We accept all major credit cards, PayPal, and Apple Pay. Payment is processed securely at checkout.';
    } else if (input.contains('thank') || input.contains('thanks')) {
      return "You're welcome! Is there anything else I can help you with?";
    } else if (input.contains('bye') || input.contains('goodbye')) {
      return "Thank you for chatting with KeyGo Support. Have a great day!";
    } else {
      return "I'm not sure I understand. You can ask about bookings, cancellations, payments, or contact information.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Support"),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment:
                        msg.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: msg.isUser ? Colors.black : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: msg.isUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _handleSend(),
                        decoration: InputDecoration(
                          hintText: "Message...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _handleSend,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;

  _Message(this.text, this.isUser);
}
