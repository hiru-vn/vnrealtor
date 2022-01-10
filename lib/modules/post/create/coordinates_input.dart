import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/model/cadastral.dart';
import 'package:datcao/share/import.dart';

class Vn2000LatLng {
  final double lat;
  final double long;

  Vn2000LatLng(this.lat, this.long);
}

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
  bool isLoading = false;
  Cadastral? selectedCadas;
  int mapZ = 3;

  final List<Vn2000LatLng> temp = [
    Vn2000LatLng(1211447.15, 593285.69),
    Vn2000LatLng(1211452.58, 593284.81),
    Vn2000LatLng(1211448.00, 593260.84),
    Vn2000LatLng(1211442.41, 593261.21),
  ];

  @override
  void initState() {
    super.initState();

    coordinates = <LatLng>[...widget.coordinates];
    if (widget.coordinates.length > itemCount) {
      itemCount = widget.coordinates.length;
    }
    for (int i = 0; i < itemCount; i++) {
      controllersX.add(TextEditingController(
          text: temp.length > i ? _getCoordinateString(temp[i].lat) : ''));
      controllersY.add(TextEditingController(
          text: temp.length > i ? _getCoordinateString(temp[i].long) : ''));
    }
  }

  String _getCoordinateString(double i) {
    return i.toStringAsFixed(2).toString();
  }

  _onDone() async {
    if (selectedCadas == null) {
      showToast('Vui lòng chọn thành phố', context);
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    final List<Vn2000LatLng> list = <Vn2000LatLng>[];

    for (int i = 0; i < itemCount; i++) {
      list.add(Vn2000LatLng(
        double.tryParse(controllersX[i].text) ?? 0.0,
        double.tryParse(controllersY[i].text) ?? 0.0,
      ));
    }

    final listLocation = await Future.wait(list.map((e) async {
      final res = await PostBloc.instance
          .vn2000ToWgs84(selectedCadas!.id!, e.lat, e.long, mapZ);
      return res.data as LatLng;
    }).toList());
    print(listLocation);

    // for (int i = 0; i < itemCount; i++) {
    //   list.add(LatLng(
    //     double.tryParse(controllersX[i].text) ?? 0.0,
    //     double.tryParse(controllersY[i].text) ?? 0.0,
    //   ));
    // }
    setState(() {
      isLoading = false;
    });
    navigatorKey.currentState!.pop(listLocation);
  }

  @override
  Widget build(BuildContext context) {
    double height =
        430 + MediaQuery.of(context).viewInsets.bottom + (itemCount - 4) * 45;
    if (height > deviceHeight(context)) height = deviceHeight(context);
    return IgnorePointer(
      ignoring: isLoading,
      child: Stack(
        children: [
          Column(
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
                    title: Text('Nhập toạ độ VN-2000',
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
                            child: GestureDetector(
                              onTap: () {
                                pickList(context,
                                    options: listCadastral
                                        .map((e) => PickListItem(
                                            e.id, e.tenDiaChinh ?? ''))
                                        .toList(), onPicked: (id) {
                                  if (id != null) {
                                    setState(() {
                                      selectedCadas = listCadastral.firstWhere(
                                          (element) => element.id == id,
                                          orElse: () => listCadastral[0]);
                                    });
                                  }
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(3),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 30)
                                              .copyWith(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 45,
                                      width: deviceWidth(context),
                                      child: Center(
                                          child: Text(
                                        selectedCadas != null
                                            ? selectedCadas!.tenDiaChinh ?? ''
                                            : 'Chọn tỉnh thành',
                                        style: ptTitle(),
                                      ))),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      SizedBox(width: 15),
                                      Text(
                                        'TL bản đồ',
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                              onTap: () => setState(() {
                                                    mapZ = 6;
                                                  }),
                                              child: _buildCheckBox(
                                                  context, mapZ == 6)),
                                          Text('1:5 triệu-1:25 000'),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                              onTap: () => setState(() {
                                                    mapZ = 3;
                                                  }),
                                              child: _buildCheckBox(
                                                  context, mapZ == 3)),
                                          Text('1:10 000 - 1:2000'),
                                        ],
                                      ),
                                      SizedBox(width: 15),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          SpacingBox(h: 2),
                          ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  _buildItem(index),
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
          ),
          if (isLoading) kLoadingSpinner,
        ],
      ),
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

  Widget _buildCheckBox(BuildContext context, bool isSelect) {
    if (!isSelect)
      return Container(
        width: 19,
        height: 19,
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[200]!, width: 2),
        ),
      );
    else
      return Container(
        width: 19,
        height: 19,
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: ptPrimaryColor(context)),
        child: Center(
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 12,
          ),
        ),
      );
  }
}
