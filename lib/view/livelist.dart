import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class LiveList extends StatefulWidget {
  @override
  _LiveListState createState() => _LiveListState();
}

class _LiveListState extends State<LiveList> {
  @override
  Widget build(BuildContext context) {
    QueryBuilder<ParseObject> queryCars =
        QueryBuilder<ParseObject>(ParseObject('siparisler'));

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ParseLiveListWidget<ParseObject>(
            query: queryCars,
            reverse: false,
            childBuilder: (BuildContext context,
                ParseLiveListElementSnapshot<ParseObject> snapshot) {
              if (snapshot.failed) {
                return const Text('something went wrong!');
              } else if (snapshot.hasData) {
                return ListTile(
                  title: Text(
                    snapshot.loadedData.get("yemek"),
                  ),
                );
              } else {
                return const ListTile(
                  leading: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
