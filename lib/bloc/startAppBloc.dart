import 'package:blog_frontend/bloc/authBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:rxdart/rxdart.dart';

class StartAppBloc {
  StartAppBloc(this.authBloc) {
    authBloc.uiEvents.listen(_listenForUiEvents);
  }
  final AuthBloc authBloc;
  final _listenableEvents = [UiEventUserIsAuthenticated, UiEventNeedRegister];
  
  final _uiEvents = BehaviorSubject<UiEventLogin>();
  Stream<UiEventLogin> get uiEvents => _uiEvents.stream;
  
  void _listenForUiEvents(UiEventLogin event) {
    if (_listenableEvents.contains(event.runtimeType)) {
      _uiEvents.add(event);
    }
  }
  
  dispose() {
    _uiEvents.close();
  }
}