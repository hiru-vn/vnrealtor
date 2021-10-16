part of dash_chat;

/// MessageContainer is just a wrapper around [Text], [Image]
/// component to present the message
class MessageContainer extends StatelessWidget {
  /// Message Object that will be rendered
  /// Takes a [ChatMessage?] object
  final ChatMessage message;

  /// [DateFormat] object to render the date in desired
  /// format, if no format is provided it use
  /// the default `HH:mm:ss`
  final DateFormat? timeFormat;

  /// [messageTextBuilder] function takes a function with this
  /// structure [Widget Function(String)] to render the text inside
  /// the container.
  final Widget Function(String?, [ChatMessage?])? messageTextBuilder;

  /// [messageImageBuilder] function takes a function with this
  /// structure [Widget Function(String)] to render the image inside
  /// the container.
  final Widget Function(String?, [ChatMessage?])? messageImageBuilder;

  /// [messageTimeBuilder] function takes a function with this
  /// structure [Widget Function(String)] to render the time text inside
  /// the container.
  final Widget Function(String, [ChatMessage?])? messageTimeBuilder;

  /// Provides a custom style to the message container
  /// takes [BoxDecoration]
  final BoxDecoration? messageContainerDecoration;

  /// Used to parse text to make it linkified text uses
  /// [flutter_parsed_text](https://pub.dev/packages/flutter_parsed_text)
  /// takes a list of [MatchText] in order to parse Email, phone, links
  /// and can also add custom pattersn using regex
  final List<MatchText> parsePatterns;

  /// A flag which is used for assiging styles
  final bool? isUser;

  /// Provides a list of buttons to allow the usage of adding buttons to
  /// the bottom of the message
  final List<Widget>? buttons;

  /// [messageButtonsBuilder] function takes a function with this
  /// structure [List<Widget> Function()] to render the buttons inside
  /// a row.
  final List<Widget> Function(ChatMessage)? messageButtonsBuilder;

  /// Constraint to use to build the message layout
  final BoxConstraints? constraints;

  /// Padding of the message
  /// Default to EdgeInsets.all(8.0)
  final EdgeInsets Function(ChatMessage)? messagePaddingBuilder;

  /// Should show the text before the image in the chat bubble
  /// or the opposite
  /// Default to `true`
  final bool textBeforeImage;

  /// overrides the boxdecoration of the message
  /// can be used to override color, or customise the message container
  /// params [ChatMessage?] and [isUser]: boolean
  /// return BoxDecoration
  final BoxDecoration Function(ChatMessage, bool?)? messageDecorationBuilder;

  final double Function(ChatMessage?)? messageContainerWidthRadio;

  const MessageContainer(
      {required this.message,
      required this.timeFormat,
      this.constraints,
      this.messageImageBuilder,
      this.messageTextBuilder,
      this.messageTimeBuilder,
      this.messageContainerDecoration,
      this.parsePatterns = const <MatchText>[],
      this.textBeforeImage = true,
      this.isUser,
      this.messageButtonsBuilder,
      this.buttons,
      this.messagePaddingBuilder,
      this.messageDecorationBuilder,
      this.messageContainerWidthRadio});

