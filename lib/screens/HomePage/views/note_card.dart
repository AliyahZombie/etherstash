// 你可以把这个新 Widget 放在 NoteListView 文件的下面，或者单独创建一个文件

import 'package:etherstash/l10n/app_localizations.dart';
import 'package:etherstash/providers/my_app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../models/note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("tapped ${note.id} ");
      },
      onLongPress: () {
        print("long pressed ${note.id} ");
        context.read<MyAppState>().deleteNote(note);
      },
      child: Card(
        clipBehavior: Clip.antiAlias, // 防止内容溢出圆角
        elevation: 4.0, // 给卡片一点阴影，让它"浮"起来
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 内容靠左对齐
            children: [
              // 笔记内容
              EditableText(note: note),
              const SizedBox(height: 8), // 加一点垂直间距
              // 创建日期
              Text(
                // 这里简单格式化一下日期，未来可以用 intl 包做得更漂亮
                '${note.createdAt.year}-${note.createdAt.month}-${note.createdAt.day}-${note.createdAt.hour}:${note.createdAt.minute}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700], // 用小一点、灰色一点的字体
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditableText extends StatefulWidget {
  const EditableText({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  State<EditableText> createState() => _EditableTextState();
  
}

class _EditableTextState extends State<EditableText> {
  bool _editing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _startEditing() {
    setState(() {
      _editing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return TextField(
        controller: _controller,
        autofocus: true,
        onSubmitted: (value) {
          setState(() {
            _editing = false;
            context.read<MyAppState>().saveNote(widget.note.copyWith(content: value, createdAt: DateTime.now()));
          });
        },
        onTapOutside: (event) {
          String currentValue = _controller.text;
          print('TextField value: $currentValue');
          context.read<MyAppState>().saveNote(widget.note.copyWith(content: currentValue));
          setState(() {
            _editing = false;
          });
        },
      );
    }
    else {
    return GestureDetector(
      onTap: _startEditing,
      child: Text(
        widget.note.content.isEmpty ? AppLocalizations.of(context)!.empty_note_placeholder : widget.note.content,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: widget.note.content.isEmpty ? Colors.grey : null,
        ), // 用主题里定义好的大字体样式
      ),
    );
  }
  }
}