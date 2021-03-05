import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/empty_widget.dart';

class SavedPostPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(SavedPostPage()));
  }

  @override
  _SavedPostPageState createState() => _SavedPostPageState();
}

class _SavedPostPageState extends State<SavedPostPage> {
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
    return Scaffold(
      appBar: AppBar1(
        bgColor: Colors.white,
        title: 'Kho lưu trữ',
        automaticallyImplyLeading: true,
      ),
      body: _postBloc.savePosts == null
          ? kLoadingSpinner
          : (_postBloc.savePosts.length != 0
              ? ListView.separated(
                  itemCount: _postBloc.savePosts.length,
                  itemBuilder: (context, index) {
                    final post = _postBloc.savePosts[index];
                    return PostSmallWidget(post);
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 15),
                )
              : EmptyWidget(
                  assetImg: 'assets/image/no_post.png',
                  content: 'Kho lưu trữ trống.',
                )),
    );
  }
}
