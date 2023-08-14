import 'dart:async';

import 'package:rxdart/rxdart.dart';

class CreateTaskValidator {
  final _name = BehaviorSubject<String>();
  final _date = BehaviorSubject<String>();
  final _time = BehaviorSubject<String>();
  final _desc = BehaviorSubject<String>();

  Stream<String> get name => _name.stream.transform(validateName);
  Sink<String> get sinkName => _name.sink;

  Stream<String> get date => _date.stream.transform(validateDate);
  Sink<String> get sinkDate => _date.sink;

  Stream<String> get time => _time.stream.transform(validateTime);
  Sink<String> get sinkTime => _time.sink;

  Stream<String> get desc => _desc.stream.transform(validateDesc);
  Sink<String> get sinkDesc => _desc.sink;

  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.isNotEmpty) {
      sink.add(value);
    } else {
      sink.addError('Please enter the Task Name');
    }
  });

  final validateDate =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.isNotEmpty) {
      sink.add(value);
    } else {
      sink.addError('Please select the date');
    }
  });

  final validateTime =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.isNotEmpty) {
      sink.add(value);
    } else {
      sink.addError('Please select the time');
    }
  });

  final validateDesc =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.isNotEmpty) {
      sink.add(value);
    } else {
      sink.addError('Please Enter the Description');
    }
  });

  Stream<bool> get submitValid =>
      Rx.combineLatest4(name, date, time, desc, (e, m, t, d) => true);
}
