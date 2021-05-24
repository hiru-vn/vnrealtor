import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/share/import.dart';

class MyGroupPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(MyGroupPage()));
  }

  MyGroupPage({Key key}) : super(key: key);

  @override
  _MyGroupPageState createState() => _MyGroupPageState();
}

class _MyGroupPageState extends State<MyGroupPage> {
  GroupBloc _groupBloc;

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: 'Nhóm của bạn',
        textColor: ptPrimaryColor(context),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
          color: ptPrimaryColor(context),
          onRefresh: () async {
            return;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(width: 27),
                    Container(
                      height: 33,
                      width: 33,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ptSecondaryColor(context),
                      ),
                      child: Center(
                        child: Icon(Icons.group),
                      ),
                    ),
                    SizedBox(width: 15),
                    Text('Nhóm bạn quản lý', style: ptTitle()),
                  ],
                ),
                SizedBox(height: 15),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildGroupItem();
                  },
                  itemCount: 2,
                  separatorBuilder: (context, index) => SizedBox(height: 14),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(width: 27),
                    Container(
                      height: 33,
                      width: 33,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ptSecondaryColor(context),
                      ),
                      child: Center(
                        child: Icon(Icons.group),
                      ),
                    ),
                    SizedBox(width: 15),
                    Text('Nhóm bạn đã tham gia', style: ptTitle()),
                  ],
                ),
                SizedBox(height: 15),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildGroupItem();
                  },
                  itemCount: 2,
                  separatorBuilder: (context, index) => SizedBox(height: 14),
                )
              ],
            ),
          )),
    );
  }

  _buildGroupItem() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ptSecondaryColor(context)),
            child: CachedNetworkImage(
              imageUrl: '',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tên group', style: ptTitle()),
              Text(
                'Nội dung mới: 2p trước',
                style: ptTiny(),
              )
            ],
          )
        ],
      ),
    );
  }
}
