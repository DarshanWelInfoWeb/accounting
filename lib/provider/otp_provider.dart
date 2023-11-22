import 'dart:async';

import 'package:flutter/material.dart';


class OTPProvider extends ChangeNotifier {
  late Timer _timer;
  int time_count = 30;
  int? _start=30;
  int? get start => _start;

  Future<void> startTimer(BuildContext context) async{
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec, (Timer timer) {
        if (time_count == 0) {
          timer.cancel();
          _start=0;
        }
        else {
          time_count--;
          _start=time_count;
          print('time:::$time_count');
          notifyListeners();
        }
      },
    );
  }

  void setReStart(BuildContext context) {
    time_count = 30;
    _start = 30;
  }

  void setStopTime() {
    _timer.cancel();
  }
}
