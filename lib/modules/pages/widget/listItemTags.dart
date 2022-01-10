import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/share/function/function.dart';
import 'package:datcao/share/import.dart';
import 'package:flutter_tags/flutter_tags.dart';

class ListItemTags extends StatefulWidget {
  final String? title;
  final List<String?> list;
  final OnClickAt? onClickAt;
  final bool isEnableRemove;
  final AppColors? textColor;
  final WrapAlignment alignment;
  final double? marginHorizontal;
  final EdgeInsets? padding;

  const ListItemTags(
      {this.title,
      this.textColor,
      this.onClickAt,
      required this.list,
      this.isEnableRemove = false,
      this.alignment = WrapAlignment.start,
      this.marginHorizontal,
      this.padding});

  @override
  _ListItemTagsState createState() => _ListItemTagsState();
}

class _ListItemTagsState extends State<ListItemTags> {
  Key _tagStateKey = Key('tags');
  @override
  Widget build(BuildContext context) {
    return widget.list != null
        ? MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: widget.marginHorizontal ?? 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null)
                    Text(
                      widget.title!,
                      style: ptBody(),
                    ),
                  Padding(
                    padding:
                        widget.padding ?? EdgeInsets.symmetric(vertical: 4),
                    child: Tags(
                      key: _tagStateKey,
                      itemCount: widget.list.length,
                      spacing: 4,
                      alignment: widget.alignment,
                      verticalDirection: VerticalDirection.up,
                      itemBuilder: (int index) {
                        return ItemTags(
                          index: index,
                          textColor:
                              widget.textColor as Color? ?? AppColors.mainColor,
                          pressEnabled: false,
                          active: false,
                          alignment: MainAxisAlignment.end,
                          textStyle: ptBody(),
                          textOverflow: TextOverflow.ellipsis,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              width: 1,
                              color: widget.textColor as Color? ??
                                  AppColors.mainColor),
                          elevation: 0.5,
                          title: widget.list[index]!,
                          removeButton: widget.isEnableRemove
                              ? ItemTagsRemoveButton(
                                  size: 14,
                                  backgroundColor: widget.textColor as Color? ??
                                      Colors.white,
                                  color: AppColors.mainColor,
                                  onRemoved: () {
                                    widget.onClickAt!(index);
                                    setState(() => widget.list.removeAt(index));
                                    return true;
                                  })
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
