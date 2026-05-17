import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/ai_assistant/presentation/widgets/chatbot_card.dart';
import 'package:aleef/features/chat/widgets/chat_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../provider/chat_provider.dart';
import 'chat_details.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = context.read<ChatProvider>();

      final isAuthorized = await provider.getChats();

      if (!isAuthorized) {
        await SecureStorageService().deleteToken();
        await SecureStorageService().deleteUser();

        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
              (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chats",
                style: AppTextStyles.titleLarge,
              ),
              const SizedBox(height: 4),
              const Text("Your conversations with doctors"),
              const SizedBox(height: 20),

              ChatBotCard(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.chatBotScreen,
                  );
                },
              ),

              const SizedBox(height: 16),

              Expanded(
                child: Builder(
                  builder: (context) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (provider.errorMessage != null) {
                      return Center(
                        child: Text(provider.errorMessage!),
                      );
                    }

                    if (provider.chats.isEmpty) {
                      return const Center(
                        child: Text("No chats yet"),
                      );
                    }

                    return ListView.separated(
                      itemCount: provider.chats.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final chat = provider.chats[index];

                        return ChatListItem(
                          chat: chat,
                          onTap: () {
                            provider.markChatAsOpened(chat.id);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatDetails(chatId: chat.id),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}