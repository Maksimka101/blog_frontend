import 'package:blog_frontend/ui/entity/uiPostEntity.dart';
import 'package:blog_frontend/ui/widgets/common/commonNewsCard.dart';
import 'package:flutter/material.dart';

class NewsScreenNewsCard extends StatefulWidget {
  NewsScreenNewsCard(
      {this.scrollPosition, this.post, this.currentPostIndex, this.onExpanded});

  final UiPostEntity post;
  final Stream<double> scrollPosition;
  final int currentPostIndex;
  final void Function(bool) onExpanded;

  @override
  _NewsScreenNewsCardState createState() => _NewsScreenNewsCardState();
}

class _NewsScreenNewsCardState extends State<NewsScreenNewsCard>
    with TickerProviderStateMixin {
  var _sizeFactor = 0.0;
  var _isDisposed = false;
  var _isExpanded = false;
  var _paddingHeight = 0.0;

  @override
  void initState() {
    if (widget.currentPostIndex != 0) _sizeFactor = 0.5;
    widget.scrollPosition.listen(_listenForPage);
    super.initState();
  }

  void _listenForPage(double position) {
    if (!_isDisposed) {
      final abs = (widget.currentPostIndex - position).abs();
      if (abs <= 1.5 && abs >= 0.5)
        setState(() {
          _sizeFactor = 0.5 - (1 - abs);
          _isExpanded = false;
          widget.onExpanded(_isDisposed);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_paddingHeight == 0.0) {
      _paddingHeight = MediaQuery.of(context).size.height * 0.15;
    }
    return Padding(
      padding: EdgeInsets.only(
        top: !_isExpanded ? _paddingHeight * _sizeFactor : 0,
      ),
      child: SizedBox(
        height: !_isExpanded
            ? MediaQuery.of(context).size.height * 0.7 -
                _sizeFactor * _paddingHeight * 0.7
            : null,
        child: GestureDetector(
          onTap: () => setState(() {
            _isExpanded = !_isExpanded;
            widget.onExpanded(_isExpanded);
          }),
          child: AnimatedSize(
            duration: Duration(milliseconds: 200),
            vsync: this,
            child: CommonNewsCard(
              isExpanded: _isExpanded,
              imageUrl: widget.post.imageUrl,
              title: widget.post.title,
              commentsCount: widget.post.comments.length,
              content: widget.post.content,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
