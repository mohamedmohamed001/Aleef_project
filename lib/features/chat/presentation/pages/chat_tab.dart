import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/session_service.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/ai_assistant/presentation/widgets/chatbot_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../provider/chat_provider.dart';
import '../widgets/chat_empty_state.dart';
import '../widgets/chat_error_state.dart';
import '../widgets/chat_list_item.dart';
import '../widgets/chat_loading_list.dart';
import '../widgets/chat_section_title.dart';
import '../widgets/chat_tab_header.dart';
import 'chat_details.dart';

enum ChatTabMode {
  user,
  doctor,
}

class ChatTab extends StatefulWidget {
  final ChatTabMode mode;

  const ChatTab({
    super.key,
    this.mode = ChatTabMode.user,
  });

  bool get isDoctor => mode == ChatTabMode.doctor;
  bool get isUser => mode == ChatTabMode.user;

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> with WidgetsBindingObserver {
  bool _didLoadChats = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _loadChatsOnce();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (!mounted) return;

    final provider = context.read<ChatProvider>();

    provider.listenToChatUpdates();

    if (provider.currentChatId != null && provider.currentChatId!.isNotEmpty) {
      provider.restoreOpenedChat(provider.currentChatId!);
    }
  }

  void _loadChatsOnce() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _didLoadChats) return;

      _didLoadChats = true;
      await _loadChats();
    });
  }

  Future<void> _loadChats() async {
    final isAuthorized = await context.read<ChatProvider>().getChats();

    if (!mounted) return;

    if (!isAuthorized) {
      await _logoutAndGoLogin();
    }
  }

  Future<void> _logoutAndGoLogin() async {
    if (widget.isDoctor) {
      context.read<SessionService>().clearDoctorSession();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.doctorLogin,
            (_) => false,
      );

      return;
    }

    final storage = SecureStorageService();

    await storage.deleteToken();
    await storage.deleteUser();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
          (_) => false,
    );
  }

  void _openChat(String chatId) {
    context.read<ChatProvider>().markChatAsOpened(chatId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetails(chatId: chatId),
      ),
    );
  }

  void _openChatbot() {
    Navigator.pushNamed(
      context,
      AppRoutes.chatBotScreen,
    );
  }

  String get _sectionTitle {
    if (widget.isDoctor) {
      return 'User chats';
    }

    return 'Doctors chats';
  }

  String get _sectionSubtitle {
    if (widget.isDoctor) {
      return 'Continue your conversations with pet owners.';
    }

    return 'Continue your conversations with trusted doctors.';
  }

  EdgeInsets get _listPadding {
    return EdgeInsets.fromLTRB(18.w, 0, 18.w, 100.h);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      body: SafeArea(
        child: Consumer<ChatProvider>(
          builder: (context, provider, _) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _loadChats,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ChatTabHeader(),

                          if (widget.isUser) ...[
                            SizedBox(height: 18.h),
                            ChatBotCard(
                              onTap: _openChatbot,
                            ),
                            SizedBox(height: 20.h),
                          ] else ...[
                            SizedBox(height: 20.h),
                          ],

                          ChatSectionTitle(
                            title: _sectionTitle,
                            subtitle: _sectionSubtitle,
                            count: provider.chats.length,
                            isLoading: provider.isChatsLoading,
                          ),

                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),

                  if (provider.isChatsLoading)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      sliver: const ChatLoadingList(),
                    )
                  else if (provider.errorMessage != null)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: ChatErrorState(
                        message: provider.errorMessage!,
                        onRetry: _loadChats,
                      ),
                    )
                  else if (provider.chats.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: ChatEmptyState(
                          title: widget.isDoctor
                              ? 'No user chats yet'
                              : 'No doctor chats yet',
                          subtitle: widget.isDoctor
                              ? 'When pet owners message you, their chats will appear here.'
                              : 'When you start chatting with doctors, your conversations will appear here.',
                        ),
                      )
                    else
                      SliverPadding(
                        padding: _listPadding,
                        sliver: SliverList.separated(
                          itemCount: provider.chats.length,
                          separatorBuilder: (_, _) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final chat = provider.chats[index];

                            return ChatListItem(
                              chat: chat,
                              onTap: () => _openChat(chat.id),
                            );
                          },
                        ),
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}