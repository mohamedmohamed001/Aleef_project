import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  io.Socket? _socket;

  io.Socket? get socket => _socket;

  bool get isConnected => _socket?.connected ?? false;

  void connect({
    required String baseUrl,
    required String token,
    required String userId,
  }) {
    if (_socket != null) {
      if (_socket!.connected) {
        return;
      }

      disconnect();
    }

    _socket = io.io(
      baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({
        'token': token,
        'userId': userId,
      })
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .build(),
    );

    _bindDefaultListeners();
    _socket!.connect();
  }

  void emit(String event, dynamic data) {
    if (!isConnected) {
      return;
    }

    _socket?.emit(event, data);
  }

  void listen(String event, void Function(dynamic data) handler) {
    _socket?.off(event);
    _socket?.on(event, handler);
  }

  void listenMany(String event, void Function(dynamic data) handler) {
    _socket?.on(event, handler);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void offAllCustomEvents() {
    _socket?.clearListeners();
    _bindDefaultListeners();
  }

  void disconnect() {
    if (_socket == null) return;

    _socket!
      ..off('connect')
      ..off('disconnect')
      ..off('connect_error')
      ..off('error')
      ..disconnect()
      ..dispose();

    _socket = null;
  }

  void _bindDefaultListeners() {
    _socket?.onConnect((_) {
      // Socket connected.
    });

    _socket?.onDisconnect((_) {
      // Socket disconnected.
    });

    _socket?.onConnectError((_) {
      // Socket connect error.
    });

    _socket?.onError((_) {
      // Socket error.
    });
  }
}