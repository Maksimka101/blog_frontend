import 'package:bloc_pattern/bloc_pattern.dart';
import 'bloc/AuthBloc.dart';
import 'ui/screens/loadScreen.dart';
import 'package:flutter/material.dart';
import 'model/user.dart';
import 'ui/screens/loginScreen.dart';
import 'ui/screens/newsFeedScreen.dart';

main() => runApp(SetupBlocProvider());

class SetupBlocProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: TestApp(),
      blocs: [Bloc((inject) => AuthBloc())],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User>(
        stream: BlocProvider.getBloc<AuthBloc>().userStream,
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return LoadScreen();
          } else {
            if (userSnapshot.data != null)
              return LoginScreen();
            else {
              return NewsFeedScreen();
            }
          }
        },
      ),
    );
  }
}

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
