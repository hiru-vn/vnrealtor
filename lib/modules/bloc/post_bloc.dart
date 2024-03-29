import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/model/address.dart';
import 'package:datcao/modules/model/comment.dart';
import 'package:datcao/modules/model/media_post.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/model/reply.dart';
import 'package:datcao/modules/repo/post_repo.dart';
import 'package:datcao/share/import.dart';
import 'package:graphql/client.dart';
import 'package:geolocator/geolocator.dart';

class PostBloc extends ChangeNotifier {
  PostBloc._privateConstructor();
  static final PostBloc instance = PostBloc._privateConstructor();

  PageController pageController = PageController();
  ScrollController feedScrollController = ScrollController();

  bool isReloadFeed = true;
  bool isLoadMoreFeed = true;
  bool isLoadStory = true;
  bool isEndFeed = false;
  DateTime lastFetchFeedPage1;
  int feedPage = 1;
  static int counterCreatPostIn1Session = 0;

  List<PostModel> feed = [];
  List<PostModel> myPosts;
  List<PostModel> stories = [];
  List<PostModel> savePosts = [];
  List<dynamic> hasTags = [];

  Stream<FetchResult> commentSubcription;

  Future init() async {
    getNewFeed(filter: GraphqlFilter(limit: 10, order: "{updatedAt: -1}"));
    getStoryFollowing();
    getSavedPost();
    getAllHashTagTP();
  }

  Future reload() async {
    notifyListeners();
  }

