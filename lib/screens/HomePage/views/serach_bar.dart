// 你可以创建一个新文件 beautiful_search_bar.dart

import 'package:etherstash/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class BeautifulSearchBar extends StatefulWidget {
  const BeautifulSearchBar({
    super.key,
    this.onChanged,
    this.onClose,
  });

  // 回调函数，当文字改变时通知父组件
  final Function(String)? onChanged;
  final Function()? onClose;

  @override
  State<BeautifulSearchBar> createState() => _BeautifulSearchBarState();
}

class _BeautifulSearchBarState extends State<BeautifulSearchBar> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _controller,
        autofocus: true,
        onTapOutside: (event) {
          if (_controller.text.isEmpty&&widget.onClose != null){
            widget.onClose!();
          }
        },
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.search_bar_hint_text,
          hintStyle: TextStyle(color: Theme.of(context).hintColor),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  onPressed: () {
                    _controller.clear();
                    if (widget.onClose != null) {
                      widget.onClose!();
                    }
                  },
                ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }
}
