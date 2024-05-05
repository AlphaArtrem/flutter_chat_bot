import 'package:chatgpt/business_layer/common/auth_bloc.dart';
import 'package:chatgpt/business_layer/post_auth/chat_screen/chat_screen_bloc.dart';
import 'package:chatgpt/business_layer/post_auth/conversation/conversation_bloc.dart';
import 'package:chatgpt/data_layer/models/chat/chat_message.dart';
import 'package:chatgpt/data_layer/models/chat/chat_message_role.dart';
import 'package:chatgpt/data_layer/models/chat/conversation.dart';
import 'package:chatgpt/data_layer/models/route_details.dart';
import 'package:chatgpt/presentation_layer/common/base_streamable_theme_view.dart';
import 'package:chatgpt/presentation_layer/post_auth/home/chat_message.dart';
import 'package:chatgpt/presentation_layer/post_auth/home/chat_screen_drawer.dart';
import 'package:chatgpt/presentation_layer/post_auth/home/chat_text_field.dart';
import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Chat screen for conversation with chat bot
class ChatScreen extends StatefulWidget {
  ///Default constructor for [ChatScreen]
  const ChatScreen({super.key});

  ///[RouteDetails]  for [ChatScreen]
  static final RouteDetails route = RouteDetails('chatScreen', '/chatScreen');

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FocusNode _textFieldFocusNode = FocusNode();
  final TextEditingController _textFieldController = TextEditingController();
  final ValueNotifier<bool> _textFieldHasValueNotifier =
      ValueNotifier<bool>(false);
  final ValueNotifier<bool> _textFieldFocusNotifier =
      ValueNotifier<bool>(false);
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _textFieldFocusNode.addListener(_onFocusChange);
    _textFieldController.addListener(_onValueChanged);
  }

  void _onFocusChange() {
    _textFieldFocusNotifier.value = _textFieldFocusNode.hasFocus;
  }

  void _onValueChanged() {
    _textFieldHasValueNotifier.value =
        _textFieldController.value.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BaseStreamableThemeView<ChatScreenBloc, ChatScreenState>(
      builder: (context, themeState, state) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: themeState.primaryBackgroundColor,
          drawer: ChatScreenDrawer(
            onSelect: (conversation) {
              if (conversation != null) {
                serviceLocator.get<ChatScreenBloc>().add(
                      ChatScreenEventLoadConversation(
                        conversation: conversation,
                        onConversationLoaded: () => Future.delayed(
                          const Duration(milliseconds: 50),
                          () => _scrollController.jumpTo(
                            _scrollController.position.maxScrollExtent,
                          ),
                        ),
                      ),
                    );
              } else {
                serviceLocator
                    .get<ChatScreenBloc>()
                    .add(const ChatScreenEventNewChat());
              }
            },
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Column(
                    children: [
                      if (state.messages.isEmpty)
                        _noMessages()
                      else
                        _messages(state),
                      _textFieldAndSendButton(),
                    ],
                  ),
                  _moreOptionButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _moreOptionButton() {
    return MaterialButton(
      elevation: 0.25,
      padding: EdgeInsets.symmetric(vertical: 12.5.h),
      onPressed: () {
        _scaffoldKey.currentState?.openDrawer();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      color: themeService.state.moreButtonColor,
      minWidth: 55.w,
      child: Icon(
        Icons.more_horiz,
        size: 25.r,
      ),
    );
  }

  Widget _noMessages() {
    final themeState = themeService.state;
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _textFieldFocusNotifier,
            builder: (context, hasFocus, _) {
              if (hasFocus || _textFieldHasValueNotifier.value) {
                return const SizedBox.shrink();
              } else {
                return Text(
                  'ChatGPT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeState.primaryTextColor,
                    fontSize: 24.sp,
                  ),
                );
              }
            },
          ),
          Icon(
            Icons.circle,
            size: 30.r,
            color: themeState.primaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget _textFieldAndSendButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ValueListenableBuilder<bool>(
        valueListenable: _textFieldHasValueNotifier,
        builder: (context, hasValue, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                hasValue ? CrossAxisAlignment.end : CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ValueListenableBuilder<bool>(
                  builder: (context, isFocused, _) => ChatTextField(
                    hasValue: hasValue,
                    isFocused: isFocused,
                    textFieldController: _textFieldController,
                    textFieldFocusNode: _textFieldFocusNode,
                    isLoading:
                        serviceLocator.get<ChatScreenBloc>().state.isLoading,
                  ),
                  valueListenable: _textFieldFocusNotifier,
                ),
              ),
              SizedBox(width: 10.w),
              _sendButton(hasValue),
            ],
          );
        },
      ),
    );
  }

  Widget _sendButton(bool hasValue) {
    final themeState = themeService.state;
    return InkWell(
      onTap: () => _onSend(hasValue),
      child: CircleAvatar(
        radius: 15.r,
        backgroundColor: themeState.sendButtonColor.withOpacity(
          hasValue || serviceLocator.get<ChatScreenBloc>().state.isLoading
              ? 1
              : 0.5,
        ),
        child: Icon(
          serviceLocator.get<ChatScreenBloc>().state.isLoading
              ? Icons.stop
              : Icons.arrow_upward,
          color: themeState.primaryBackgroundColor,
          size: 20.r,
        ),
      ),
    );
  }

  void _onSend(bool hasValue) {
    if (hasValue) {
      if (_textFieldFocusNode.hasFocus) {
        _textFieldFocusNode.unfocus();
      }
      serviceLocator.get<ChatScreenBloc>().add(
            ChatScreenEventAddMessage(
              chatMessage: ChatMessage(
                role: ChatMessageRole.user,
                content: _textFieldController.text,
              ),
              userID: (authService.state as AuthStateLoggedIn).user.userId,
              onMessageAdded: () {
                Future.delayed(
                  const Duration(milliseconds: 50),
                  () => _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent),
                );
              },
              onBotMessageGenerated: _onBotMessageGenerated,
            ),
          );
      _textFieldController.clear();
    }
  }

  void _onBotMessageGenerated() {
    final conversationBloc = serviceLocator.get<ConversationBloc>();
    final state = serviceLocator.get<ChatScreenBloc>().state;
    if (state is ChatScreenStateInProgress) {
      final conversations = [
        Conversation(
          id: state.id,
          chatName: state.name,
          lastActive: DateTime.now().millisecondsSinceEpoch,
          messages: state.messages,
        ),
      ];
      if (conversationBloc.state is ConversationStateLoaded) {
        conversations.addAll(
          (conversationBloc.state as ConversationStateLoaded).conversations
            ..removeWhere(
              (element) => element.id == state.id,
            ),
        );
      }
      conversationBloc.add(
        ConversationEventUpdate(conversations: conversations),
      );
    }
  }

  Widget _messages(ChatScreenState state) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(
          top: 30.h,
        ),
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: state.messages.length,
        itemBuilder: (context, index) {
          return ChatMessageWidget(
            index: index,
            onAnimate: () {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            },
            bloc: serviceLocator.get<ChatScreenBloc>(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _textFieldFocusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _textFieldFocusNotifier.dispose();

    _textFieldController
      ..removeListener(_onValueChanged)
      ..dispose();
    _textFieldHasValueNotifier.dispose();

    super.dispose();
  }
}
