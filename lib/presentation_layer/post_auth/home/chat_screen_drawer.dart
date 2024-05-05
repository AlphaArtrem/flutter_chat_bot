import 'package:chatgpt/business_layer/common/auth_bloc.dart';
import 'package:chatgpt/business_layer/post_auth/chat_screen/chat_screen_bloc.dart';
import 'package:chatgpt/business_layer/post_auth/conversation/conversation_bloc.dart';
import 'package:chatgpt/data_layer/models/chat/conversation.dart';
import 'package:chatgpt/presentation_layer/common/base_streamable_theme_view.dart';
import 'package:chatgpt/presentation_layer/pre_auth/auth_screen.dart';
import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreenDrawer extends StatefulWidget {
  const ChatScreenDrawer({required this.onSelect, super.key});

  final void Function(Conversation?) onSelect;

  @override
  State<ChatScreenDrawer> createState() => _ChatScreenDrawerState();
}

class _ChatScreenDrawerState extends State<ChatScreenDrawer> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(_scrollListener);
    });
    if (serviceLocator.get<ConversationBloc>().state
        is! ConversationStateLoaded) {
      _initData();
    }
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent - 200) {
      _initData();
    }
  }

  void _initData() {
    serviceLocator.get<ConversationBloc>().add(
          ConversationEventLoad(
            userID: (authService.state as AuthStateLoggedIn).user.userId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BaseStreamableThemeView<ConversationBloc, ConversationState>(
      bloc: serviceLocator.get<ConversationBloc>(),
      builder: (context, themeState, state) {
        return Drawer(
          backgroundColor: themeState.primaryBackgroundColor,
          child: Padding(
            padding: EdgeInsets.all(10.r),
            child: state is ConversationStateInitial
                ? _loadingState(state)
                : _loadedState(state as ConversationStateLoaded),
          ),
        );
      },
    );
  }

  Widget _loadingState(ConversationStateInitial state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.error.isEmpty ? 'Something went wrong' * 5 : state.error,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: themeService.state.errorColor,
              fontSize: 17.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          InkWell(
            onTap: () => serviceLocator.get<ConversationBloc>()
              ..add(
                ConversationEventLoad(
                  userID: (authService.state as AuthStateLoggedIn).user.userId,
                ),
              ),
            child: const Icon(Icons.refresh),
          ),
        ],
      );
    }
  }

  Widget _loadedState(ConversationStateLoaded state) {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        return index > state.conversations.length
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: const CircularProgressIndicator(),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: themeService.state.primaryBorderColor
                          .withOpacity(0.25),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          navigationService.pop();
                          widget.onSelect(index == 0
                              ? null
                              : state.conversations[index - 1]);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Text(
                            index == 0
                                ? 'Start New Chat'
                                : state.conversations[index - 1].chatName,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: index == 0
                                  ? themeService.state.primaryLinkColor
                                  : themeService.state.primaryTextColor,
                              fontSize: 17.sp,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                    if (index == 0)
                      IconButton(
                        onPressed: () => authService.add(
                          AuthEventLogOut(
                            ({required success}) {
                              if (success) {
                                serviceLocator
                                    .get<ChatScreenBloc>()
                                    .add(const ChatScreenEventNewChat());
                                serviceLocator.get<ConversationBloc>().add(
                                      const ConversationEventReset(),
                                    );
                                navigationService.goToRoute(AuthScreen.route);
                              } else {
                                navigationService
                                  ..pop()
                                  ..showSnackBar(
                                      "Something went wrong, can't logout");
                              }
                            },
                          ),
                        ),
                        icon: const Icon(Icons.logout),
                      ),
                  ],
                ),
              );
      },
      itemCount: state.conversations.length + (state.isLoading ? 2 : 1),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}
