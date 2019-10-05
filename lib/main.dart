import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/findUserBloc.dart';
import 'package:blog_frontend/bloc/globalBloc.dart';
import 'package:blog_frontend/bloc/mainAppScreenBloc.dart';
import 'package:blog_frontend/bloc/newsFeedBloc.dart';
import 'package:blog_frontend/bloc/startAppBloc.dart';
import 'package:blog_frontend/bloc/userPostsBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:blog_frontend/repository/internalRepository.dart';
import 'package:blog_frontend/ui/screens/errorScreen.dart';
import 'bloc/authBloc.dart';
import 'ui/screens/loadScreen.dart';
import 'package:flutter/material.dart';
import 'ui/screens/signin/signInScreen.dart';
import 'ui/screens/mainAppScreen.dart';

main() => runApp(SetupBlocProvider());

class SetupBlocProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
        theme: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.deepPurple
          ),
            primaryColorLight: Colors.deepPurple,
            primaryColorDark: Colors.deepPurple,
            buttonColor: Colors.deepPurple[400],
            primaryColor: Colors.deepPurple,
            appBarTheme: AppBarTheme(color: Colors.deepPurple)),
      ),
      blocs: <Bloc>[
        Bloc((inject) => AuthBloc()),
        Bloc((inject) => GlobalBloc()),
        Bloc((inject) => NewsFeedBloc()),
        Bloc((inject) => FindUserBloc()),
        Bloc((inject) => UserPostsBloc()),
        Bloc((inject) => MainAppScreenBloc()),
      ],
      dependencies: <Dependency>[
        Dependency((i) => InternalRepository()),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthBloc>(
      builder: (context, bloc) {
        return StreamBuilder<UiEventLogin>(
          stream: StartAppBloc(bloc).uiEvents,
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData)
              return LoadScreen();
            else {
              if (userSnapshot.data.runtimeType == UiEventNeedRegister)
                return SignInScreen();
              else if (userSnapshot.data.runtimeType ==
                  UiEventUserIsAuthenticated)
                return MainAppScreen();
              else if (userSnapshot.data.runtimeType ==
                  UiEventLoadAuthorizedUserError)
                return ErrorScreen(
                  errorMessage:
                      (userSnapshot.data as UiEventLoadAuthorizedUserError)
                          .errorMessage,
                );
              else
                return LoadScreen();
            }
          },
        );
      },
    );
  }
}

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInScreen();
  }
}
