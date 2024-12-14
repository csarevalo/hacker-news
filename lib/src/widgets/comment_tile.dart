import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';

import '../models/comment_model.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
    required this.children,
    required this.depthLevel,
  });

  final CommentModel comment;
  final List<Widget> children;
  final int depthLevel;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty || depthLevel >= 5) {
      return Card(
        margin: EdgeInsets.fromLTRB(depthLevel * 4.0, 4.0, 4.0, 4.0),
        child: ListTile(
          title: HtmlWidget(
            'By ${comment.by} at ${DateFormat.yMd().add_jm().format(comment.created)}<br><br>',
          ),
          titleTextStyle: const TextStyle(fontSize: 11, color: Colors.amber),
          subtitle: HtmlWidget(comment.text),
        ),
      );
    }
    return Card(
      // color: Colors.transparent,
      margin: EdgeInsets.fromLTRB(depthLevel * 4.0, 4.0, 4.0, 4.0),
      child: ExpansionTile(
        initiallyExpanded: depthLevel <= 5,
        maintainState: true,
        enabled: depthLevel <= 5,
        tilePadding: EdgeInsets.only(left: 16.0 + depthLevel * 2, right: 16.0),
        title: HtmlWidget(
          'By ${comment.by} at ${DateFormat.yMd().add_jm().format(comment.created)}<br><br>',
          textStyle: const TextStyle(fontSize: 11, color: Colors.amber),
        ),
        subtitle: HtmlWidget(comment.text),
        children: children,
      ),
    );
  }
}
