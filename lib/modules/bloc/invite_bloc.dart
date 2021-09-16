import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/repo/user_repo.dart';
import 'package:datcao/share/import.dart';

class InviteBloc extends ChangeNotifier {
  InviteBloc._privateConstructor() {
    //init();
  }
  static final InviteBloc instance = InviteBloc._privateConstructor();
  List<UserModel> invitesSent = [];
  List<UserModel> invitesReceived = [];
  int invitesSentPage = 1;
  int invitesReceivedPage = 1;

  bool isEndInvitesSent = false,
      isEndInvitesReceived = false,
      isLoadingInvitesSent = false,
      isLoadingInvitesReceived = false;
  ScrollController invitesSentScrollController = ScrollController();
  ScrollController invitesReceivedScrollController = ScrollController();
  Future<BaseResponse> getInvitesSent() async {
    try {
      isEndInvitesSent = false;
      isLoadingInvitesSent = true;
      GraphqlFilter _filter = GraphqlFilter(
          limit: 10,
          filter: "{fromUserId: \"${AuthBloc.instance.userModel.id}\"}");
      final res = await UserRepo().getAllInviteFollow(filter: _filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => UserModel.fromJson(e['toUser'])).toList();
      if (list.length < _filter.limit) isEndInvitesSent = true;
      invitesSent = list;
      invitesSentPage = 1;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      isLoadingInvitesSent = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> getInvitesReceived() async {
    try {
      isEndInvitesReceived = false;
      isLoadingInvitesReceived = true;
      GraphqlFilter _filter = GraphqlFilter(
          limit: 10,
          filter: "{toUserId: \"${AuthBloc.instance.userModel.id}\"}");
      final res = await UserRepo().getAllInviteFollow(filter: _filter);
      final List listRaw = res['data'];
      final list =
          listRaw.map((e) => UserModel.fromJson(e['fromUser'])).toList();
      if (list.length < _filter.limit) isEndInvitesReceived = true;
      invitesReceived = list;
      invitesReceivedPage = 1;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      isLoadingInvitesReceived = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> deleteInviteSent({String id, String userID}) async {
    try {
      final res = await UserRepo().deleteInvites(id: id);
      invitesSent =
          invitesSent.where((element) => element.id == userID).toList();
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }
}
