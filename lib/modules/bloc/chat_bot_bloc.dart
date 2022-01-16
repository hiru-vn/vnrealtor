import 'dart:math';

import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/inbox/import/dash_chat/dash_chat.dart';
import 'package:datcao/modules/model/bot_message.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/post/create/create_post_page.dart';
import 'package:datcao/modules/repo/chat_bot_repo.dart';
import 'package:datcao/modules/repo/post_repo.dart';
import 'package:datcao/share/import.dart';

class ChatBotBloc extends ChangeNotifier {
  ChatBotBloc._privateConstructor();
  static final ChatBotBloc instance = ChatBotBloc._privateConstructor();

  final GlobalKey<DashChatState> chatViewKey = GlobalKey<DashChatState>();
  List<ChatMessage> messages = <ChatMessage>[];
  final ChatUser me = ChatUser(
      uid: AuthBloc.instance.userModel!.id,
      name: AuthBloc.instance.userModel!.name,
      containerColor: HexColor('#4D94FF'),
      avatar: AuthBloc.instance.userModel!.avatar);
  final ChatUser bot = ChatUser(
      uid: 'bot',
      name: 'Bot',
      containerColor: Colors.blue[50],
      avatar: 'assets/image/chat_bot.png');
  bool sending = false;
  ChatMessage? sendingMessage;

  void init() {
    sendingMessage = ChatMessage(text: 'Đang nhập...', user: bot);
    if (messages.length == 0)
      messages.add(ChatMessage(
          text:
              'Chào ${me.name}, tôi có thể giúp bạn tiếp cận với các bài viết phù hợp, hãy thử nhắn tin với nhau nhé!',
          user: bot));
  }

  void clear() {
    messages.clear();
    init();
    notifyListeners();
  }

  void scrollToEnd() {
    if ((chatViewKey.currentState?.scrollController?.position.pixels ?? 0) <
        (chatViewKey.currentState?.scrollController?.position.maxScrollExtent ??
            1))
      chatViewKey.currentState?.scrollController?.animateTo(
        chatViewKey.currentState!.scrollController!.position.maxScrollExtent +
            100,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 250),
      );
  }

  Future<BaseResponse> sendMessCB(ChatMessage message) async {
    try {
      messages.add(message);
      sending = true;
      notifyListeners();
      await Future.delayed(Duration(seconds: 1));
      messages.add(sendingMessage!);
      notifyListeners();
      Future.delayed(Duration(milliseconds: 300), () => scrollToEnd());
      // await Future.delayed(Duration(seconds: Random().nextInt(1) + 1));
      final res = await ChatBotRepo().sendMessCB(message.text);
      final botMessage = ChatBotMessage.fromJson(res);
      if (botMessage.type == 'CREATE_POST') {
        navigatorKey.currentState!
            .push(pageBuilder(CreatePostPage(PageController())));
      }
      final botChat = ChatMessage(
          text: botMessage.text ?? '', user: bot, image: botMessage.image);
      if (botMessage.postIds != null) {
        botChat.postIds =
            botMessage.postIds!.sublist(0, min(botMessage.postIds!.length, 4));
        updateBotChatPost(botChat);
      }
      messages.add(botChat);
      Future.delayed(Duration(milliseconds: 300), () => scrollToEnd());
      return BaseResponse.success(botMessage);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      sending = false;
      messages.removeWhere((element) => element == sendingMessage);
      notifyListeners();
    }
  }

  Future<BaseResponse> updateBotChatPost(ChatMessage botChat) async {
    try {
      final res = await PostRepo().getPostList(botChat.postIds!);
      final List listRaw = res['data'];
      final posts = listRaw.map((e) => PostModel.fromJson(e)).toList();
      final botChatItem = messages[messages.length - 1];
      botChatItem.posts = posts;
      return BaseResponse.success(botChat);
    } catch (e) {
      final botChatItem = messages.firstWhere((element) => element == botChat);
      botChatItem.postIds = [];
      return BaseResponse.fail(e.toString());
    } finally {
      sending = false;
      notifyListeners();
    }
  }
}
