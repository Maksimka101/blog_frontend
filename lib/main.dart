import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/globalBloc.dart';
import 'package:blog_frontend/bloc/startAppBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:blog_frontend/repository/backendRepository.dart';
import 'package:blog_frontend/repository/cacheRepository.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'bloc/authBloc.dart';
import 'ui/screens/loadScreen.dart';
import 'package:flutter/material.dart';
import 'ui/screens/loginScreen.dart';
import 'ui/screens/newsFeedScreen.dart';

main() => runApp(SetupBlocProvider());

class SetupBlocProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        home: TestApp(),
        theme: ThemeData(
          buttonColor: const Color.fromARGB(255, 120, 0, 80),
          appBarTheme: AppBarTheme(
            color: const Color.fromARGB(255, 120, 0, 80),
          )
        ),
      ),
      blocs: [
        Bloc((inject) => AuthBloc()),
        Bloc((inject) => GlobalBloc()),
      ],
      dependencies: [
        Dependency((i) => InternalRepository()..loadClient()),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UiEventLogin>(
      stream: StartAppBloc(BlocProvider.getBloc<AuthBloc>()).uiEvents,
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData)
          return LoadScreen();
        else {
          if (userSnapshot.data.runtimeType == UiEventRegister)
            return LoginScreen();
          else if (userSnapshot.data.runtimeType == UiEventUserAuthenticated)
            return NewsFeedScreen();
          else
            return LoadScreen();
        }
      },
    );
  }
}

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    InternalRepositoryClient.instance = InternalRepositoryClient(
        name: '4d32d456-132d-4920-85e5-f83b05161737', password: 'Password');
    BackendRepository.getUserByName('').then((v) {
      for (final i in v.typedBody.list) print(i);
    });
    return LoadScreen();
  }
}
