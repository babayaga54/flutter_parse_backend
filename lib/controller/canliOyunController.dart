import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:parse_deneme/model/yemek_model.dart';
import 'package:parse_deneme/services/live_game_service.dart';

class CounterState extends GetxController {
  // the path from where our data will be fetched and displayed to used
  Rx<List<Yemek>> liveGamesModel = Rx<List<Yemek>>();

  List<Yemek> get games => liveGamesModel.value;

  @override
  void onInit() {
    liveGamesModel.bindStream(
        LiveGameService().oyunmuYayinmiStream()); //stream coming from firebase
  }
}
