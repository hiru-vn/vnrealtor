import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/inbox/inbox_bloc.dart';
import 'package:datcao/modules/inbox/share_friend.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/share/function/share_to.dart';
import 'package:datcao/share/import.dart';

import 'share_pick_list.dart';

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
              _builtTile(
                  MdiIcons.chatOutline, 'Chia sẻ trong tin nhắn', _onShareMessage),
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

  _onShareMessage() async {
    showWaitingDialog(context);
    await InboxBloc.instance.init();
    await navigatorKey.currentState.maybePop();
    final res = await ShareFriendPost.navigate(widget.post);
    if (res) await navigatorKey.currentState.maybePop();
  }

  _onSharePage() async {
    showWaitingDialog(context);
    BaseResponse res = await PagesBloc.instance.getMyPage();
    await navigatorKey.currentState.maybePop();
    if (!res.isSuccess) {
      showToast(res.errMessage, context);
      return;
    }
    final list = res.data as List<PagesCreate>;
    int index = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SharePickList<PagesCreate>('Chọn trang', list,
            (index) => list[index].name, (index) => list[index].avartar);
      },
      backgroundColor: Colors.transparent,
    );
    if (index == null) return;
    showWaitingDialog(context);
    res = await _postBloc.sharePost(widget.post.id, pageId: list[index].id);
    await navigatorKey.currentState.maybePop();
    if (res.isSuccess) {
      await navigatorKey.currentState.maybePop();
      await navigatorKey.currentState.maybePop();
    } else
      showToast(res.errMessage, context);
  }

  _onShareGroup() async {
    final list = GroupBloc.instance.myGroups;
    int index = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SharePickList<GroupModel>('Chọn nhóm', list,
            (index) => list[index].name, (index) => list[index].coverImage);
      },
      backgroundColor: Colors.transparent,
    );
    if (index == null) return;
    showWaitingDialog(context);
    final res =
        await _postBloc.sharePost(widget.post.id, groupId: list[index].id);
    await navigatorKey.currentState.maybePop();
    if (res.isSuccess) {
      await navigatorKey.currentState.maybePop();
      await navigatorKey.currentState.maybePop();
    } else
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
