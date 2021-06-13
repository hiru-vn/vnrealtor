import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/share/function/share_to.dart';
import 'package:datcao/share/import.dart';

class SharePost extends StatefulWidget {
  final PostModel post;
  SharePost(this.post, {Key key}) : super(key: key);

  @override
  _SharePostState createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  PostBloc _postBloc;

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 5,
          width: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.5), color: Colors.white),
        ),
        SizedBox(height: 7),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          padding: EdgeInsets.all(15).copyWith(bottom: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _builtTile(Icons.add_circle_outline_rounded,
                  'Chia sẻ trên trang cá nhân', _onShareUser),
              _builtTile(MdiIcons.chatOutline, 'Chia sẻ trong tin nhắn',
                  _onShareGroup),
              _builtTile(Icons.flag_outlined, 'Chia sẻ trên trang của tôi',
                  _onSharePage),
              _builtTile(MdiIcons.accountGroupOutline,
                  'Chia sẻ vào nhóm tôi tham gia', _onShareGroup),
              _builtTile(MdiIcons.apps, 'Chia sẻ lên các ứng dụng khác',
                  _onShareOther),
            ],
          ),
        ),
      ],
    );
  }

  _onShareUser() async {
    showWaitingDialog(context);
    final res = await _postBloc.sharePost(widget.post.id);
    navigatorKey.currentState.maybePop();
    if (res.isSuccess)
      navigatorKey.currentState.maybePop();
    else
      showToast(res.errMessage, context);
  }

  _onSharePage() async {
    showWaitingDialog(context);
    final res = await _postBloc.sharePost(widget.post.id);
    navigatorKey.currentState.maybePop();
    if (res.isSuccess)
      navigatorKey.currentState.maybePop();
    else
      showToast(res.errMessage, context);
  }

  _onShareGroup() async {
    showWaitingDialog(context);
    final res = await _postBloc.sharePost(widget.post.id);
    navigatorKey.currentState.maybePop();
    if (res.isSuccess)
      navigatorKey.currentState.maybePop();
    else
      showToast(res.errMessage, context);
  }

  _onShareOther() async {
    await navigatorKey.currentState.maybePop();
    String content = widget.post.dynamicLink?.shortLink ?? '';
    content = content + '\n' + widget.post.content;
    shareTo(context,
        content: content,
        image: widget.post.mediaPosts
            .where((element) => element.type == 'PICTURE')
            .map((e) => e.url)
            .toList(),
        video: widget.post.mediaPosts
            .where((element) => element.type == 'VIDEO')
            .map((e) => e.url)
            .toList());
  }

  Widget _builtTile(IconData icon, String text, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Icon(icon, size: 24),
            SizedBox(width: 15),
            Expanded(
                child: Text(text,
                    style: ptTitle()
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 14))),
          ],
        ),
      ),
    );
  }
}
