import 'package:aleef/core/constants/api_constant.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  io.Socket? _socket;

  io.Socket? get socket => _socket;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connectCurrentSession() async {
    final secureStorage = getIt<SecureStorageService>();

    final doctorToken = await secureStorage.getDoctorToken();
    final doctor = await secureStorage.getDoctor();

    if (doctorToken != null && doctorToken.isNotEmpty && doctor != null) {
      connect(
        baseUrl: ApiConstant.socketUrl,
        token: doctorToken,
        userId: doctor.id as String,
      );
      return;
    }

    final userToken = await secureStorage.getToken();
    final user = await secureStorage.getUser();

    if (userToken != null && userToken.isNotEmpty && user != null) {
      connect(
        baseUrl: ApiConstant.socketUrl,
        token: userToken,
        userId: user.id,
      );
      return;
    }

    debugPrint('❌ Socket connectCurrentSession failed: no session found');
  }

  void connect({
    required String baseUrl,
    required String token,
    required String userId,
  }) {
    if (token.trim().isEmpty || userId.trim().isEmpty) {
      debugPrint('❌ Socket connect failed: token or userId is empty');
      return;
    }

    if (_socket != null) {
      if (_socket!.connected) {
        debugPrint('✅ Socket already connected: ${_socket!.id}');
        return;
      }

      disconnect();
    }

    debugPrint('🔌 Connecting socket...');
    debugPrint('👤 Socket userId: $userId');

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

  void joinChat(String chatId) {
    emitWhenConnected('join_chat', {
      'chatId': chatId,
    });
  }

  void emit(String event, dynamic data) {
    if (!isConnected) {
      debugPrint('❌ Socket emit failed: not connected');
      debugPrint('Event: $event');
      debugPrint('Data: $data');
      return;
    }

    debugPrint('📤 Emit: $event');
    debugPrint('Data: $data');

    _socket?.emit(event, data);
  }



  void emitWhenConnected(String event, dynamic data) {
    if (isConnected) {
      emit(event, data);
      return;
    }

    if (_socket == null) {
      debugPrint('❌ Socket emit failed: socket is null');
      debugPrint('Event: $event');
      debugPrint('Data: $data');
      return;
    }

    debugPrint('⏳ Waiting socket connection for event: $event');

    _socket?.once('connect', (_) {
      debugPrint('📤 Emit after connect: $event');
      _socket?.emit(event, data);
    });
  }

  void listen(String event, void Function(dynamic data) handler) {
    debugPrint('👂 Listening to: $event');
    _socket?.off(event);
    _socket?.on(event, handler);
  }

  void listenMany(String event, void Function(dynamic data) handler) {
    debugPrint('👂 Listening many to: $event');
    _socket?.on(event, handler);
  }

  void off(String event) {
    debugPrint('🛑 Off: $event');
    _socket?.off(event);
  }

  void offAllCustomEvents() {
    _socket?.clearListeners();
    _bindDefaultListeners();
  }

  void disconnect() {
    if (_socket == null) return;

    debugPrint('🔌 Socket disconnect');

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
      debugPrint('✅ Socket connected: ${_socket?.id}');
    });

    _socket?.onDisconnect((data) {
      debugPrint('❌ Socket disconnected: $data');
    });

    _socket?.onConnectError((data) {
      debugPrint('❌ Socket connect error: $data');
    });

    _socket?.onError((data) {
      debugPrint('❌ Socket error: $data');
    });
  }

  void leaveChat(String chatId) {
    emitWhenConnected('leave_chat', chatId);
  }
}