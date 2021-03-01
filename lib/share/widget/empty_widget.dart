import 'package:datcao/share/import.dart';

class EmptyWidget extends StatelessWidget {
  final String assetImg;
  final String title;
  final String content;

  const EmptyWidget(
      {Key key,this.assetImg, this.title, this.content})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (assetImg!=null) SizedBox(
              width: deviceWidth(context) / 1.7, child: Image.asset(assetImg)),
          if (title != null) ...[
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: deviceWidth(context) / 1.25,
              child: Text(
                title,
                style: ptBigTitle(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          if (content != null) ...[
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: deviceWidth(context) / 1.4,
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: ptBody().copyWith(color: Colors.black54),
              ),
            )
          ],
          SpacingBox(h: 5),
        ],
      ),
    );
  }
}
