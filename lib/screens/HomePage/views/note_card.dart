// 你可以把这个新 Widget 放在 NoteListView 文件的下面，或者单独创建一个文件

import 'package:etherstash/l10n/app_localizations.dart';
import 'package:etherstash/providers/my_app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/utils.dart';


import '../../../models/note.dart';


class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, 
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          print("tapped ${note.id} ");
        },
        onLongPress: () {
          print("long pressed ${note.id} ");
          context.read<MyAppState>().deleteNote(note).then(
            (value) {
              if (context.mounted)
              {ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.sync_success)),
              );}
            },
            onError: (error) {
              if (context.mounted){ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.sync_failed)),
              );}
            }
          );
        },
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
                '${note.createdAt.year}-${note.createdAt.month}-${note.createdAt.day}-${note.createdAt.hour}:${note.createdAt.minute}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
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
        maxLines: null,
        onSubmitted: (value) {
          setState(() {
            _editing = false;
            context.read<MyAppState>().saveNote(widget.note.copyWith(content: value, createdAt: DateTime.now()));
          });
        },
        onTapOutside: (event) {
          String currentValue = _controller.text;
          print('TextField value: $currentValue');
            context.read<MyAppState>().saveNote(widget.note.copyWith(content: currentValue)).then(
              (value) {
                if (mounted)
                {ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.sync_success)),
                );}
              },
              onError: (error) {
                if (mounted)
                {ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.sync_failed)),
                );}
              }
            );
          setState(() {
            _editing = false;
          });
        },
      );
    }
    else {
    return GestureDetector(
      onTap: _startEditing,
      child: buildHighlightedText(widget.note.content.isEmpty ? AppLocalizations.of(context)!.empty_note_placeholder : widget.note.content,
       context.read<MyAppState>().searchParam, 
       Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: widget.note.content.isEmpty ? Colors.grey : null,
      )
      ),
      
    );
  }
  }
}