// lib/core/helper/api_signalr_helper.dart

import 'package:signalr_core/signalr_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignalRService {
  late HubConnection hubConnection;

  Future<void> initConnection({
    required Function(String message) onMessageReceived,
    required Function(String error) onError,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    hubConnection =
        HubConnectionBuilder()
            .withUrl(
              'https://service-provider.runasp.net/hubs/message', // 🔁 رابط الـ SignalR
              HttpConnectionOptions(accessTokenFactory: () async => token),
            )
            .build();

    hubConnection.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        onMessageReceived(arguments[0].toString());
      }
    });

    hubConnection.onclose((error) {
      onError(error?.toString() ?? 'Connection Closed');
    });

    try {
      await hubConnection.start();
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> sendMessage({
    required int orderId,
    required String sellerId,
    required String message,
  }) async {
    if (hubConnection.state == HubConnectionState.connected) {
      await hubConnection.invoke(
        'SendMessage',
        args: [orderId, sellerId, message],
      );
    }
  }

  Future<void> disconnect() async {
    await hubConnection.stop();
  }
}
