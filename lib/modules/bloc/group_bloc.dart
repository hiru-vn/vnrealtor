import 'package:datcao/share/import.dart';

class GroupBloc extends ChangeNotifier {
  GroupBloc._privateConstructor();
  static final GroupBloc instance =
      GroupBloc._privateConstructor();
  
  ScrollController groupScrollController = ScrollController();
}
