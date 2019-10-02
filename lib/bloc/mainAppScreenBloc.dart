import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';

class MainAppScreenBloc extends BlocBase {
  final _pageStream = StreamController<int>.broadcast();

  Stream<int> get page => _pageStream.stream;

  StreamSink<int> get addPage => _pageStream.sink;

  @override
  void dispose() {
    _pageStream.close();
    super.dispose();
  }
}
