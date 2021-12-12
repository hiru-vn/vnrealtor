import 'package:datcao/share/import.dart';

class CoordinatesInput extends StatefulWidget {
  final List<LatLng> coordinates;
  CoordinatesInput({this.coordinates = const <LatLng>[]});

  @override
  _CoordinatesInputState createState() => _CoordinatesInputState();
}

class _CoordinatesInputState extends State<CoordinatesInput> {
  final _formKey = GlobalKey<FormState>();
  final divider = Divider(height: 1, color: Colors.black12.withOpacity(0.3));
  String? selectedType;
  String? selectedNeed;
  int itemCount = 4;
  List<TextEditingController> controllersX = [];
  List<TextEditingController> controllersY = [];
  List<LatLng> coordinates = [];
  String type = 'VN2000';

  @override
  void initState() {
    super.initState();

    coordinates = <LatLng>[...widget.coordinates];
    if (widget.coordinates.length > itemCount) {
      itemCount = widget.coordinates.length;
    }
    for (int i = 0; i < itemCount; i++) {
      controllersX.add(TextEditingController(
          text: coordinates.length > i
              ? _getCoordinateString(coordinates[i].latitude)
              : ''));
      controllersY.add(TextEditingController(
          text: coordinates.length > i
              ? _getCoordinateString(coordinates[i].longitude)
              : ''));
    }
  }

  String _getCoordinateString(double i) {
    return i.toStringAsFixed(10).toString();
  }

  _onDone() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final List<LatLng> list = <LatLng>[];
    for (int i = 0; i < itemCount; i++) {
      list.add(LatLng(
        double.tryParse(controllersX[i].text) ?? 0.0,
        double.tryParse(controllersY[i].text) ?? 0.0,
      ));
    }
    navigatorKey.currentState!.pop(list);
  }

  @override
  Widget build(BuildContext context) {
    double height =
        400 + MediaQuery.of(context).viewInsets.bottom + (itemCount - 4) * 45;
    if (height > deviceHeight(context)) height = deviceHeight(context);
    return Column(
      children: [
        Expanded(
            child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => navigatorKey.currentState!.maybePop(),
          child: Container(
            width: deviceWidth(context),
          ),
        )),
        Container(
          height: height,
          padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text('Nhập toạ độ',
                  style: ptBigBody().copyWith(color: Colors.black)),
              actions: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _onDone();
                    audioCache.play('tab3.mp3');
                  },
                  child: Center(
                    child: SizedBox(
                      width: 50,
                      child: Text(
                        'Xong',
                        style: ptTitle(),
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(3),
                        margin: EdgeInsets.symmetric(horizontal: 30)
                            .copyWith(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(() {
                                    type = 'VN2000';
                                  });
                                },
                                child: Container(
                                  height: 38,
                                  decoration: type == 'VN2000'
                                      ? BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )
                                      : null,
                                  child: Center(
                                      child: Text(
                                    'Toạ độ VN2000',
                                    style: ptBody().copyWith(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600),
                                  )),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(() {
                                    type = 'GPS';
                                  });
                                },
                                child: Container(
                                  height: 38,
                                  decoration: type == 'GPS'
                                      ? BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )
                                      : null,
                                  child: Center(
                                      child: Text(
                                    'Toạ độ GPS',
                                    style: ptBody().copyWith(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SpacingBox(h: 2),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _buildItem(index),
                        separatorBuilder: (_, __) => divider,
                        itemCount: itemCount),
                    divider,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          controllersX.add(TextEditingController());
                          controllersY.add(TextEditingController());
                          itemCount++;
                        });
                      },
                      child: Container(
                        height: 44,
                        width: deviceWidth(context),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        color: Colors.white,
                        child: Center(
                          child: Text('+ Thêm điểm'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: MediaQuery.of(context).viewInsets.bottom,
        // )
      ],
    );
  }

  _buildItem(int i) {
    final index = i + 1;
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: 25),
          Container(
            width: 30,
            child: Text(index.toString(),
                style: ptBigBody().copyWith(color: Colors.black)),
          ),
          Container(
            width: 1,
            margin: EdgeInsets.all(5),
            color: Colors.black26,
          ),
          Expanded(
            child: TextFormField(
              style: ptBigBody().copyWith(color: Colors.black),
              controller: controllersX[i],
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Toạ độ X$index',
                hintStyle: ptBody().copyWith(color: Colors.black38),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 1,
            margin: EdgeInsets.all(5),
            color: Colors.black26,
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              style: ptBigBody().copyWith(color: Colors.black),
              controller: controllersY[i],
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Toạ độ Y$index',
                hintStyle: ptBody().copyWith(color: Colors.black38),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