  @override
  Widget build(BuildContext context) {
    final constraints = this.constraints ??
        BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: constraints.maxWidth *
            (messageContainerWidthRadio != null
                ? messageContainerWidthRadio!(message)
                : 0.6),
      ),
      child: Container(
        decoration: messageDecorationBuilder != null
            ? messageDecorationBuilder!(message, isUser)
            : messageContainerDecoration != null
                ? messageContainerDecoration!.copyWith(
                    color: message.user!.containerColor != null
                        ? message.user!.containerColor
                        : messageContainerDecoration!.color,
                  )
                : BoxDecoration(
                    color: message.user!.containerColor != null
                        ? message.user!.containerColor
                        : isUser!
                            ? Theme.of(context).accentColor
                            : Color.fromRGBO(225, 225, 225, 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
        margin: EdgeInsets.only(
          bottom: 2.5,
        ),
        padding: messagePaddingBuilder != null
            ? messagePaddingBuilder!(message)
            : EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment:
              isUser! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            if (this.textBeforeImage)
              _buildMessageText()
            else
              _buildMessageImage(),
            if (this.textBeforeImage)
              _buildMessageImage()
            else
              _buildMessageText(),
            _buildMessageUrlLink(),
            if (buttons != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment:
                    isUser! ? MainAxisAlignment.end : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: buttons!,
              )
            else if (messageButtonsBuilder != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment:
                    isUser! ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: messageButtonsBuilder!(message),
                mainAxisSize: MainAxisSize.min,
              ),
            if (messageTimeBuilder != null)
              messageTimeBuilder!(
                timeFormat != null
                    ? timeFormat!.format(message.createdAt!)
                    : DateFormat('HH:mm:ss').format(message.createdAt!),
                message,
              )
            else
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  timeFormat != null
                      ? timeFormat!.format(message.createdAt!)
                      : DateFormat('HH:mm:ss').format(message.createdAt!),
                  style: TextStyle(
                    fontSize: 10.0,
                    color: message.user!.color != null
                        ? message.user!.color
                        : isUser!
                            ? Colors.white70
                            : Colors.black87,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildMessageText() {
    if (messageTextBuilder != null)
      return messageTextBuilder!(message.text, message);
    else
      return ParsedText(
        parse: parsePatterns,
        text: message.text!,
        style: TextStyle(
          color: message.user!.color != null
              ? message.user!.color
              : isUser!
                  ? Colors.white70
                  : Colors.black87,
        ),
      );
  }

  Widget _buildMessageUrlLink() {
    RegExp exp =
        new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(message.text!);
    if (matches.length > 0)
      return UrlPreviewContainer(
        message: message,
      );
    return SizedBox.shrink();
  }

  Widget _buildMessageImage() {
    if (message.image != null) {
      if (messageImageBuilder != null)
        return messageImageBuilder!(message.image, message);
      else
        return Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: FadeInImage.memoryNetwork(
            height: constraints!.maxHeight * 0.3,
            width: constraints!.maxWidth * 0.7,
            fit: BoxFit.contain,
            placeholder: kTransparentImage,
            image: message.image!,
          ),
        );
    }
    return Container(width: 0, height: 0);
  }
}

class UrlPreviewContainer extends StatefulWidget {
  final ChatMessage message;
  UrlPreviewContainer({Key? key, required this.message}) : super(key: key);

  @override
  _UrlPreviewContainerState createState() => _UrlPreviewContainerState();
}

class _UrlPreviewContainerState extends State<UrlPreviewContainer> {
  List<UrlPreviewData> links = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await Future.delayed(Duration(milliseconds: 200));
    RegExp exp =
        new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(widget.message.text!);
    links.clear();
    for (var match in matches) {
      final data = await getUrlData(
          widget.message.text!.substring(match.start, match.end));
      if (data != null) links.add(data);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (links.length == 0) return SizedBox.shrink();
    if (links[0].image == null && links[0].title == null)
      return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: () {
          audioCache.play('tab3.mp3');
          launchURL(links[0].url!);
        },
        child: Column(
          children: [
            if (links[0].image != null)
              CachedNetworkImage(imageUrl: links[0].image!, fit: BoxFit.cover),
            Container(
              color: Colors.grey[100],
              width: double.infinity,
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (links[0].title != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        links[0].title!,
                        style: ptTitle().copyWith(color: Colors.black87),
                      ),
                    ),
                  if (links[0].description != null)
                    Text(
                      links[0].description! +
                          (links[0].siteName != null
                              ? '  - từ ${links[0].siteName}'
                              : ''),
                      style: ptSmall().copyWith(color: Colors.black54),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
