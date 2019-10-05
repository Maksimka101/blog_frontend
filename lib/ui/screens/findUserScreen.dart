import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/findUserBloc.dart';
import 'package:blog_frontend/events/findUserEvents.dart';
import 'package:blog_frontend/ui/widgets/common/roundedCard.dart';
import 'package:blog_frontend/ui/widgets/common/userTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class FindUserScreen extends StatelessWidget {
  final _findUserBloc = BlocProvider.getBloc<FindUserBloc>();

  void _listenForInput(String name) {
    _findUserBloc.addFindEvents.add(EventFindUserByName(name: name));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: RoundedCard(
            child: Padding(
              padding: const EdgeInsets.only(left: 7),
              child: TextField(
                onChanged: _listenForInput,
                style: Theme
                    .of(context)
                    .textTheme
                    .title,
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintStyle: Theme
                      .of(context)
                      .textTheme
                      .title,
                  hintText: 'Введите ник пользователя',
                ),
              ),
            ),
          ),
        ),
        StreamBuilder<FindUiEvent>(
          stream: _findUserBloc.uiEvents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.runtimeType == UiEventFoundUsers) {
                final users = (snapshot.data as UiEventFoundUsers).users;
                final subscriptions =
                    (snapshot.data as UiEventFoundUsers).subscriptions;
                if (users.isNotEmpty)
                  return SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: users
                            .map((user) => _UserItem(
                                  imageUrl: user.imageUrl,
                                  name: user.name,
                                  isSubscribe:
                                      subscriptions.contains(user.name),
                                  onClick: (name) {
                                    if (!subscriptions.contains(name))
                                      _findUserBloc.addFindEvents
                                          .add(EventSubscribeUser(name: name));
                                    else
                                      _findUserBloc.addFindEvents.add(
                                          EventUnsubscribeUser(name: name));
                                  },
                                ))
                            .toList()),
                  );
                else {
                  return Center(
                    child: RoundedCard(
                      margin: const EdgeInsets.all(8.0),
                      child: Text(
                        'Никого не найдено.',
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              } else if (snapshot.data.runtimeType == UiEventError) {
                final errorMessage =
                    (snapshot.data as UiEventError).errorMessage;
                return Center(
                  child: RoundedCard(
                      child: Text(
                    errorMessage,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
                );
              } else {
                return Center(
                  child: RoundedCard(
                      margin: const EdgeInsets.all(8.0),
                      child: Text(
                    'Uncknown error',
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1,
                    textAlign: TextAlign.center,
                  )),
                );
              }
            } else {
              return Center(
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: RoundedCard(
                    margin: const EdgeInsets.all(8.0),
                    child: Text(
                      'Начните вводить ник и вы сразу увидите людей с похожими именами.\n(После ввода третьего символа)',
                      style: Theme
                          .of(context)
                          .textTheme
                          .body1,
                      textAlign: TextAlign.center,
                    ),
                  )
                ),
              );
            }
          },
        )
      ],
    );
  }
}

class _UserItem extends StatefulWidget {
  _UserItem({
    this.name,
    this.imageUrl,
    this.onClick,
    this.isSubscribe,
  });

  final String imageUrl;
  final String name;
  final bool isSubscribe;
  final void Function(String i) onClick;

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<_UserItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: RoundedCard(
        child: UserTile(
          onClick: () {},
          imageUrl: widget.imageUrl,
          userName: widget.name,
          button: IconButton(
            onPressed: () => widget.onClick(widget.name),
            icon: Icon(
                !widget.isSubscribe ? Icons.add_circle : Icons.remove_circle),
          ),
        ),
      ),
    );
  }
}
