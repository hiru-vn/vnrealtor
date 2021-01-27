import 'package:vnrealtor/modules/model/comment.dart';
import 'package:vnrealtor/modules/model/post.dart';
import 'package:vnrealtor/modules/repo/post_repo.dart';
import 'package:vnrealtor/share/import.dart';

class PostBloc extends ChangeNotifier {
  PostBloc._privateConstructor();
  static final PostBloc instance = PostBloc._privateConstructor();

  List<PostModel> post = [];

  Future<BaseResponse> getListPost({GraphqlFilter filter}) async {
    try {
      final res = await PostRepo().getListPost(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      post = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getListPostComment(String postId) async {
    try {
      final res = await PostRepo().getAllCommentByPostId(postId: postId);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => CommentModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getListMediaPostComment(String postMediaId) async {
    try {
      final res = await PostRepo().getAllCommentByMediaPostId(postMediaId: postMediaId);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => CommentModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      notifyListeners();
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

  Future<BaseResponse> likePost(String postId) async {
    try {
      final res = await PostRepo().increaseLikePost(postId: postId);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> likeMediaPost(String postMediaId) async {
    try {
      final res = await PostRepo().increaseLikeMediaPost(postMediaId: postMediaId);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> unlikePost(String postId) async {
    try {
      final res = await PostRepo().decreaseLikePost(postId: postId);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> unlikeMediaPost(String postMediaId) async {
    try {
      final res = await PostRepo().decreaseLikeMediaPost(postMediaId: postMediaId);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      notifyListeners();
    }
  }
}
