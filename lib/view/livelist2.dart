import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:just_audio/just_audio.dart';
import 'package:parse_deneme/constants.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class LiveList2 extends StatefulWidget {
  @override
  _LiveList2State createState() => _LiveList2State();
}

class _LiveList2State extends State<LiveList2> {
  bool initFailed;

  QueryBuilder<ParseObject> _queryBuilder;
  final LiveQuery liveQuery = LiveQuery();
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    initData().then((bool success) {
      setState(() {
        initFailed = !success;
        if (success)
          _queryBuilder = QueryBuilder<ParseObject>(ParseObject('siparisler'))
            ..orderByAscending('fiyat');
      });
    }).catchError((dynamic _) {
      setState(() {
        initFailed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('LiveList example app'),
        ),
        body: initFailed == false
            ? buildBody(context)
            : Container(
                height: double.infinity,
                alignment: Alignment.center,
                child: initFailed == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          CircularProgressIndicator(),
                          Text('Connecting to the server...'),
                        ],
                      )
                    : const Text('Connecting to the server failed!'),
              ),
      ),
    );
  }

  Future<bool> initData() async {
    await Parse().initialize(keyParseApplicationId, keyParseServerUrl,
        clientKey: keyParseClientKey,
        debug: true,
        //debug: keyDebug,
        liveQueryUrl: keyLiveQuery);

    return (await Parse().healthCheck()).success;
  }

  Widget buildBody(BuildContext context) {
    final GlobalKey<_ObjectFormState> objectFormKey =
        GlobalKey<_ObjectFormState>();
    return Column(
      children: <Widget>[
        RaisedButton(
            child: Text('asd'),
            onPressed: () async {
              //veri ekleme
              var dietPlan = ParseObject('siparisler')
                ..set('yemek', 'Ketogenic')
                ..set('fiyat', 65);
              await dietPlan.save();
            }),
        Expanded(
          child: ParseLiveListWidget<ParseObject>(
              query: _queryBuilder,
              //duration: const Duration(seconds: 1),
              childBuilder: (BuildContext context,
                  ParseLiveListElementSnapshot<ParseObject> snapshot) {
                if (snapshot.failed) {
                  return const Text('something went wrong!');
                } else if (snapshot.hasData) {
                  //FlutterBeep.beep(false);

                  player.play();
                  return Column(
                    children: [
                      RaisedButton(
                          child: Text("Beep Fail"),
                          onPressed: () => FlutterBeep.beep(false)),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(snapshot.preLoadedData
                                .get<int>('fiyat')
                                .toString()),
                            flex: 1,
                          ),
                          Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                snapshot.loadedData.get<String>('yemek'),
                              ),
                            ),
                            flex: 10,
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const ListTile(
                    leading: CircularProgressIndicator(),
                  );
                }
              }),
        ),
        Container(
          color: Colors.black12,
          child: ObjectForm(
            key: objectFormKey,
          ),
        )
      ],
    );
  }
}

class ObjectForm extends StatefulWidget {
  const ObjectForm({Key key}) : super(key: key);

  @override
  _ObjectFormState createState() => _ObjectFormState();
}

class _ObjectFormState extends State<ObjectForm> {
  ParseObject _currentObject;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void setObject(ParseObject object) {
    setState(() {
      _currentObject = object;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _currentObject == null
        ? Container()
        : Form(
            key: _formKey,
            child: ListTile(
              key: UniqueKey(),
              title: Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      initialValue: _currentObject.get<int>('fiyat').toString(),
                      keyboardType: TextInputType.number,
                      onSaved: (String value) {
                        _currentObject.set('fiyat', int.parse(value));
                      },
                    ),
                  ),
                  Flexible(
                    flex: 10,
                    child: TextFormField(
                      initialValue: _currentObject.get<String>('yemek'),
                      onSaved: (String value) {
                        _currentObject.set('yemek', value);
                      },
                    ),
                  )
                ],
              ),
              trailing: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    setState(() {
                      _formKey.currentState.save();
                      final ParseObject object = _currentObject;
                      //Delay to highlight the animation.
                      Future<void>.delayed(const Duration(seconds: 1))
                          .then((_) {
                        object.save();
                      });
                      _currentObject = null;
                    });
                  }),
            ),
          );
  }
}
