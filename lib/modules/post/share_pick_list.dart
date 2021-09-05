import 'package:datcao/share/import.dart';

class SharePickList<T> extends StatelessWidget {
  final String title;
  final List<T> list;
  final String Function(int index) itemTitleBuilder;
  final String Function(int index) itemUrlBuilder;
  final TextEditingController _searchC = TextEditingController();
  SharePickList(
      this.title, this.list, this.itemTitleBuilder, this.itemUrlBuilder);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title:
                Text(title, style: ptBigBody().copyWith(color: Colors.black)),
          ),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            Row(
              children: [
                SizedBox(
                    width: 36,
                    child: Icon(Icons.search, color: Colors.black45)),
                Expanded(
                  child: TextField(
                    controller: _searchC,
                    decoration: InputDecoration(
                        hintText: 'Tìm kiếm tên',
                        border: InputBorder.none,
                        hintStyle: ptBody()),
                  ),
                )
              ],
            ),
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return _buildItem(
                    itemUrlBuilder(index),
                    itemTitleBuilder(index),
                    () => navigatorKey.currentState.maybePop(index));
              },
              separatorBuilder: (context, index) {
                return Divider(
                    height: 1, color: Colors.black12.withOpacity(0.3));
              },
            )
          ]),
        ));
  }

  _buildItem(String url, String title, Function onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap();
        audioCache.play('tab3.mp3');
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 19,
              backgroundImage: url != null
                  ? CachedNetworkImageProvider(url)
                  : AssetImage('assets/image/default_avatar.png'),
            ),
            SizedBox(width: 14),
            Text(title,
                style: ptTitle()
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
