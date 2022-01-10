import 'package:datcao/modules/model/option_model.dart';
import 'package:flutter/material.dart';

class MultiDropdownTextInput extends StatefulWidget {
  final String name;
  final List<MultiOptionModel> items;
  final ValueChanged<List<MultiOptionModel>?>? onChanged;
  final FormFieldValidator<MultiOptionModel>? validator;
  final FormFieldSetter<MultiOptionModel>? onSaved;
  final FocusNode? focusNode;
  final String? labelText;
  final String? errorText;
  final TextInputType keyboardType;
  final Color? backgroundColor;
  //final List<MultiOptionModel>? initialValues;
  final double borderRadius;
  final bool isShowBorder;
  final bool isPassword;
  final bool readOnly;
  final bool isRequired;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final AutovalidateMode autoValidateMode;
  final String? hint;
  final bool isHasLabel;
  final bool? loadingItems;
  final bool isExpanded;
  final double? heightDropDown;

  const MultiDropdownTextInput({
    Key? key,
    required this.name,
    required this.items,
    this.errorText,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.hint,
    this.backgroundColor,
    this.borderRadius = 12,
    this.isShowBorder = false,
    this.isPassword = false,
    this.readOnly = false,
    this.isRequired = false,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.focusNode,
    this.labelText,
    this.isHasLabel = true,
    this.autoValidateMode = AutovalidateMode.disabled,
    //this.initialValues,
    this.loadingItems,
    this.isExpanded = true,
    this.heightDropDown,
  }) : super(key: key);

  @override
  _MultiDropdownTextInputState createState() => _MultiDropdownTextInputState();
}

class _MultiDropdownTextInputState extends State<MultiDropdownTextInput> {
  TextTheme get textTheme => Theme.of(context).textTheme;
  List<MultiOptionModel> get _selectedOptions =>
      widget.items.where((e) => e.checked).toList();

  InputBorder _inputBorder(Color color) => OutlineInputBorder(
      borderSide: widget.isShowBorder
          ? BorderSide(color: color, width: 2)
          : BorderSide.none,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.borderRadius),
          topRight: Radius.circular(widget.borderRadius),
          bottomLeft: Radius.circular(widget.borderRadius),
          bottomRight: Radius.circular(widget.borderRadius)));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initialVal =
        _selectedOptions.isNotEmpty ? _selectedOptions.first : null;
    return IgnorePointer(
      ignoring: widget.readOnly || !widget.enabled,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.labelText != null,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.labelText ?? '',
                          style: theme.textTheme.caption),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    PopupMenuButton<MultiOptionModel>(
                      child: IgnorePointer(
                        ignoring: true,
                        child: DropdownButtonFormField<MultiOptionModel>(
                          selectedItemBuilder: (_) => _selectedOptions.isEmpty
                              ? []
                              : [const SizedBox()],
                          items: _selectedOptions
                              .map((e) => buildMultiDropdownItem(e))
                              .toList(),
                          decoration: InputDecoration(
                            isDense: true,
                            errorText: widget.errorText,
                            errorStyle: theme.primaryTextTheme.headline4,
                            border: _inputBorder(Colors.transparent),
                            enabledBorder: _inputBorder(Colors.transparent),
                            focusedBorder: _inputBorder(theme.primaryColor),
                            errorBorder: _inputBorder(theme.colorScheme.error),
                            focusedErrorBorder:
                                _inputBorder(Colors.transparent),
                            disabledBorder: _inputBorder(Colors.transparent),
                            hintStyle: theme.textTheme.bodyText1,
                          ),
                          value: initialVal,
                          hint: Text(widget.hint ?? ''),
                          isExpanded: widget.isExpanded,
                          key: ValueKey(initialVal),
                          autovalidateMode: widget.autoValidateMode,
                          style: theme.primaryTextTheme.headline3,
                          focusColor: Colors.transparent,
                          onChanged: (value) {},
                          onSaved: widget.onSaved,
                          validator: widget.validator,
                        ),
                      ),
                      itemBuilder: (context) => widget.items
                          .map(
                            (e) => PopupMenuItem<MultiOptionModel>(
                              enabled: false,
                              value: e,
                              child: buildMultiDropdownItem(e),
                            ),
                          )
                          .toList(),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    _buildTags(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 16,
        children: _selectedOptions.map((e) => _buildTag(e)).toList(),
      ),
    );
  }

  Widget _buildTag(MultiOptionModel item) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue[100],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(item.name),
          const SizedBox(width: 12),
          SizedBox(
            height: 24,
            width: 24,
            child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    item.checked = !item.checked;
                    widget.onChanged?.call(_selectedOptions);
                  });
                },
                icon: const Icon(Icons.close)),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<MultiOptionModel> buildMultiDropdownItem(
      MultiOptionModel item) {
    return DropdownMenuItem<MultiOptionModel>(
      value: item,
      child: _CheckBoxItem(
        model: item,
        onChanged: (newValue) => setState(() {
          widget.onChanged?.call(_selectedOptions);
        }),
      ),
    );
  }
}

class _CheckBoxItem extends StatefulWidget {
  final MultiOptionModel model;
  final ValueChanged<MultiOptionModel>? onChanged;
  const _CheckBoxItem({Key? key, required this.model, this.onChanged})
      : super(key: key);

  @override
  _CheckBoxItemState createState() => _CheckBoxItemState();
}

class _CheckBoxItemState extends State<_CheckBoxItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        dense: false,
        title: Text(widget.model.name),
        autofocus: false,
        activeColor: Theme.of(context).textTheme.bodyText2!.color,
        controlAffinity: ListTileControlAffinity.leading,
        checkColor: Colors.white,
        selected: widget.model.checked,
        value: widget.model.checked,
        onChanged: (bool? value) {
          setState(() {
            widget.model.checked = value ?? false;
            widget.onChanged?.call(widget.model);
          });
        },
      ),
    );
  }
}