  Future<BaseResponse> getNewFeed({GraphqlFilter filter}) async {
    try {
      // update user position
      UserBloc.instance.setUserlocation();

      isEndFeed = false;
      isReloadFeed = true;
      notifyListeners();
      final res = await PostRepo().getNewFeed(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      if (list.length < filter.limit) isEndFeed = true;
      feed = list;
      lastFetchFeedPage1 = DateTime.now();
      feedPage = 1;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      isReloadFeed = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> getNewFeedGuest(int page) async {
    try {
      final res = await PostRepo().getNewFeedGuest(page: page, limit: 10);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      feedPage++;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      isReloadFeed = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> loadMoreNewFeed() async {
    try {
      if (isEndFeed) return BaseResponse.success(<PostModel>[]);
      isLoadMoreFeed = true;
      notifyListeners();
      final res = await PostRepo().getNewFeed(
          filter: GraphqlFilter(
              limit: 10, order: "{updatedAt: -1}", page: ++feedPage),
          timeSort: '-1',
          timestamp: lastFetchFeedPage1.toString());
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      if (list.length < 15) isEndFeed = true;
      feed.addAll(list);
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      isLoadMoreFeed = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> getPostLocal(double distance) async {
    try {
      final pos = await getDevicePosition();
      isReloadFeed = true;
      notifyListeners();
      final res =
          await searchPostWithLocation(pos.longitude, pos.latitude, distance);
      feed = res.data;
      return res;
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      isReloadFeed = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> searchPostByHashTag(String hashTags) async {
    try {
      final res = await PostRepo().searchPostByHashTag(hashTags);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> searchPostWithFilter({GraphqlFilter filter}) async {
    try {
      final res = await PostRepo().getNewFeed(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> searchPostWithLocation(
      double long, double lat, double maxDistance) async {
    try {
      final res =
          await PostRepo().searchPostWithLocation(long, lat, maxDistance);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getMyPost() async {
    try {
      final id = await SPref.instance.get('id');
      final res = await PostRepo().getPostByUserId(id);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      myPosts = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getStoryFollowing() async {
    try {
      isLoadStory = true;
      final res = await PostRepo().getStoryFollowing();
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      stories = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      isLoadStory = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> getStoryForGuest() async {
    Position position;
    try {
      position = await getDevicePosition();
    } catch (e) {}
    try {
      final res = await PostRepo()
          .getStoryForGuest(lat: position?.latitude, long: position?.longitude);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e?.message ?? e.toString());
    } finally {}
  }

  Future<BaseResponse> getUserPost(String id) async {
    try {
      final res = await PostRepo().getPostByUserId(id);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getUserPostGuest(String id) async {
    try {
      final res = await PostRepo().getPostByUserIdGuest(id);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getAllCommentByPostId(String postId,
      {GraphqlFilter filter}) async {
    try {
      final res = await PostRepo()
          .getAllCommentByPostId(postId: postId, filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => CommentModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getAllCommentByPostIdGuest(String postId,
      {GraphqlFilter filter}) async {
    try {
      final res = await PostRepo()
          .getAllCommentByPostIdGuest(postId: postId, filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => CommentModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getAllHashTagTP() async {
    try {
      final res = await PostRepo().getAllHashTagTP();
      hasTags = res as List<dynamic>;
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> getAllCommentByMediaPostIdGuest(String mediaPostId,
      {GraphqlFilter filter}) async {
    try {
      final res = await PostRepo().getAllCommentByMediaPostIdGuest(
          mediaPostId: mediaPostId, filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => CommentModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getListMediaPostComment(String postMediaId,
      {GraphqlFilter filter}) async {
    try {
      final res = await PostRepo()
          .getAllCommentByMediaPostId(postMediaId: postMediaId, filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => CommentModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getAllReplyByCommentId(String commentId,
      {GraphqlFilter filter}) async {
    try {
      final res = await PostRepo()
          .getAllReplyByCommentId(commentId: commentId, filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => ReplyModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getAllReplyByCommentIdGuest(String commentId,
      {GraphqlFilter filter}) async {
    try {
      final res = await PostRepo()
          .getAllReplyByCommentIdGuest(commentId: commentId, filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => ReplyModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> createPost(
      String content,
      String expirationDate,
      bool publicity,
      double lat,
      double long,
      List<String> images,
      List<String> videos,
      List<LatLng> polygon,
      List<String> tagUserIds,
      String type,
      String need,
      double area,
      double price,
      bool onlyMe) async {
    try {
      final res = await PostRepo().createPost(
          content,
          expirationDate,
          publicity,
          lat,
          long,
          images,
          videos,
          polygon,
          tagUserIds,
          type,
          need,
          area,
          price,
          onlyMe);
      feed.insert(0, PostModel.fromJson(res));
      myPosts.insert(0, PostModel.fromJson(res));
      return BaseResponse.success(PostModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      // wait to reload post
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
    }
  }

  Future<BaseResponse> updatePost(
      String id,
      String content,
      String expirationDate,
      bool publicity,
      double lat,
      double long,
      List<String> images,
      List<String> videos,
      List<LatLng> polygon,
      List<String> tagUserIds,
      String type,
      String need,
      double area,
      double price,
      bool onlyMe) async {
    try {
      final res = await PostRepo().updatePost(
          id,
          content,
          expirationDate,
          publicity,
          lat,
          long,
          images,
          videos,
          polygon,
          tagUserIds,
          type,
          need,
          area,
          price,
          onlyMe);
      return BaseResponse.success(PostModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      // wait to reload post
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
    }
  }

  Future<BaseResponse> sharePost(String postId,
      {String groupId,
      String pageId,
      String content,
      List<String> tagUserIds}) async {
    try {
      final res = await PostRepo().sharePost(postId,
          groupId: groupId,
          pageId: pageId,
          content: content,
          tagUserIds: tagUserIds);
      feed.insert(0, PostModel.fromJson(res));
      if (groupId == null && pageId == null)
        myPosts.insert(0, PostModel.fromJson(res));
      return BaseResponse.success(PostModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      // wait to reload post
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
    }
  }

  Future<BaseResponse> createComment(String content,
      {String postId, String mediaPostId, List<String> tagUserIds}) async {
    try {
      final res = await PostRepo().createComment(
          postId: postId,
          mediaPostId: mediaPostId,
          content: content,
          tagUserIds: tagUserIds);
      return BaseResponse.success(CommentModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> createReply(String content, String commentId,
      {List<String> tagUserIds}) async {
    try {
      final res = await PostRepo().createReply(
          commentId: commentId, content: content, tagUserIds: tagUserIds);
      return BaseResponse.success(ReplyModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> deletePost(String id) async {
    try {
      feed.removeWhere((item) => item.id == id);
      myPosts.removeWhere((item) => item.id == id);
      notifyListeners();
      final res = await PostRepo().deletePost(id);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> deleteComment(String id) async {
    try {
      final res = await PostRepo().deleteComment(id);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> deleteReply(String id) async {
    try {
      final res = await PostRepo().deleteReply(id);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> likePost(PostModel postModel) async {
    try {
      int likeCount = postModel.like + 1;
      postModel.like = likeCount;
      setLikePostLocal(postModel.id, likeCount, true);
      notifyListeners();
      final res = await PostRepo().increaseLikePost(postId: postModel.id);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> likeMediaPost(String postMediaId) async {
    try {
      final res =
          await PostRepo().increaseLikeMediaPost(postMediaId: postMediaId);

      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> likeComment(String commentId) async {
    try {
      final res = await PostRepo().increaseLikeCmt(cmtId: commentId);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> unlikePost(PostModel postModel) async {
    try {
      int likeCount = postModel.like - 1;
      if (likeCount < 0) likeCount = 0;
      postModel.like = likeCount;

      setLikePostLocal(postModel.id, likeCount, false);
      notifyListeners();
      final res = await PostRepo().decreaseLikePost(postId: postModel.id);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  void setLikePostLocal(String postId, int likeCounter, bool isUserLike) {
    PostModel post;
    post =
        feed.firstWhere((element) => element.id == postId, orElse: () => null);
    if (post != null)
      post
        ..like = likeCounter
        ..isUserLike = isUserLike;
    post = myPosts.firstWhere((element) => element.id == postId,
        orElse: () => null);
    if (post != null)
      post
        ..like = likeCounter
        ..isUserLike = isUserLike;
    post = stories.firstWhere((element) => element.id == postId,
        orElse: () => null);
    if (post != null)
      post
        ..like = likeCounter
        ..isUserLike = isUserLike;
    post = savePosts.firstWhere((element) => element.id == postId,
        orElse: () => null);
    if (post != null)
      post
        ..like = likeCounter
        ..isUserLike = isUserLike;
  }

  Future<BaseResponse> unlikeMediaPost(String postMediaId) async {
    try {
      final res =
          await PostRepo().decreaseLikeMediaPost(postMediaId: postMediaId);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> unlikeComment(String commentId) async {
    try {
      final res = await PostRepo().decreaseLikeCmt(cmtId: commentId);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> savePost(PostModel post) async {
    try {
      savePosts.add(post);
      savePosts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      AuthBloc.instance.userModel.savedPostIds.add(post.id);
      notifyListeners();
      final res = await PostRepo().savePost(post.id);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> unsavePost(PostModel post) async {
    try {
      savePosts.remove(post);
      savePosts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      AuthBloc.instance.userModel.savedPostIds.remove(post.id);
      notifyListeners();
      final res = await PostRepo().unsavePost(post.id);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getListPost(List<String> ids) async {
    try {
      final res = await PostRepo().getPostList(ids);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getSavedPost() async {
    try {
      final res = await PostRepo().getSavedPost();
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      savePosts = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getOnePost(String id) async {
    try {
      final res = await PostRepo().getOnePost(id);
      if (res == null)
        return BaseResponse.fail('Bài viết không tồn tại hoặc đã bị xóa');
      return BaseResponse.success(PostModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getOnePostGuest(String id) async {
    try {
      final res = await PostRepo().getOnePostGuest(id);
      if (res == null)
        return BaseResponse.fail('Bài viết không tồn tại hoặc đã bị xóa');
      return BaseResponse.success(PostModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getOneMediaPost(String id) async {
    try {
      final res = await PostRepo().getOneMediaPost(id);
      if (res == null)
        return BaseResponse.fail('Bài viết không tồn tại hoặc đã bị xóa');
      return BaseResponse.success(MediaPost.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> createReport(
      String type, String content, String postId) async {
    try {
      final res = await PostRepo()
          .createReport(type: type, content: content, postId: postId);
      if (res == null)
        return BaseResponse.fail('Bài viết không tồn tại hoặc đã bị xóa');
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> hidePost(String postId) async {
    try {
      final res = await PostRepo().hidePost(postId);
      if (res == null)
        return BaseResponse.fail('Bài viết không tồn tại hoặc đã bị xóa');
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getAddress(double long, double lat) async {
    try {
      final res = await PostRepo().getAddress(long, lat);

      return BaseResponse.success(Address.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Stream<FetchResult> subscriptionCommentByPostId(String id) {
    try {
      final res = PostRepo().subscriptionCommentByPostId(id);
      commentSubcription = res;
      return res;
    } catch (e) {
      return null;
    } finally {}
  }
}
