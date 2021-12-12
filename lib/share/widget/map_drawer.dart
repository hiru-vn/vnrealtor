import 'package:datcao/share/import.dart';

class MapDrawer extends StatefulWidget {
  const MapDrawer({Key? key}) : super(key: key);

  @override
  State<MapDrawer> createState() => _MapDrawerState();
}

class _MapDrawerState extends State<MapDrawer> {
  final _formKey = GlobalKey<FormState>();
  final divider = Divider(height: 1, color: Colors.black12.withOpacity(0.3));
  final TextEditingController _priceMinC = TextEditingController();
  final TextEditingController _priceMaxC = TextEditingController();
  final TextEditingController _areaMinC = TextEditingController();
  final TextEditingController _areaMaxC = TextEditingController();
  List<String> selectedTypes = [];
  List<String> selectedNeeds = [];

  _onDone() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    navigatorKey.currentState!.pop([
      selectedTypes,
      selectedNeeds,
      double.parse(_areaMinC.text.replaceAll(',', '')),
      double.parse(_areaMaxC.text.replaceAll(',', '')),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: deviceWidth(context),
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    'Diện tích',
                    style: ptTitle().copyWith(letterSpacing: 0.2),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: 30),
                    Expanded(
                      child: TextFormField(
                        controller: _areaMinC,
                        onChanged: (val) => setState(() {}),
                        keyboardType: TextInputType.number,
                        inputFormatters: [ThousandsSeparatorInputFormatter()],
                        validator: TextFieldValidator.numberValidator,
                        decoration: InputDecoration(
                            hintText: 'Từ',
                            suffixText: 'M2',
                            suffixStyle:
                                ptBody().copyWith(color: Colors.black87),
                            border: InputBorder.none,
                            hintStyle:
                                ptBody().copyWith(color: Colors.black38)),
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: TextFormField(
                        controller: _areaMaxC,
                        onChanged: (val) => setState(() {}),
                        keyboardType: TextInputType.number,
                        inputFormatters: [ThousandsSeparatorInputFormatter()],
                        validator: TextFieldValidator.numberValidator,
                        decoration: InputDecoration(
                            hintText: 'Đến',
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
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    'Loại bất động sản',
                    style: ptTitle().copyWith(letterSpacing: 0.2),
                  ),
                ),
                Wrap(
                  children: [
                    _buildItem('Nhà ở', selectedTypes, _onTapType),
                    _buildItem('Căn hộ/chung cư', selectedTypes, _onTapType),
                    _buildItem('Đất đai', selectedTypes, _onTapType),
                    _buildItem('Văn phòng', selectedTypes, _onTapType),
                    _buildItem('Mặt bằng KD', selectedTypes, _onTapType),
                    _buildItem('Phòng trọ', selectedTypes, _onTapType)
                  ],
                ),
                Container(
                  width: deviceWidth(context),
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    'Nhu cầu',
                    style: ptTitle().copyWith(letterSpacing: 0.2),
                  ),
                ),
                Wrap(
                  children: [
                    _buildItem('Cần bán', selectedNeeds, _onTapNeed),
                    _buildItem('Cần mua', selectedNeeds, _onTapNeed),
                    _buildItem('Cho thuê', selectedNeeds, _onTapNeed),
                    _buildItem('Cần Thuê', selectedNeeds, _onTapNeed),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: RoundedBtn(
                      text: 'Áp dụng',
                      onPressed: () {
                        navigatorKey.currentState!.maybePop();
                      },
                      width: 120,
                      color: ptPrimaryColor(context),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onTapType(String value) {
    if (selectedTypes.contains(value)) {
      selectedTypes.remove(value);
    } else {
      selectedTypes.add(value);
    }
    setState(() {});
  }

  _onTapNeed(String value) {
    if (selectedNeeds.contains(value)) {
      selectedNeeds.remove(value);
    } else {
      selectedNeeds.add(value);
    }
    setState(() {});
  }

  _buildItem(
      String value, List<String> selectedValues, Function(String) onTap) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: selectedValues.contains(value),
            activeColor: ptPrimaryColor(context),
            onChanged: (_) {
              onTap(value);
            },
          ),
          Text(value, style: ptBody().copyWith(color: Colors.black)),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
