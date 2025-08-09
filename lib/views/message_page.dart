import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petadoption/custom_widgets/loading_indicators.dart';
import 'package:petadoption/models/request_models/message_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../custom_widgets/custom_button.dart';
import '../helpers/locator.dart';
import '../services/navigation_service.dart';
import '../viewModel/message_view_model.dart'; // adjust path
import '../custom_widgets/stateful_wrapper.dart';

final _focusNode = FocusNode();

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
      onInit: () {
        viewModel.initSocket(viewModel.senderId!, viewModel.receiverId!);
      },
      onDispose: () {
        viewModel.disposeSocket();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: pageBackground,

        // 🔥 Drawer added here
        endDrawer: Drawer(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1C0B00).withOpacity(0.9),
                  Color(0xFF3D1B00).withOpacity(0.95),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF3D1B00).withOpacity(0.6),
                            Color(0xFFFF7700).withOpacity(0.4),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.orangeAccent.withOpacity(0.4)),
                      ),
                      child: const Center(
                        child: Text(
                          'Active Events',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: viewModel.listItems.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: viewModel.listItems.length,
                          itemBuilder: (context, index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFF4A2C18).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                viewModel.listItems[index],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              onTap: () {
                                Navigator.of(context).pop();
                                viewModel
                                    .onMenuItemTap(viewModel.listItems[index]);
                              },
                              hoverColor: Colors.orange.withOpacity(0.1),
                              splashColor: Colors.orange.withOpacity(0.2),
                            ),
                          ),
                        )
                      : const Center(
                          child: Text(
                            "No Events Scheduled",
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),

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
            child: const Icon(
              Icons.arrow_back_ios_new_sharp,
              size: 20,
              color: Colors.white,
            ),
          ),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: viewModel.currentInfo != null &&
                    viewModel.currentInfo!.profileImage != null &&
                    viewModel.currentInfo!.profileImage!.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: viewModel.currentInfo!.profileImage!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Center(
                              child: FadingCircularDots(
                            count: 10,
                            radius: 20,
                            dotRadius: 4,
                            duration: Duration(milliseconds: 1200),
                          )),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
                  )
                : const Icon(Icons.person, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.reciverInfo!.name ?? "N/A",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    viewModel.reciverInfo!.role ?? "",
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  SizedBox(width: MediaQuery.sizeOf(context).width * 0.06),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.white, size: 14),
                      Text(
                        viewModel.reciverInfo!.location ?? "Not Specified",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // 🍔 menu button
          IconButton(
            onPressed: () async {
              await viewModel.drawerLogic();
              scaffoldKey.currentState!.openEndDrawer();
            },
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
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

    final viewModel = Provider.of<MessageViewModel>(scaffoldKey.currentContext!,
        listen: false);
    final isSelected = viewModel.selectedMessage == message;

    return GestureDetector(
      onLongPress: () {
        if (isSender) {
          viewModel.selectMessage(message);
        }
      },
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: alignment,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                if (isSelected)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () {
                          showEditMessageDialog(
                            message: message,
                            viewModel: viewModel,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () async {
                          viewModel.selectMessage(null);
                          await viewModel.deleteMessage(message);
                          await viewModel.getMessages(viewModel.receiverId!);
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

  Future<void> showEditMessageDialog({
    required MessageModel message,
    required MessageViewModel viewModel,
  }) async {
    NavigationService navigationService = locator<NavigationService>();
    final BuildContext context = navigationService.navigatorKey.currentContext!;
    final controller = TextEditingController(text: message.content ?? '');

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: const Color(0xFFFAF3E0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Row(
                      children: [
                        const Icon(Icons.edit, color: Color(0xFF3E2723)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Edit Message',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E2723),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // TextField
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBCAAA4)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: TextFormField(
                          controller: controller,
                          maxLines: null,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration.collapsed(
                            hintText: "Type your new message...",
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          height: 45,
                          text: "Cancel",
                          onTap: () {
                            navigationService.popDialog(result: null);
                          },
                          backgroundcolor: const Color(0xFFBCAAA4),
                          fontcolor: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        CustomButton(
                          height: 45,
                          text: "Update",
                          onTap: () async {
                            final updatedText = controller.text.trim();
                            if (updatedText.isNotEmpty) {
                              message.content = updatedText;
                              viewModel.updateMessage(message);
                              viewModel.selectMessage(null);
                              navigationService.popDialog(result: null);
                              await viewModel
                                  .getMessages(viewModel.receiverId!);
                            }
                          },
                          backgroundcolor: const Color(0xFFFF6F00),
                          fontcolor: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
              child: RawKeyboardListener(
                focusNode: _focusNode, // <- listener’s node
                autofocus: true, // grab focus when the page opens
                onKey: (RawKeyEvent event) async {
                  if (event is RawKeyDownEvent) {
                    final isEnter =
                        event.logicalKey == LogicalKeyboardKey.enter;
                    final isShiftPressed = event.isShiftPressed;

                    // Enter without Shift  ➜  send
                    if (isEnter && !isShiftPressed) {
                      final content = _messageController.text.trim();
                      if (content.isNotEmpty) {
                        final msg = MessageModel(
                          senderId: viewModel.senderId!,
                          receiverId: viewModel.receiverId!,
                          content: content,
                          timestamp: DateTime.now(),
                        );
                        viewModel.sendMessage(msg);
                        _messageController.clear();
                        await viewModel.getMessages(viewModel.receiverId!);
                      }
                    }
                  }
                },

                // TextField gets its *own* internal FocusNode.
                child: TextField(
                  controller: _messageController,
                  maxLines: null, // allow multi‑line input
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText: "Type your message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon:
                  const Icon(Icons.send, color: Color.fromARGB(255, 55, 20, 7)),
              onPressed: () async {
                final content = _messageController.text.trim();
                if (content.isNotEmpty) {
                  final msg = MessageModel(
                    senderId: viewModel.senderId!,
                    receiverId: viewModel.receiverId!,
                    content: content,
                    timestamp: DateTime.now(),
                  );
                  viewModel.sendMessage(msg);
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
