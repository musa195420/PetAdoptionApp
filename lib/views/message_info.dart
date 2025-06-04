import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petadoption/viewModel/message_view_model.dart';
import '../custom_widgets/stateful_wrapper.dart';

class MessageInfo extends StatelessWidget {
  MessageInfo({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Color lightBrown = const Color(0xFFD7CCC8);
  final Color darkBrown = const Color(0xFF3E2723);
  final Color softGrey = Colors.grey;
  final Color cardBackground = Colors.white;

  final Gradient appBarGradient = const LinearGradient(
    colors: [Color(0xFF3D1B00), Color(0xFFFF7700)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MessageViewModel>();

    return StatefulWrapper(
      onInit: () async => await viewModel.getMessagesInfo(),
      onDispose: () {},
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFFAF3E0),
        body: SafeArea(
          child: viewModel.intailized
              ? Column(
                  children: [
                    // Gradient AppBar with title
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        gradient: appBarGradient,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Contact',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        onChanged: (value) => viewModel.filteredMessages(value),
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.search, color: darkBrown, size: 20),
                          hintText: 'Search by email...',
                          hintStyle: const TextStyle(color: Colors.black45),
                          filled: true,
                          fillColor: lightBrown.withOpacity(0.4),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Message list
                    Expanded(
                      child: viewModel.filteredMessage != null &&
                              viewModel.filteredMessage!.isEmpty
                          ? const Center(child: Text("No messages found"))
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: viewModel.filteredMessage?.length ?? 0,
                              itemBuilder: (context, index) {
                                final msg = viewModel.filteredMessage![index];
                                return InkWell(
                                  onTap: () => viewModel.gotoMessagePage(msg),
                                  child: MessageCard(
                                    email: msg.email ?? '',
                                    isOnline: msg.lastMessage == 'Online',
                                    lastSeen: msg.messageTime,
                                    profileImage: msg.profileImage,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.brown)),
        ),
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final String email;
  final bool isOnline;
  final DateTime? lastSeen;
  final String? profileImage;

  const MessageCard({
    super.key,
    required this.email,
    required this.isOnline,
    required this.lastSeen,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    const lightBrown = Color(0xFFD7CCC8);
    const darkBrown = Color(0xFF3E2723);
    const softGrey = Colors.grey;
    const cardBackground = Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFBCAAA4)),
        boxShadow: [
          BoxShadow(
            color: lightBrown.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: lightBrown, // background color
                ),
                clipBehavior: Clip.antiAlias, // still needed
                child: profileImage != null
                    ? ClipOval(
                        // <--- This makes the image circular
                        child: Image.network(
                          profileImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.person, color: darkBrown),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.person, color: darkBrown),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isOnline ? Colors.green : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        email,
                        style: const TextStyle(
                          color: darkBrown,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, size: 16, color: Colors.blue),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isOnline
                      ? 'Online'
                      : 'Last seen ${_formatLastSeen(lastSeen)}',
                  style: const TextStyle(color: softGrey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastSeen(DateTime? time) {
    if (time == null) return 'unknown';
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minute(s) ago';
    if (diff.inHours < 24) return '${diff.inHours} hour(s) ago';
    return '${diff.inDays} day(s) ago';
  }
}
