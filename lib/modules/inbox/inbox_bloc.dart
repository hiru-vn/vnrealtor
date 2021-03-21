import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> navigateToChatWith(
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
        'userAvatars': userAvatars
      });
      userIds.forEach((uid) {
        firestore.collection(userCollection).doc(uid).update({
          'groups': FieldValue.arrayUnion([userIds.join("-")])
        });
      });
    }
    final users = await getUsers(userIds);
    if (users == null) {
      showToastNoContext('Người này không nhận tin nhắn');
      return;
    }
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
            userAvatars),
        lastUser);
    getList20InboxGroup(AuthBloc.instance.userModel.id);
    return;
  }

  Future<void> userJoinGroupChat(String uid, String groupId) async {}

  Future<void> updateGroupOnMessage(
      String groupid,
      String lastUser,
      DateTime time,
      String lastMessage,
      String image,
      List<String> userAvatars) async {
    final snapShot =
        await firestore.collection(groupCollection).doc(groupid).get();
    if (snapShot.exists) {
      await getGroup(groupid).update({
        'lastUser': lastUser,
        'time': time.toIso8601String(),
        'lastMessage': lastMessage,
        'image': image,
        'userAvatars': userAvatars
      });
    }
  }

  Future<List<FbInboxUserModel>> getUsers(List<String> users) async {
    try {
      final List<DocumentSnapshot> snapShots = await Future.wait(
          users.map((e) => firestore.collection(userCollection).doc(e).get()));
      print(snapShots[0].data());
      print(snapShots[1].data());
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
      'long': location?.longitude
    });
    final userIds = (await getGroup(groupId).get()).data()['userIds'] as List;
    NotificationBloc.instance.sendNotiMessage(
        userIds
            .cast<String>()
            .where((element) => element != AuthBloc.instance.userModel.id)
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

  Future<List<String>> get20UserGroupInboxList(String idUser) async {
    final snapShot =
        await firestore.collection(userCollection).doc(idUser).get();
    if (!snapShot.exists) return <String>[];
    return FbInboxUserModel.fromJson(snapShot.data()).groups;
  }

  Future<List<FbInboxGroupModel>> getGroupInboxList(
      List<String> idGroups) async {
    var list = <FbInboxGroupModel>[];
    // idGroups.forEach((id) async {
    //    final snapShot =
    //       await firestore.collection(groupCollection).doc(id).get();
    //   list.add(FbInboxGroupModel.fromJson(snapShot.data(), id));
    // });

    // for (int i = 0; i < idGroups.length; i++) {
    //   final item =
    //       await firestore.collection(groupCollection).doc(idGroups[i]).get();
    //   final users =
    //       await getUsers((item.data()['userIds'] as List).cast<String>());
    //   if (users != null) {
    //     list.add(FbInboxGroupModel.fromJson(item.data(), item.id, users));
    //     list.sort((a, b) =>
    //         DateTime.tryParse(b.time).compareTo(DateTime.tryParse(a.time)));
    //     groupInboxList = list;
    //     // notifyListeners();
    //   }
    // }

    //final List<FbInboxGroupModel> listGroup =
    await Future.wait(idGroups.map((e) async {
      final item = await firestore.collection(groupCollection).doc(e).get();
      final users =
          await getUsers((item.data()['userIds'] as List).cast<String>());
      if (users != null) {
        list.add(FbInboxGroupModel.fromJson(item.data(), item.id, users));
        list.sort((a, b) =>
            DateTime.tryParse(b.time).compareTo(DateTime.tryParse(a.time)));
        groupInboxList = list;
        // notifyListeners();
      }
    }));

    return list;
  }

  Future<List<FbInboxGroupModel>> getList20InboxGroup(String idUser) async {
    final groups = await get20UserGroupInboxList(idUser);
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
