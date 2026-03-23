import 'dart:async';

class Handler {
  static final Handler _instance = Handler._internal();

  factory Handler() {
    return _instance;
  }

  Handler._internal() {
    _controller = StreamController<MessageFromHandler>.broadcast();
  }

  late StreamController<MessageFromHandler> _controller;

  Stream<MessageFromHandler> get stream => _controller.stream;

  void sendMessage(MessageFromHandler message) {
    _controller.sink.add(message);
  }

  void dispose() {
    _controller.close();
  }
}

///101 clean filter
///100 job date filter
///200 job status filter
///300 job payment status filter
///500 for job screen reload screen
///600 for dashboard reload screen
///700 for profile reload screen

class MessageFromHandler {
  final int what;
  final String selectedDate;
  final String statues;
  final String paymentStatues;


  MessageFromHandler(this.what,{ this.selectedDate = "",this.statues = "",this.paymentStatues = ""});
}