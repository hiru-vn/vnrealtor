import 'package:vnrealtor/modules/model/comment.dart';
import 'package:vnrealtor/modules/model/post.dart';
import 'package:vnrealtor/modules/repo/post_repo.dart';
import 'package:vnrealtor/share/import.dart';

class PostBloc extends ChangeNotifier {
  PostBloc._privateConstructor();
  static final PostBloc instance = PostBloc._privateConstructor();

  List<PostModel> post = [];
  List<PostModel> myPosts;
  List<PostModel> stories = [];

  Future init() async {
    getNewFeed(filter: GraphqlFilter(limit: 20, order: "{createdAt: -1}"));
    getStoryFollowing();
  }

  Future<BaseResponse> getNewFeed({GraphqlFilter filter}) async {
    try {
      final res = await PostRepo().getNewFeed(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      post = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.toString());
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
      return BaseResponse.fail(e.toString());
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
      return BaseResponse.fail(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getStoryFollowing() async {
    try {
      final res = await PostRepo().getStoryFollowing();
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      stories = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getUserPost(String id) async {
    try {
      final res = await PostRepo().getPostByUserId(id);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.toString());
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
      return BaseResponse.fail(e.toString());
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
      return BaseResponse.fail(e.toString());
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
      List<String> videos) async {
    try {
      final res = await PostRepo().createPost(
          content, expirationDate, publicity, lat, long, images, videos);
      return BaseResponse.success(PostModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      // wait to reload post
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
    }
  }

  Future<BaseResponse> createComment(String content,
      {String postId, String mediaPostId}) async {
    try {
      final res = await PostRepo().createComment(
          postId: postId, mediaPostId: mediaPostId, content: content);
      return BaseResponse.success(CommentModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> deletePost(String postId) async {
    try {
      post.removeWhere((item) => item.id == postId);
      myPosts.removeWhere((item) => item.id == postId);
      notifyListeners();
      final res = await PostRepo().deletePost(postId);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> likePost(String postId) async {
    try {
      final res = await PostRepo().increaseLikePost(postId: postId);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.toString());
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
      return BaseResponse.fail(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> unlikePost(String postId) async {
    try {
      final res = await PostRepo().decreaseLikePost(postId: postId);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> unlikeMediaPost(String postMediaId) async {
    try {
      final res =
          await PostRepo().decreaseLikeMediaPost(postMediaId: postMediaId);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
