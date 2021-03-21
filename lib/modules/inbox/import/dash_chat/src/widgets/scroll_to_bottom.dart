part of dash_chat;

class ScrollToBottom extends StatelessWidget {
  final Function onScrollToBottomPress;
  final ScrollController scrollController;
  final bool inverted;
  final ScrollToBottomStyle scrollToBottomStyle;

  ScrollToBottom({
    this.onScrollToBottomPress,
    this.scrollController,
    this.inverted,
    this.scrollToBottomStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scrollToBottomStyle.width,
      height: scrollToBottomStyle.height,
      child: RawMaterialButton(
        elevation: 5,
        fillColor: scrollToBottomStyle.backgroundColor ?? Colors.white,
        shape: CircleBorder(),
        child: Icon(
          scrollToBottomStyle.icon ?? Icons.keyboard_arrow_down,
          color: scrollToBottomStyle.textColor ?? ptPrimaryColor(context),
        ),
        onPressed: () {
          if (onScrollToBottomPress != null) {
            onScrollToBottomPress();
          } else {
            scrollController.animateTo(
              inverted ? 0.0 : scrollController.position.maxScrollExtent + 25.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
    );
  }
}
