

import 'package:flutter/cupertino.dart';

class LiveData<T> extends ValueNotifier<T>{
  LiveData(T value) : super(value);

  void observe(ValueCallback<T> observer){
    addListener(() {
      observer.call(value);
  });
  }

  @override
  void dispose() {
    super.dispose();
  }

}

typedef ValueCallback<T> = Function(T value);