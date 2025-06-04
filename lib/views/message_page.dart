import 'package:flutter/material.dart';
import 'package:petadoption/models/request_models/message_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewModel/message_view_model.dart'; // adjust path
import '../custom_widgets/stateful_wrapper.dart';

class MessagePage extends StatelessWidget {
  MessagePage({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();

  final Color lightBrown = const Color(0xFFD7CCC8);
  final Color darkBrown = const Color(0xFF5D4037);
  final Color softGrey = const Color(0xFF757575);
  final Color pageBackground = const Color(0xFFFDF6EC);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MessageViewModel>();

    return StatefulWrapper(
      onInit: () {},
      onDispose: () {},
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: pageBackground,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, viewModel),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: viewModel.messages!.length,
                  itemBuilder: (context, index) {
                    final message =
                        viewModel.messages!.reversed.toList()[index];
                    final isSender = message.senderId == viewModel.user!.userId;
                    return _buildMessageBubble(message, isSender);
                  },
                ),
              ),
              _buildInputBar(context, viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MessageViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [darkBrown, Colors.orange.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              await viewModel.gotoMessageInfo();
            },
            child: Icon(
              Icons.arrow_back_ios_new_sharp,
              size: 20,
              color: Colors.white,
            ),
          ),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: viewModel.currentInfo != null &&
                    viewModel.currentInfo!.profileImage != null
                ? ClipOval(
                    // ensures the image is circular
                    child: Image.network(
                      viewModel.currentInfo!.profileImage!,
                      width: 48, // match 2x radius
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, color: Colors.black);
                      },
                    ),
                  )
                : const Icon(Icons.person, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name (top left)
              Text(
                viewModel.reciverInfo!.name ?? "N/A",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 4),
              // Role (left) and Location (right)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    viewModel.reciverInfo!.role ?? "",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  SizedBox(width: MediaQuery.sizeOf(context).width * 0.06),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 14,
                      ),
                      Text(
                        viewModel.reciverInfo!.location ?? "Not Specified",
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call, color: Colors.white)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.videocam, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message, bool isSender) {
    final bubbleColor = isSender ? darkBrown : lightBrown;
    final textColor = isSender ? Colors.white : Colors.black87;
    final alignment =
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isSender
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: radius,
            ),
            child: Text(
              message.content ?? '',
              style: TextStyle(color: textColor, fontSize: 15),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTimestamp(message.timestamp),
            style: TextStyle(color: softGrey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, MessageViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Type your message...",
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon:
                  const Icon(Icons.send, color: Color.fromARGB(255, 55, 20, 7)),
              onPressed: () async {
                final content = _messageController.text.trim();
                if (content.isNotEmpty) {
                  await viewModel.addMessage(
                    viewModel.senderId!,
                    viewModel.receiverId!,
                    content,
                  );
                  _messageController.clear();
                  await viewModel.getMessages(viewModel.receiverId!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';
    return DateFormat('hh:mm a').format(timestamp);
  }
}
