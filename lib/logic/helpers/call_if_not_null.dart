import 'package:flutter/material.dart';

void callIfNotNull(Function()? foo) {
  if (foo != null) {
    foo();
  } else {
    debugPrint('cannot call foo!!');
  }
}
