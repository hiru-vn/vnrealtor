import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/model/comment.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/repo/post_repo.dart';
import 'package:datcao/share/import.dart';

class PostBloc extends ChangeNotifier {
  PostBloc._privateConstructor();
  static final PostBloc instance = PostBloc._privateConstructor();

  bool isLoadFeed = true;
  bool isLoadStory = true;

  List<PostModel> post = [];
  List<PostModel> myPosts;
  List<PostModel> stories = [];
  List<PostModel> savePosts = [];

  Future init() async {
    getNewFeed(filter: GraphqlFilter(limit: 20, order: "{createdAt: -1}"));
    getStoryFollowing();
    getListPost(AuthBloc.instance.userModel.savedPostIds);
  }

  Future<BaseResponse> getNewFeed({GraphqlFilter filter}) async {
    try {
      isLoadFeed = true;
      notifyListeners();
      final res = await PostRepo().getNewFeed(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      post = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      isLoadFeed = false;
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
      isLoadStory = true;
      final res = await PostRepo().getStoryFollowing();
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      stories = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      isLoadStory = false;
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

  Future<BaseResponse> likeComment(String commentId) async {
    try {
      final res = await PostRepo().increaseLikeCmt(cmtId: commentId);
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

  Future<BaseResponse> unlikeComment(String commentId) async {
    try {
      final res = await PostRepo().decreaseLikeCmt(cmtId: commentId);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> savePost(PostModel post) async {
    try {
      savePosts.add(post);
      final res = await PostRepo().savePost(post.id);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getListPost(List<String> ids) async {
    try {
      final res = await PostRepo().getPostList(ids);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      savePosts = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.toString());
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
      return BaseResponse.fail(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
