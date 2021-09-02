import 'package:datcao/share/import.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ptPrimaryColor(context),
      child: SafeArea(
        child: Scaffold(
          appBar: SecondAppBar(
            title: "Tìm kiếm",
          ),
        ),
      ),
    );
  }
}
