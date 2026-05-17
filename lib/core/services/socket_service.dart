import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  io.Socket? socket;

  bool get isConnected => socket?.connected ?? false;

  void connect({
    required String baseUrl,
    required String token,
    required String userId,
  }) {
    /// لو فيه socket already connected أو حتى شغال/بيحاول يتصل
    if (socket != null) {
      if (socket!.connected) {
        print("✅ Socket already connected");
        return;
      }

      print("♻️ Disposing old socket before reconnect");
      socket!.off('connect');
      socket!.off('disconnect');
      socket!.off('connect_error');
      socket!.off('error');
      socket!.disconnect();
      socket!.dispose();
      socket = null;
    }

    socket = io.io(
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

    socket!.connect();

    socket!.onConnect((_) {
      print("✅ Socket connected");
      print("Socket ID: ${socket!.id}");
    });

    socket!.onDisconnect((data) {
      print("❌ Socket disconnected: $data");
    });

    socket!.onConnectError((data) {
      print("🚨 Socket connect error: $data");
    });

    socket!.onError((data) {
      print("🚨 Socket error: $data");
    });
  }

  void emit(String event, dynamic data) {
    if (socket != null && socket!.connected) {
      print("📤 EMIT => $event | data: $data");
      socket!.emit(event, data);
    } else {
      print("⚠️ Socket not connected. Can't emit event: $event");
    }
  }

  void on(String event, Function(dynamic) handler) {
    print("👂 LISTEN => $event");
    socket?.off(event);
    socket?.on(event, handler);
  }

  void off(String event) {
    print("🛑 OFF => $event");
    socket?.off(event);
  }

  void disconnect() {
    if (socket != null) {
      print("🔌 Disconnecting socket");
      socket!.off('connect');
      socket!.off('disconnect');
      socket!.off('connect_error');
      socket!.off('error');
      socket!.disconnect();
      socket!.dispose();
      socket = null;
    }
  }
}