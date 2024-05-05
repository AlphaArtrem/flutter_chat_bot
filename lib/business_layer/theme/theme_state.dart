part of 'theme_cubit.dart';

///App theme state
class ThemeState extends Equatable {
  ///Default constructor for [ThemeState] takes in [isLight] parameter to
  ///determine app colors accordingly
  ThemeState({required this.isLight}) {
    primaryBackgroundColor = isLight ? Colors.white : Colors.black;
    primaryTextColor = isLight ? Colors.black : Colors.white;
    primaryBorderColor = isLight ? Colors.grey : Colors.white70;
    primaryLinkColor = isLight ? Colors.blue : Colors.blueGrey;
    errorColor = isLight ? Colors.red : Colors.redAccent;
    activeOTPBoxColor = isLight ? Colors.blue : Colors.white;
    sendButtonColor = isLight ? Colors.indigo : Colors.white;
    moreButtonColor = isLight ? const Color(0xFFF6F6F6) : Colors.white;
  }

  ///[isLight] parameter determines app colors according to
  ///light and dark themes
  final bool isLight;

  ///Main background color for app
  late final Color primaryBackgroundColor;

  ///Main text color for app
  late final Color primaryTextColor;

  ///Main border color for app
  late final Color primaryBorderColor;

  ///Main link color for app
  late final Color primaryLinkColor;

  ///Error color for app
  late final Color errorColor;

  ///Error color for app
  late final Color activeOTPBoxColor;

  ///Send button color
  late final Color sendButtonColor;

  ///More options button color
  late final Color moreButtonColor;

  @override
  List<Object?> get props => [isLight];
}
