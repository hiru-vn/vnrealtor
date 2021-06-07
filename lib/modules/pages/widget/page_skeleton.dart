import 'package:datcao/modules/pages/widget/own_page_loading.dart';
import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/base_widgets.dart';

class PageSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor.withOpacity(0.2),
        ),
        child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10).copyWith(bottom: 0),
                    child: StorySkeleton(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: _itemIconButtonTitle(),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 17),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 40,
                          blurRadius: 40.0,
                          offset: Offset(0, 10),
                          color: Color.fromRGBO(0, 0, 0, 0.03),
                        )
                      ],
                    ),
                    child: OwnPageLoading(),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: _itemIconButtonTitle(),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 17),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 40,
                          blurRadius: 40.0,
                          offset: Offset(0, 10),
                          color: Color.fromRGBO(0, 0, 0, 0.03),
                        )
                      ],
                    ),
                    child: OwnPageLoading(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemIconButtonTitle() =>
      Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 41,
              height: 41,
              child: CircleAvatar(
                backgroundColor: AppColors.backgroundColor,
                radius: 30,
              ),
            ),
            widthSpace(15),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.backgroundColor,
              ),
              width: 100,
              height: 12,
            ),
          ],
        ),
      );
}
