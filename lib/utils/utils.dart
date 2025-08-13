// 你可以把这个函数放在一个公共的 utils 文件里，或者直接放在 NoteCard 所在文件的顶部

import 'package:flutter/material.dart';

RichText buildHighlightedText(String text, String highlight, TextStyle? defaultStyle) {
  // 如果高亮词为空，直接返回普通文本，避免出错
  if (highlight.isEmpty) {
    return RichText(text: TextSpan(text: text, style: defaultStyle));
  }

  // 定义高亮部分的样式
  final highlightedStyle = defaultStyle?.copyWith(
    backgroundColor: Colors.yellow[700], // 给一个醒目的黄色背景
    fontWeight: FontWeight.bold,
  ) ?? const TextStyle(
    backgroundColor: Colors.yellow,
    fontWeight: FontWeight.bold,
  );

  final List<TextSpan> spans = [];
  int start = 0;
  int indexOfHighlight;

  // 使用循环来查找所有匹配项
  while ((indexOfHighlight = text.toLowerCase().indexOf(highlight.toLowerCase(), start)) != -1) {
    // 1. 添加高亮词之前的普通文本
    if (indexOfHighlight > start) {
      spans.add(TextSpan(
        text: text.substring(start, indexOfHighlight),
        style: defaultStyle,
      ));
    }

    // 2. 添加高亮显示的文本
    spans.add(TextSpan(
      text: text.substring(indexOfHighlight, indexOfHighlight + highlight.length),
      style: highlightedStyle,
    ));

    // 3. 更新下一次搜索的起始位置
    start = indexOfHighlight + highlight.length;
  }

  // 4. 添加最后一个匹配项之后的剩余文本
  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start), style: defaultStyle));
  }

  return RichText(text: TextSpan(children: spans));
}
