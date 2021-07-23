import 'package:datcao/share/import.dart';

class InfoPostPage extends StatefulWidget {
  InfoPostPage();

  @override
  _InfoPostPageState createState() => _InfoPostPageState();
}

class _InfoPostPageState extends State<InfoPostPage> {
  final _formKey = GlobalKey<FormState>();
  final divider = Divider(height: 1, color: Colors.black12.withOpacity(0.3));
  final TextEditingController _priceC = TextEditingController();
  final TextEditingController _areaC = TextEditingController();
  String selectedType;
  String selectedNeed;

  _onDone() {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    navigatorKey.currentState.pop([
      selectedType,
      selectedNeed,
      double.parse(_areaC.text.replaceAll(',', '')),
      double.parse(_priceC.text.replaceAll(',', '')),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('Thông tin thêm',
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
                divider,
                Container(
                  width: deviceWidth(context),
                  color: ptSecondaryColor(context),
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    'Phân loại bất động sản',
                    style: ptTitle().copyWith(letterSpacing: 0.2),
                  ),
                ),
                Column(
                  children: [
                    _buildItem('Nhà ở', selectedType, _onTapType),
                    divider,
                    _buildItem('Căn hộ/chung cư', selectedType, _onTapType),
                    divider,
                    _buildItem('Đất đai', selectedType, _onTapType),
                    divider,
                    _buildItem('Văn phòng', selectedType, _onTapType),
                    divider,
                    _buildItem('Mặt bằng kinh doanh', selectedType, _onTapType),
                    divider,
                    _buildItem('Phòng trọ', selectedType, _onTapType)
                  ],
                ),
                Container(
                  width: deviceWidth(context),
                  color: ptSecondaryColor(context),
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    'Phân loại theo nhu cầu',
                    style: ptTitle().copyWith(letterSpacing: 0.2),
                  ),
                ),
                Column(
                  children: [
                    _buildItem('Cần bán', selectedNeed, _onTapNeed),
                    divider,
                    _buildItem('Cần mua', selectedNeed, _onTapNeed),
                    divider,
                    _buildItem('Cho thuê', selectedNeed, _onTapNeed),
                    divider,
                    _buildItem('Cần Thuê', selectedNeed, _onTapNeed),
                  ],
                ),
                Container(
                  width: deviceWidth(context),
                  color: ptSecondaryColor(context),
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    'Diện tích',
                    style: ptTitle().copyWith(letterSpacing: 0.2),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                        width: 50,
                        child: Icon(MdiIcons.officeBuildingOutline,
                            color: Colors.black45)),
                    Expanded(
                      child: TextFormField(
                        controller: _areaC,
                        onChanged: (val) => setState(() {}),
                        keyboardType: TextInputType.number,
                        inputFormatters: [ThousandsSeparatorInputFormatter()],
                        validator: TextFieldValidator.numberValidator,
                        decoration: InputDecoration(
                            hintText: 'Nhập diện tích',
                            suffixText: 'M2',
                            suffixStyle:
                                ptBody().copyWith(color: Colors.black87),
                            border: InputBorder.none,
                            hintStyle:
                                ptBody().copyWith(color: Colors.black38)),
                      ),
                    ),
                    SizedBox(width: 20)
                  ],
                ),
                Container(
                  width: deviceWidth(context),
                  color: ptSecondaryColor(context),
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    'Giá bán / giá cho thuê',
                    style: ptTitle().copyWith(letterSpacing: 0.2),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                        width: 50,
                        child: Icon(Icons.money_sharp, color: Colors.black45)),
                    Expanded(
                      child: TextFormField(
                        controller: _priceC,
                        onChanged: (val) => setState(() {}),
                        validator: TextFieldValidator.numberValidator,
                        keyboardType: TextInputType.number,
                        inputFormatters: [ThousandsSeparatorInputFormatter()],
                        decoration: InputDecoration(
                            hintText: 'Nhập giá bán/ giá thuê',
                            suffixText: 'VNĐ',
                            suffixStyle:
                                ptBody().copyWith(color: Colors.black87),
                            border: InputBorder.none,
                            hintStyle:
                                ptBody().copyWith(color: Colors.black38)),
                      ),
                    ),
                    SizedBox(width: 15)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onTapType(String value) {
    setState(() {
      selectedType = value;
    });
  }

  _onTapNeed(String value) {
    setState(() {
      selectedNeed = value;
    });
  }

  _buildItem(String value, String selectedValue, Function(String) onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap(value);
      audioCache.play('tab3.mp3');
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(width: 25),
            Text(value, style: ptBody().copyWith(color: Colors.black)),
            Spacer(),
            if (value == selectedValue)
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ptPrimaryColor(context).withOpacity(0.8)),
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            SizedBox(width: 25),
          ],
        ),
      ),
    );
  }
}
