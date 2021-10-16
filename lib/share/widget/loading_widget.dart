import '../import.dart';

class SearchingWidget extends StatelessWidget {
  final String? assetUrl;

  const SearchingWidget({Key? key, this.assetUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: deviceWidth(context) / 1.5,
          child: Image.asset(assetUrl ?? 'assets/image/searching_post.gif'),
        ),
        SpacingBox(h: 5),
      ],
    ));
  }
}
