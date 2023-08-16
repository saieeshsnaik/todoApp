import 'dart:async';

class CreateTaskValidator {
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
}
