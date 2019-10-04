import 'package:blog_frontend/model/contants.dart';
import 'package:blog_frontend/ui/widgets/common/roundedCard.dart';
import 'package:flutter/material.dart';

class NewsToolCard extends StatefulWidget {
  NewsToolCard({
    @required this.index,
    @required this.child,
    @required this.scrollPosition,
  });

  final int index;
  final Widget child;
  final Stream<double> scrollPosition;

  @override
  _NewsToolCardState createState() => _NewsToolCardState();
}

class _NewsToolCardState extends State<NewsToolCard>
    with TickerProviderStateMixin {
  var _isDisposed = false;
  var _sizeFactor = 1.0;

  @override
  void initState() {
    if (widget.index != 0) _sizeFactor = 0.5;

    widget.scrollPosition.listen(_listenForPage);
    super.initState();
  }

  void _listenForPage(double position) {
//    print('card id: ${widget.index}');
//    print('out of set state: $position, is Disposed: $_isDisposed');
    final abs = (widget.index - position).abs();
    if (abs <= 1.3 && !_isDisposed && abs >= 0.5)
      setState(() {
//        print('in set state: $position');
        _sizeFactor = 0.5 + (1 - abs);
      });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - toolAndAppBarHeight,
      ),
      child: FractionallySizedBox(
        widthFactor: _sizeFactor,
        child: RoundedCard(child: widget.child),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
