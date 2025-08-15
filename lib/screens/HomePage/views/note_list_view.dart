// 别忘了在文件顶部导入我们的魔法师！
import 'package:etherstash/l10n/app_localizations.dart';
import 'package:etherstash/screens/HomePage/views/note_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:etherstash/providers/my_app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class NoteListView extends StatelessWidget {
  const NoteListView({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<MyAppState>().filteredNotes;


    if (notes.isNotEmpty){
      return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 375),
          child: AnimationLimiter(
            key: ValueKey(notes.length),
            child: MasonryGridView.count(
              key: ValueKey(notes.length), // 为 GridView 添加 key
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), // 给整个墙一个边距
              crossAxisCount: constraints.maxWidth > 700 ? 3 : 2,     
              mainAxisSpacing: 16.0,  // 卡片之间的垂直间距
              crossAxisSpacing: 16.0, // 卡片之间的水平间距
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: constraints.maxWidth > 700 ? 3 : 2,
                  child: FadeInAnimation(
                    child: NoteCard(key: ValueKey(notes[index].id), note: notes[index]),
                  ),
                );
              },
              shrinkWrap: true, // 添加 shrinkWrap 以适应 AnimatedSwitcher
            ),
          ),
        );
      }
    );
  }else{
    return Center(
      child: context.read<MyAppState>().searchParam.isEmpty ? Text(AppLocalizations.of(context)!.no_notes) :  Text(AppLocalizations.of(context)!.no_matches),
    );
  }
  
  }
}