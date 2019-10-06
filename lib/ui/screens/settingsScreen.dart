import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/settingsBloc.dart';
import 'package:blog_frontend/events/settingsEvents.dart';
import 'package:blog_frontend/ui/widgets/common/loadingWidget.dart';
import 'package:blog_frontend/ui/widgets/settings/userInfoWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsBloc _settingsBloc = BlocProvider.getBloc<SettingsBloc>();

  void _initScreen(BuildContext context) {
    _settingsBloc.events.add(EventLoadUserInfo());
    _settingsBloc.uiEvents.listen((event) =>
        _listenForUiEvents(event, context));
  }

  void _listenForUiEvents(SettingsUiEvent event, BuildContext context) {
    switch (event.runtimeType) {
      case UiEventUserImageLoading:
        _showSnackBar(
            'Загрузка изображения. Это может занять много времени.', context);
        break;
      case ErrorUiEvent:
        _showSnackBar((event as ErrorUiEvent).errorMessage, context);
        break;
    }
  }

  void _showSnackBar(String message, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 6),
      content: Text(message, style: Theme
          .of(context)
          .textTheme
          .subtitle,),
    ));
  }

  void _pickIconImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null)
      _settingsBloc.events.add(EventChangeUserIcon(
          image: image
      ));
  }

  @override
  Widget build(BuildContext context) {
    _initScreen(context);
    return ListView(
      children: <Widget>[
        StreamBuilder<SettingsUiDataEvent>(
          stream: _settingsBloc.dataEvents,
          builder: (c, userInfoSnap) {
            if (userInfoSnap.hasData) {
              final info = userInfoSnap.data as UiEventUserInfo;
              return UserInfoWidget(
                imageUrl: info.imageUrl,
                name: info.name,
                onClickOnImage: _pickIconImage,
              );
            } else
              return LoadingWidget();
          },
        ),
      ],
    );
  }
}
