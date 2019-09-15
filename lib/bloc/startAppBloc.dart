import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/authBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:rxdart/rxdart.dart';

class StartAppBloc {
  StartAppBloc() {
    authBloc.uiEvents.listen(_listenForUiEvents);
  }
  final AuthBloc authBloc = BlocProvider.getBloc<AuthBloc>();
  final _listenableEvents = [UiEventUserAuthenticated, UiEventNeedRegister];
  
  final _uiEvents = BehaviorSubject<UiEventLogin>();
  Stream<UiEventLogin> get uiEvents => _uiEvents.stream;
  
  void _listenForUiEvents(UiEventLogin event) {
    if (_listenableEvents.contains(event))
      _uiEvents.add(event);
  }
  
  dispose() {
    _uiEvents.close();
  }
}