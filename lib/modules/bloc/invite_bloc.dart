import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/model/invite.dart';
import 'package:datcao/modules/repo/user_repo.dart';
import 'package:datcao/share/import.dart';

class InviteBloc extends ChangeNotifier {
  InviteBloc._privateConstructor() {
    //init();
  }
  static final InviteBloc instance = InviteBloc._privateConstructor();
  List<InviteModel> invitesUserSent = [];
  List<InviteModel> invitesUserReceived = [];
  List<InviteModel> invitesPageSent = [];
  List<InviteModel> invitesPageReceived = [];
  List<InviteModel> invitesGroupSent = [];
  List<InviteModel> invitesGroupReceived = [];
  int invitesUserSentPage = 1;
  int invitesUserReceivedPage = 1;
  int invitesPageSentPage = 1;
  int invitesPageReceivedPage = 1;
  int invitesGroupSentPage = 1;
  int invitesGroupReceivedPage = 1;

  bool isEndInvitesUserSent = false,
      isEndInvitesUserReceived = false,
      isLoadingInvitesUserSent = false,
      isLoadingInvitesUserReceived = false,
      isEndInvitesPageSent = false,
      isEndInvitesPageReceived = false,
      isLoadingInvitesPageSent = false,
      isLoadingInvitesPageReceived = false,
      isEndInvitesGroupSent = false,
      isEndInvitesGroupReceived = false,
      isLoadingInvitesGroupSent = false,
      isLoadingInvitesGroupReceived = false;
  ScrollController invitesUserSentScrollController = ScrollController();
  ScrollController invitesUserReceivedScrollController = ScrollController();
  ScrollController invitesPageSentScrollController = ScrollController();
  ScrollController invitesPageReceivedScrollController = ScrollController();
  ScrollController invitesGroupSentScrollController = ScrollController();
  ScrollController invitesGroupReceivedScrollController = ScrollController();
  Future<BaseResponse> getInvitesUserSent() async {
    try {
      isEndInvitesUserSent = false;
      isLoadingInvitesUserSent = true;
      GraphqlFilter _filter = GraphqlFilter(
          limit: 10,
          filter:
              "{fromUserId: \"${AuthBloc.instance.userModel.id}\", status:\"PROCESSING\"}");
      final res = await UserRepo().getAllInviteFollow(filter: _filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => InviteModel.fromJson(e)).toList();
      if (list.length < _filter.limit) isEndInvitesUserSent = true;
      invitesUserSent = list;
      invitesUserSentPage = 1;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      isLoadingInvitesUserSent = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> getInvitesUserReceived() async {
    try {
      isEndInvitesUserReceived = false;
      isLoadingInvitesUserReceived = true;
      GraphqlFilter _filter = GraphqlFilter(
          limit: 10,
          filter:
              "{toUserId: \"${AuthBloc.instance.userModel.id}\",status:\"PROCESSING\"}");
      final res = await UserRepo().getAllInviteFollow(filter: _filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => InviteModel.fromJson(e)).toList();
      if (list.length < _filter.limit) isEndInvitesUserReceived = true;
      invitesUserReceived = list;
      invitesUserReceivedPage = 1;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      isLoadingInvitesUserReceived = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> deleteInviteSent(
      {String id, bool isSent = false}) async {
    try {
      final res = await UserRepo().deleteInvites(id: id);
      if (isSent) {
        invitesUserSent =
            invitesUserSent.where((element) => element.id != id).toList();
      } else {
        invitesUserReceived =
            invitesUserReceived.where((element) => element.id != id).toList();
      }
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> acceptInviteFollow({String id}) async {
    try {
      final res = await UserRepo().acceptInviteFollow(id: id);
      invitesUserReceived =
          invitesUserReceived.where((element) => element.id != id).toList();
      await AuthBloc.instance.getUser();
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }
}
