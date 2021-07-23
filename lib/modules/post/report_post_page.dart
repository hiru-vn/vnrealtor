import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/model/media_post.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/share/import.dart';

showReport(PostModel postModel, BuildContext context) {
  showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
            height: deviceHeight(context) - kToolbarHeight,
            child: ReportPostPage(
              post: postModel,
            ));
      });
}

class ReportPostPage extends StatefulWidget {
  final PostModel post;

  const ReportPostPage({Key key, this.post}) : super(key: key);

  static Future navigate(PostModel post, MediaPost mediaPost) {
    return navigatorKey.currentState.push(pageBuilder(ReportPostPage(
      post: post,
    )));
  }

  @override
  _ReportPostPageState createState() => _ReportPostPageState();
}

class _ReportPostPageState extends State<ReportPostPage> {
  PostBloc _postBloc;
  String _type;
  bool _isLoading = false;
  TextEditingController _contentC = TextEditingController();

  Future _report() async {
    setState(() {
      _isLoading = true;
    });
    final res =
        await _postBloc.createReport(_type, _contentC.text, widget.post.id);
    setState(() {
      _isLoading = false;
    });
    if (res.isSuccess) {
      showToast('Báo cáo của bạn đã được gửi đi, xin cảm ơn.', context,
          isSuccess: true);
    } else {
      showToast(res.errMessage, context);
    }
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      builder: (context, controller) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              'Báo cáo',
              style: TextStyle(color: Colors.black87, fontSize: 17),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(MdiIcons.close),
                onPressed: () {
                  navigatorKey.currentState.maybePop();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  height: 0.6,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        MdiIcons.alert,
                        color: Colors.red,
                        size: 25,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Bài viết vi phạm sau khi báo cáo sẽ được admin xem xét, xóa hoặc cảnh báo nếu vi phạm với điều khoản của chúng tôi.',
                        style: TextStyle(color: Colors.black87),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Vui lòng chọn 1 trong các chủ đề vi phạm.',
                        style: ptTitle().copyWith(color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Wrap(children: [
                        _buildTag('Tin giả', "FAKE"),
                        _buildTag('Trùng lặp', "SPAM"),
                        _buildTag(
                            'Ngôn ngữ không phù hợp', "INAPPROPRIATE_LANGUAGE"),
                        _buildTag('Video/ Hình ảnh không phù hợp',
                            "INAPPROPRIATE_IMAGE_AND_VIDEO"),
                        _buildTag('Lý do khác', "OTHER_REASON"),
                      ]),
                      Divider(
                        height: 15,
                      ),
                      Text(
                        'Chi tiết',
                        style: ptTitle().copyWith(color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: TextField(
                          maxLength: 300,
                          maxLines: null,
                          minLines: 4,
                          controller: _contentC,
                          style: ptBigBody().copyWith(color: Colors.black54),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                'Nhập lý do bạn cho rằng bài viết này vi phạm.',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ExpandBtn(
                      isLoading: _isLoading,
                      text: 'Gửi đi',
                      onPress: _type != null ? _report : () {},
                      color: _type != null
                          ? ptPrimaryColor(context).withOpacity(0.9)
                          : Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTag(String title, String value) {
    return GestureDetector(
      onTap: () {audioCache.play('tab3.mp3');
        setState(() {
          _type = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        margin: EdgeInsets.all(10).copyWith(left: 0, top: 0),
        decoration: BoxDecoration(
          color: _type == value ? ptPrimaryColor(context) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: ptBody().copyWith(
              fontWeight: FontWeight.bold,
              color: _type != value ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
