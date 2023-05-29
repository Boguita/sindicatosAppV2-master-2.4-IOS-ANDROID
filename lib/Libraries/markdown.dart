import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

Widget contentMarkDown(htmlData) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: SingleChildScrollView(
      child: Container(
        child: MarkdownBody(
          data: htmlData,
        ),
      ),
    ),
  );
}
