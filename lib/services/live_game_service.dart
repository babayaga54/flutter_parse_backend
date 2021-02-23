import 'package:parse_deneme/model/yemek_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class LiveGameService {
  final LiveQuery liveQuery = LiveQuery();

  Stream<List<Yemek>> oyunmuYayinmiStream() {
    /* QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('TestAPI'));
    Subscription subscription = await liveQuery.client.subscribe(query);
    List<Yemek> retVal = List();
    subscription.on(LiveQueryEvent.create, (value) {
      retVal.add(Yemek(
        objectId: (value as ParseObject).objectId,
        yemek: (value as ParseObject).get('yemek'),
        fiyat: (value as ParseObject).get('fiyat'),
      ));
    });
    return retVal; */
  }
}
