import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/findUserBloc.dart';
import 'package:blog_frontend/bloc/globalBloc.dart';
import 'package:blog_frontend/bloc/mainAppScreenBloc.dart';
import 'package:blog_frontend/bloc/newsFeedBloc.dart';
import 'package:blog_frontend/bloc/settingsBloc.dart';
import 'package:blog_frontend/bloc/startAppBloc.dart';
import 'package:blog_frontend/bloc/userPostsBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:blog_frontend/repository/internalRepository.dart';
import 'package:blog_frontend/ui/screens/errorScreen.dart';
import 'package:flutter/material.dart';

import 'bloc/authBloc.dart';
import 'ui/screens/loadScreen.dart';
import 'ui/screens/mainAppScreen.dart';
import 'ui/screens/signin/signInScreen.dart';

main() => runApp(SetupBlocProvider());

class SetupBlocProvider extends StatelessWidget {
  ThemeData _getVailTheme() {
    final _primaryColor = Colors.grey[850];
    final _backgroundColor = Color(0xFF121212);
    return ThemeData(
        textTheme: TextTheme(

          /// only title
            title: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 22),

            /// card body, comment text, card text
            body1: TextStyle(
              color: Colors.purple[100],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),

            /// hint text style
            subtitle: TextStyle(
              color: Colors.grey[500],
            ),

            /// only for choose avatar text
            body2: TextStyle(
                color: Colors.purple[200],
                fontStyle: FontStyle.italic,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        iconTheme: IconThemeData(color: Colors.deepPurpleAccent[100]),
        primaryColorLight: Colors.deepPurpleAccent[100],
        primaryColorDark: _primaryColor,
        dividerColor: Colors.grey[600],
        accentColor: Colors.purple[200],
        backgroundColor: _primaryColor,
        canvasColor: _backgroundColor,
        cardColor: _primaryColor,
        buttonColor: Colors.grey[700],
        primaryColor: _primaryColor,
        appBarTheme: AppBarTheme(
          color: _primaryColor,
        ));
  }

  ThemeData _mainTheme() {
    final _primaryColor = Colors.grey[850];
    final _backgroundColor = Color(0xFF121212);
    return ThemeData(
        textTheme: TextTheme(

          /// only title
            title: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 22),

            /// card body, comment text, card text
            body1: TextStyle(
              color: Colors.grey[300],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),

            /// hint text style
            subtitle: TextStyle(
              color: Colors.grey[400],
            ),

            /// only for choose avatar text
            body2: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        iconTheme: IconThemeData(color: Colors.white),
        snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.grey[700]
        ),
        primaryColorLight: Colors.white,
        primaryColorDark: _primaryColor,
        dividerColor: Colors.grey,
        accentColor: Colors.grey,
        backgroundColor: _primaryColor,
        canvasColor: _backgroundColor,
        cardColor: _primaryColor,
        buttonColor: Colors.grey[700],
        primaryColor: _primaryColor,
        appBarTheme: AppBarTheme(
          color: _primaryColor,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyApp(),
          theme: _mainTheme()
      ),
      blocs: <Bloc>[
        Bloc((inject) => AuthBloc()),
        Bloc((inject) => GlobalBloc()),
        Bloc((inject) => NewsFeedBloc()),
        Bloc((inject) => FindUserBloc()),
        Bloc((inject) => UserPostsBloc()),
        Bloc((inject) => SettingsBloc()),
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
