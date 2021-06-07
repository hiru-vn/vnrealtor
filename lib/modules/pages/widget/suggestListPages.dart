import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/pages/page_detail.dart';
import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/custom_tooltip.dart';

class SuggestListPages extends StatefulWidget {
  final List<PagesCreate> suggest;
  const SuggestListPages({Key key, this.suggest}) : super(key: key);

  @override
  _SuggestListPagesState createState() => _SuggestListPagesState();
}

class _SuggestListPagesState extends State<SuggestListPages> {
  AuthBloc authBloc;
  UserBloc userBloc;
  PagesBloc pagesBloc;

  @override
  void didChangeDependencies() {
    if (authBloc == null) {
      authBloc = Provider.of(context);
      userBloc = Provider.of(context);
      pagesBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.suggest.length > 0
        ? Container(
            width: deviceWidth(context),
            color: Colors.white,
            padding: const EdgeInsets.only(top: 15, bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    'Gợi ý trang cho bạn',
                    style: ptBigTitle().copyWith(color: Colors.black),
                  ),
                ),
                if (AuthBloc.firstLogin) ...[
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      'Theo dõi những trang khác để nhận được những nội dung phù hợp với bạn.',
                      style: ptBody(),
                    ),
                  ),
                ],
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 175,
                  child: ListView.separated(
                      padding: EdgeInsets.only(right: 20, left: 15),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return PageItem(widget.suggest[index], pagesBloc);
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            width: 10,
                          ),
                      itemCount: widget.suggest.length),
                )
              ],
            ))
        : const SizedBox();
  }
}

class PageItem extends StatelessWidget {
  final PagesCreate page;
  final PagesBloc pagesBloc;
  const PageItem(this.page, this.pagesBloc);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: Colors.black12,
          )),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () => PageDetail.navigate(page),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: page.avartar != null
                    ? CachedNetworkImageProvider(page.avartar)
                    : AssetImage('assets/image/default_avatar.png'),
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => PageDetail.navigate(page),
                  child: Text(
                    page.name,
                    style: ptBody().copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )),
            GestureDetector(
              onTap: () async {
                final res = await pagesBloc.followPage(page.id);
                if (res.isSuccess) {
                  pagesBloc.suggestFollowPage.forEach((element) {
                    if (element.id == page.id) {
                      pagesBloc.suggestFollowPage.remove(element);
                      pagesBloc.listPageFollow.add(element);
                    }
                  });
                } else {
                  showToast(res.errMessage, context);
                }

                pagesBloc.isSuggestFollowLoading = false;
              },
              child: Container(
                width: 90,
                padding: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: ptPrimaryColor(context).withOpacity(0.2)),
                  color: ptSecondaryColor(context),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: pagesBloc.isSuggestFollowLoading &&
                        pagesBloc.followingPageIds.contains(page.id)
                    ? Center(
                        child: Container(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.mainColor),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'Theo dõi',
                          style: ptSmall().copyWith(
                            fontWeight: FontWeight.w600,
                            color: ptPrimaryColor(context),
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class PageWidget extends StatelessWidget {
  final PagesCreate page;
  final PagesBloc pagesBloc;
  const PageWidget(this.page, this.pagesBloc);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5).copyWith(bottom: 0),
      child: GestureDetector(
        onTap: () => PageDetail.navigate(page),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                backgroundImage: page.avartar != null
                    ? CachedNetworkImageProvider(page.avartar)
                    : AssetImage('assets/image/default_avatar.png'),
              ),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          page.name ?? '',
                          style: ptTitle().copyWith(fontSize: 14),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        CustomTooltip(
                          margin: EdgeInsets.only(top: 0),
                          message: 'Đã xác thực',
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue[600],
                            ),
                            padding: EdgeInsets.all(1.3),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            page.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: ptSmall().copyWith(color: Colors.grey),
                          ),
                        ),
                        if (pagesBloc.followingPageIds.contains(page.id)) ...[
                          Text(
                            ' • ',
                            style: ptSmall().copyWith(color: Colors.grey),
                          ),
                          Text(
                            'Đang theo dõi',
                            style: ptSmall().copyWith(color: Colors.blue),
                          ),
                        ],
                        SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
              if (AuthBloc.instance.userModel != null &&
                  !pagesBloc.followingPageIds.contains(page.id) &&
                  !PagesBloc.instance.pageCreated
                      .map((e) => e.id)
                      .toList()
                      .contains(page.id))
                GestureDetector(
                  onTap: () async {
                    page.followerIds.add(AuthBloc.instance.userModel.id);
                    final res = await pagesBloc.followPage(page.id);
                    if (!res.isSuccess) showToast(res.errMessage, context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      'Theo dõi',
                      style: ptBody().copyWith(color: Colors.white),
                    ),
                  ),
                )
            ]),
          ),
        ),
      ),
    );
  }
}
