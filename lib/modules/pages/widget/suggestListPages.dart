import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/share/import.dart';

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
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
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
                  AuthBloc.firstLogin
                      ? 'Chào mừng, ${authBloc.userModel.name}'
                      : 'Gợi ý trang cho bạn',
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
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  backgroundImage: widget
                                              .suggest[index].avartar !=
                                          null
                                      ? CachedNetworkImageProvider(
                                          widget.suggest[index].avartar)
                                      : AssetImage(
                                          'assets/image/default_avatar.png'),
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      widget.suggest[index].name,
                                      style: ptBody().copyWith(
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )),
                              GestureDetector(
                                onTap: () async {
                                  pagesBloc.isFollowPageLoading = true;
                                  await pagesBloc.followPage(widget.suggest[index].id);
                                  pagesBloc.isFollowPageLoading = false;
                                },
                                child: Container(
                                  width: 90,
                                  padding: EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    border: (AuthBloc.instance.userModel
                                                ?.followingIds
                                                ?.contains(
                                                    widget.suggest[index].id) ==
                                            true)
                                        ? Border.all(color: Colors.black12)
                                        : Border.all(
                                            color: ptPrimaryColor(context)
                                                .withOpacity(0.2)),
                                    color: (AuthBloc.instance.userModel
                                                ?.followingIds
                                                ?.contains(
                                                    widget.suggest[index].id) ==
                                            true)
                                        ? Colors.transparent
                                        : ptSecondaryColor(context),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Center(
                                    child: Text('Theo dõi',
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
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          width: 10,
                        ),
                    itemCount: widget.suggest.length),
              )
            ],
          )),
    );
  }
}
