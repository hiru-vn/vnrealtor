import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/share/import.dart';
import 'package:flutter/material.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/notification_bloc.dart';
import 'package:datcao/modules/inbox/inbox_chat.dart';
import 'inbox_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InboxBloc extends ChangeNotifier {
  InboxBloc._privateConstructor();
  static final InboxBloc instance = InboxBloc._privateConstructor();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<FbInboxGroupModel> groupInboxList;

  DocumentReference getGroup(String id) {
    return firestore.collection('group').doc(id);
  }

  final userCollection = 'user';
  final groupCollection = 'group';
  final messageCollection = 'messages';

  Future<void> init() async {
    await createUser(
        AuthBloc.instance.userModel.id,
        AuthBloc.instance.userModel.name,
        AuthBloc.instance.userModel.avatar,
        AuthBloc.instance.userModel.phone);
    final res = await getList20InboxGroup(AuthBloc.instance.userModel.id);
    groupInboxList = res;
    notifyListeners();
  }

  Future<String> checkChatable(BuildContext context, String id) async {
    final res = await UserBloc.instance.checkChatAble(id);
    if (!res.isSuccess || res.data == false) {
      showToast(res.errMessage, context);
      return res.data;
    }
    return res.data;
  }

  Future<void> navigateToChatWith(
      BuildContext context,
      String lastUser, // the other user
      String lastAvatar,
      DateTime time,
      String image,
      List<String> userIds,
      List<String> userAvatars) async {
    userIds.sort();

    final snap = await firestore
        .collection(groupCollection)
        .doc(userIds.join("-"))
        .get();
    if (!snap.exists) {
      await firestore.collection(groupCollection).doc(userIds.join("-")).set({
        'lastUser': lastUser,
        'lastAvatar': lastAvatar,
        'time': time.toIso8601String(),
        'lastMessage':
            '${AuthBloc.instance.userModel.name} đã bắt đầu cuộc trò chuyện',
        'image': image,
        'userIds': userIds,
        'userAvatars': userAvatars,
        'waitingBy': userIds
            .where((element) => element != AuthBloc.instance.userModel.id)
            .toList(),
      });
    }
    userIds.forEach((uid) {
      firestore.collection(userCollection).doc(uid).update({
        'groups': FieldValue.arrayUnion([userIds.join("-")])
      });
    });

    final users = await getUsers(userIds);
    if (users == null) {
      showToastNoContext('Người này không nhận tin nhắn');
      return;
    }

    getList20InboxGroup(AuthBloc.instance.userModel.id);

    await InboxChat.navigate(
        FbInboxGroupModel(
            userIds.join("-"),
            lastAvatar,
            '${AuthBloc.instance.userModel.name} đã bắt đầu cuộc trò chuyện',
            lastUser,
            time.toIso8601String(),
            [],
            users,
            userIds,
            userAvatars,
            waitingBy: userIds
                .where((element) => element != AuthBloc.instance.userModel.id)
                .toList()),
        lastUser);

    return;
  }

  Future<void> userJoinGroupChat(String uid, String groupId) async {}

  Future<void> blockGroup(String groupId) async {
    final snapShot =
        await firestore.collection(groupCollection).doc(groupId).get();
    if (snapShot.exists) {
      await getGroup(groupId).update({
        'blockedBy': FieldValue.arrayUnion([AuthBloc.instance.userModel.id]),
        'lastMessage':
            '${AuthBloc.instance.userModel.name} đã chặn cuộc hội thoại.',
      });
      groupInboxList
          .firstWhere((element) => element.id == groupId)
          .blockedBy
          .add(AuthBloc.instance.userModel.id);
      notifyListeners();
    }
  }

  Future<void> unBlockGroup(String groupId) async {
    final snapShot =
        await firestore.collection(groupCollection).doc(groupId).get();
    if (snapShot.exists) {
      final List<String> blockedBy = snapShot.data()['blockedBy'] != null
          ? snapShot.data()['blockedBy'].cast<String>()
          : [];
      blockedBy.removeWhere(
          (item) => item.toString() == AuthBloc.instance.userModel.id);
      await getGroup(groupId).update({
        'blockedBy': blockedBy,
        'lastMessage':
            '${AuthBloc.instance.userModel.name} đã mở cuộc hội thoại.',
      });
      groupInboxList
          .firstWhere((element) => element.id == groupId)
          .blockedBy
          .removeWhere(
              (item) => item.toString() == AuthBloc.instance.userModel.id);
      notifyListeners();
    }
  }

  Future<void> setPendingGroup(String groupId) async {
    final snapShot =
        await firestore.collection(groupCollection).doc(groupId).get();
    if (snapShot.exists) {
      await getGroup(groupId).update({
        'waitingBy': FieldValue.arrayUnion([AuthBloc.instance.userModel.id]),
      });
      groupInboxList
          .firstWhere((element) => element.id == groupId)
          .waitingBy
          .add(AuthBloc.instance.userModel.id);
      notifyListeners();
    }
  }

  Future<void> updateGroupOnMessage(
      String groupid,
      String lastUser,
      DateTime time,
      String lastMessage,
      String image,
      List<String> userAvatars,
      List<String> readers) async {
    readers = readers.toSet().toList(); //distinct
    final snapShot =
        await firestore.collection(groupCollection).doc(groupid).get();
    if (snapShot.exists) {
      await getGroup(groupid).update({
        'lastUser': lastUser,
        'time': time.toIso8601String(),
        'lastMessage': lastMessage,
        'image': image,
        'userAvatars': userAvatars,
        'readers': readers,
        'waitingBy': FieldValue.arrayRemove([AuthBloc.instance.userModel.id])
      });
    }
  }

  Future<List<FbInboxUserModel>> getUsers(List<String> users) async {
    try {
      final List<DocumentSnapshot> snapShots = await Future.wait(
          users.map((e) => firestore.collection(userCollection).doc(e).get()));
      final listUser =
          snapShots.map((e) => FbInboxUserModel.fromJson(e.data())).toList();
      return listUser;
    } catch (e) {
      return null;
    }
  }

  Future<void> addMessage(String groupId, String text, DateTime time,
      String uid, String fullName, String avatar,
      {List<String> filePaths, LatLng location}) async {
    print('upload: ' + filePaths.toString());
    await getGroup(groupId).collection(messageCollection).add({
      'text': text,
      'date': time.toIso8601String(),
      'uid': uid,
      'fullName': fullName,
      'avatar': avatar,
      'filePaths': filePaths == null ? [] : filePaths,
      'lat': location?.latitude,
      'long': location?.longitude,
    });

    final userIds = (await getGroup(groupId).get()).data()['userIds'] as List;
    final waitings =
        groupInboxList.firstWhere((element) => element.id == groupId).waitingBy;
    NotificationBloc.instance.sendNotiMessage(
        userIds
            .cast<String>()
            .where((element) =>
                element != AuthBloc.instance.userModel.id &&
                !waitings.contains(element))
            .toList(),
        text);
  }

  Future<Stream<QuerySnapshot>> getStreamIncomingMessages(
      String groupId, String latestFetchedMessageId) async {
    if (latestFetchedMessageId == null) {
      // just start conversation, no latestFetchedMessageId
      return getGroup(groupId).collection(messageCollection).snapshots();
    }
    final latestFetchedMessageDoc = await getGroup(groupId)
        .collection(messageCollection)
        .doc(latestFetchedMessageId)
        .get();
    return getGroup(groupId)
        .collection(messageCollection)
        .orderBy('date', descending: false)
        .startAfterDocument(latestFetchedMessageDoc)
        .snapshots();
  }

  Future<List<FbInboxMessageModel>> get20Messages(String groupId,
      {String lastMessageId}) async {
    List<FbInboxMessageModel> res;
    if (lastMessageId == null) {
      final query = getGroup(groupId)
          .collection(messageCollection)
          .orderBy('date', descending: false)
          .limitToLast(20);
      final snapshot = await query.get();
      res = snapshot.docs
          .map((e) => FbInboxMessageModel.fromJson(e.data(), e.id))
          .toList();
    } else {
      final lastMessageDoc = await getGroup(groupId)
          .collection(messageCollection)
          .doc(lastMessageId)
          .get();
      final query = getGroup(groupId)
          .collection(messageCollection)
          .orderBy('date', descending: false)
          .endBeforeDocument(lastMessageDoc)
          .limitToLast(20);
      final snapshot = await query.get();
      res = snapshot.docs
          .map((e) => FbInboxMessageModel.fromJson(e.data(), e.id))
          .toList();
    }
    return res;
  }

  Future<void> createUser(
      String id, String name, String image, String phone) async {
    final snapShot = await firestore.collection(userCollection).doc(id).get();
    if (snapShot.exists) {
      await firestore
          .collection(userCollection)
          .doc(id)
          .update({'name': name, 'id': id, 'image': image, 'phone': phone});
    } else {
      await firestore.collection(userCollection).doc(id).set({
        'name': name,
        'id': id,
        'image': image,
        'phone': phone,
      });
    }
    return;
  }

  Future<List<String>> getUserGroupInboxListIds(String idUser) async {
    final snapShot =
        await firestore.collection(userCollection).doc(idUser).get();
    if (!snapShot.exists) return <String>[];
    return FbInboxUserModel.fromJson(snapShot.data()).groups;
  }

  Future<List<FbInboxGroupModel>> getGroupInboxList(
      List<String> idGroups) async {
    var list = <FbInboxGroupModel>[];
    await Future.wait(idGroups.map((e) async {
      final item = await firestore.collection(groupCollection).doc(e).get();
      final users =
          await getUsers((item.data()['userIds'] as List).cast<String>());
      if (users != null) {
        list.add(FbInboxGroupModel.fromJson(item.data(), item.id, users));
        list.sort((a, b) =>
            DateTime.tryParse(b.time).compareTo(DateTime.tryParse(a.time)));
        groupInboxList = list;
        // reload every 10 groups
        if ((groupInboxList.length % 20) == 0) notifyListeners();
      }
    }));

    return list;
  }

  Future<List<FbInboxGroupModel>> getList20InboxGroup(String idUser) async {
    final groups = await getUserGroupInboxListIds(idUser);
    final inboxes = await getGroupInboxList(groups);
    notifyListeners();
    return inboxes;
  }

  Future<String> getImage({id}) async {
    final snapShot = await firestore.collection(userCollection).doc(id).get();
    return snapShot.data()['image'];
  }

  Future<String> getName({id}) async {
    final snapShot = await firestore.collection(userCollection).doc(id).get();
    return snapShot.data()['name'];
  }
}
