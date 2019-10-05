import 'dart:io';

import 'package:blog_frontend/bloc/createPostBloc.dart';
import 'package:blog_frontend/events/createPostEvents.dart';
import 'package:blog_frontend/ui/entity/uiPostEntity.dart';
import 'package:blog_frontend/ui/widgets/common/commonNewsCard.dart';
import 'package:blog_frontend/ui/widgets/common/errorAlertDialog.dart';
import 'package:blog_frontend/ui/widgets/common/offsetAppbar.dart';
import 'package:blog_frontend/ui/widgets/common/offsetTabBar.dart';
import 'package:blog_frontend/ui/widgets/common/roundedCard.dart';
import 'package:blog_frontend/utils/validators.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({this.previousPost});
  final UiPostEntity previousPost;

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _bloc = CreatePostBloc();
  final _formController = GlobalKey<FormState>();
  final _eventCreatePost = EventCreatePost();
  final _validator = CreatePostValidator();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _bloc.errorEvents
        .listen((error) => showAlertDialog(context, error.errorMessage));
    _bloc.uiEvents.listen(_listenUiEvents);
    if (widget.previousPost != null) {
      _eventCreatePost.title = widget.previousPost.title;
      _eventCreatePost.content = widget.previousPost.content;
      _eventCreatePost.id = widget.previousPost.id;
      _eventCreatePost.imageUrl = widget.previousPost.imageUrl;
      _eventCreatePost.date = widget.previousPost.createDate;
    }
    super.initState();
  }

  void _listenUiEvents(CreatePostUiEvent event) {
    if (event.runtimeType == UiEventPostCreated)
      Navigator.pop(context);
    else if (event.runtimeType == UiEventLoading)
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Обработка данных, это может занять много времени.'),
        duration: Duration(seconds: 50),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: OffsetAppBar(
        title: Text('Что нового?'),
      ),
      body: _CreatePostBody(
        formController: _formController,
        validator: _validator,
        eventCreatePost: _eventCreatePost,
        uiEvents: _bloc.uiEvents,
      ),
      bottomNavigationBar: OffsetBottomBar(
        child: <Widget>[
          Expanded(
            child: FlatButton.icon(
                onPressed: () {
                  if (_formController.currentState.validate()) {
                    _eventCreatePost.content = _validator.content;
                    _eventCreatePost.title = _validator.title;
                    _bloc.events.add(_eventCreatePost);
                  }
                },
                icon: CircleAvatar(
                  child: Icon(
                    Icons.done,
                    color: AppBarTheme.of(context).color,
                  ),
                  backgroundColor: Colors.white,
                ),
                label: Text(
                  'Создать',
                  style: TextStyle(color: Colors.white),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTapDown: (details) {
                _eventCreatePost.content = _validator.content;
                _eventCreatePost.title = _validator.title;
                _bloc.events
                    .add(EventShowPreview.fromCreatePost(_eventCreatePost));
              },
              onTapUp: (details) {
                _bloc.events.add(EventClosePreview());
              },
              onTapCancel: () {
                _bloc.events.add(EventClosePreview());
              },
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: CircleAvatar(
                        child: Icon(
                          Icons.remove_red_eye,
                          color: AppBarTheme.of(context).color,
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Text(
                      'Предпросмотр',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class _CreatePostBody extends StatefulWidget {
  _CreatePostBody(
      {@required this.formController,
      @required this.validator,
      @required this.eventCreatePost,
      @required this.uiEvents,
      File image}) {
    if (eventCreatePost.image == null) eventCreatePost.image = image;
  }

  final Stream<CreatePostUiEvent> uiEvents;
  final CreatePostValidator validator;
  final GlobalKey<FormState> formController;
  final EventCreatePost eventCreatePost;

  @override
  _CreatePostBodyState createState() => _CreatePostBodyState();
}

class _CreatePostBodyState extends State<_CreatePostBody> {
  void _pickImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    widget.eventCreatePost.image = image;
    widget.eventCreatePost.imageUrl = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        SingleChildScrollView(
          child: Form(
            onChanged: () => widget.formController.currentState.validate(),
            key: widget.formController,
            child: Column(
              children: <Widget>[
                RoundedCard(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    validator: widget.validator.titleValidator,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    minLines: 1,
                    initialValue: widget.eventCreatePost.title ?? '',
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        hintStyle: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                        hintText: 'Название'),
                  ),
                ),
                RoundedCard(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        initialValue: widget.eventCreatePost.content ?? '',
                        validator: widget.validator.contentValidator,
                        minLines: 15,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 25,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800]),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            hintText: 'Содержание'),
                      ),
                      FlatButton.icon(
                          onPressed: _pickImage,
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.grey[600],
                          ),
                          label: Text(
                            'Добавить фото',
                            style: TextStyle(color: Colors.grey[700]),
                          )),
                    ],
                  ),
                ),
                if (widget.eventCreatePost.image != null)
                  RoundedCard(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          child: Image.file(widget.eventCreatePost.image),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ],
                    ),
                  ),
                if (widget.eventCreatePost.imageUrl != null)
                  RoundedCard(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          child: CachedNetworkImage(
                              imageUrl: widget.eventCreatePost.imageUrl),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ],
                    ),
                  ),
                if (widget.eventCreatePost.imageUrl == null &&
                    widget.eventCreatePost.image == null)
                  RoundedCard(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    margin: EdgeInsets.all(8),
                    child: Text('Не забудьте добавить картинку', style: TextStyle(color: Colors.grey),),
                  ),
              ],
            ),
          ),
        ),
        StreamBuilder<CreatePostUiEvent>(
          stream: widget.uiEvents,
          builder: (context, eventSnap) {
            if (!eventSnap.hasData)
              return Container();
            else {
              if (eventSnap.data.runtimeType == UiEventShowPreview) {
                final event = eventSnap.data as UiEventShowPreview;
                return Container(
                  color: Colors.white70,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8 -
                            kBottomNavigationBarHeight,
                        child: CommonNewsCard(
                          title: event.title,
                          isExpanded: false,
                          content: event.content,
                          commentsCount: 0,
                          imageUrl: event.imageUrl,
                          image: event.image,
                        ),
                      ),
                    ),
                  ),
                );
              } else
                return Container();
            }
          },
        )
      ],
    );
  }
}
