import 'dart:io';

import 'package:chatgpt/business_layer/common/auth_bloc.dart';
import 'package:chatgpt/business_layer/post_auth/chat_screen/chat_screen_bloc.dart';
import 'package:chatgpt/data_layer/models/chat/chat_message_role.dart';
import 'package:chatgpt/data_layer/models/user_auth/user_auth_model_google.dart';
import 'package:chatgpt/data_layer/static/svg_string_assets.dart';
import 'package:chatgpt/presentation_layer/common/animations/animated_cupertino_context_menu_dialog.dart';
import 'package:chatgpt/presentation_layer/common/animations/type_writer_text.dart';
import 'package:chatgpt/presentation_layer/post_auth/home/selectable_text_bottom_sheet.dart';
import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Widget to show each chat message independently including user name, message
///and animation
class ChatMessageWidget extends StatelessWidget {
  ///[ChatMessageWidget] constructor
  ChatMessageWidget({
    required this.bloc,
    required this.index,
    this.onAnimate,
    super.key,
  }) {
    final message = bloc.state.messages[index];
    final isFromUser = message.role == ChatMessageRole.user;
    isFromBot = !isFromUser;
    animate = bloc.state is ChatScreenStateInProgress
        ? (index >=
                (bloc.state as ChatScreenStateInProgress)
                    .loadedMessagesLength &&
            bloc.state.messages[index].role != ChatMessageRole.user)
        : !isFromUser;
    isError = message.isError;
  }

  ///Index of the chat message
  final int index;

  ///[ChatScreenBloc] for managing chat
  final ChatScreenBloc bloc;

  ///Weather to animate text or not using [TypeWriterText]
  late final bool animate;

  ///Is message from user or chat bot
  late final bool isFromBot;

  ///Does the message contain an error to display
  late final bool isError;

  ///Listener for animated text controller
  final VoidCallback? onAnimate;

  ///[text] message to display
  String get text => bloc.state.messages[index].content;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => _showContextMenu(context),
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _avatarAndName(),
            Padding(
              padding: EdgeInsets.only(left: 6.r + 31.sp),
              child: _text(),
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AnimatedCupertinoContextMenuDialog(
          options: [
            AnimatedCupertinoContextMenuOption(
              text: 'Copy',
              icon: Icons.file_copy_outlined,
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                navigationService.pop();
                if (Platform.isIOS) {
                  navigationService.showSnackBar('Text copied to clipboard!');
                }
              },
            ),
            AnimatedCupertinoContextMenuOption(
              text: 'Select Text',
              icon: Icons.crop,
              onTap: () {
                navigationService.pop();
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  elevation: 5,
                  builder: (context) {
                    return SelectableTextBottomSheet(text);
                  },
                );
              },
            ),
            if (isFromBot) ...[
              AnimatedCupertinoContextMenuOption(
                text: 'Regenerate Response',
                icon: Icons.refresh,
                onTap: () {
                  bloc.add(
                    ChatScreenEventRegenerateResponse(
                      index: index,
                      userID:
                          (authService.state as AuthStateLoggedIn).user.userId,
                    ),
                  );
                  navigationService.pop();
                },
              ),
              AnimatedCupertinoContextMenuOption(
                text: 'Good Response',
                icon: Icons.thumb_up_alt_outlined,
                onTap: () {},
              ),
              AnimatedCupertinoContextMenuOption(
                text: 'Bad Response',
                icon: Icons.thumb_down_alt_outlined,
                onTap: () {},
                border: Border.all(color: Colors.transparent),
              ),
            ],
          ],
          child: _text(
            textOnly: true,
          ),
        );
      },
    );
  }

  Widget _avatarAndName() {
    final themeState = themeService.state;
    final user = (authService.state as AuthStateLoggedIn).user;
    final userNameList =
        user is UserAuthModelGoogle ? user.displayName.split(' ') : ['User'];
    final initials = userNameList.length > 1
        ? (userNameList.first[0] + userNameList.last[0])
        : userNameList.first.length > 1
            ? userNameList.first[0] + userNameList.first[1]
            : 'NA';

    return Row(
      children: [
        if (isFromBot)
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: SvgPicture.string(
              SvgStringAssets.chatGPTIcon,
              height: 24.r,
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: themeState.activeOTPBoxColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              initials.toUpperCase(),
              style: TextStyle(
                color: themeState.primaryBackgroundColor,
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        SizedBox(width: 10.w),
        Text(
          isFromBot ? 'CHATGPT' : userNameList.first.toUpperCase(),
          style: TextStyle(
            color: themeState.primaryTextColor.withOpacity(0.5),
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _text({bool textOnly = false}) {
    final themeState = themeService.state;
    final style = TextStyle(
      fontWeight: FontWeight.w400,
      color: isError ? themeState.errorColor : themeState.primaryTextColor,
      fontSize: 17.sp,
    );
    if (!isFromBot || !animate || textOnly) {
      return Text(
        text,
        style: style,
      );
    } else {
      return TypeWriterText(
        onAnimate: onAnimate,
        text: text,
        cursor: Icon(
          Icons.circle,
          color: themeService.state.primaryTextColor,
          size: 25.r,
        ),
        style: style,
      );
    }
  }
}
