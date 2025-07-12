// ignore_for_file: avoid_print

import 'package:signalr_core/signalr_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citio/models/chat_message_model.dart';

class SignalRService {
  late HubConnection hubConnection;

  Future<void> initConnection({
    required int orderId,
    required Function(ChatMessage message) onMessageReceived,
    required Function(String error) onError,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      onError("⚠️ لا يوجد توكن.");
      return;
    }

    hubConnection =
        HubConnectionBuilder()
            .withUrl(
              'https://service-provider.runasp.net/hubs/message',
              HttpConnectionOptions(
                transport: HttpTransportType.longPolling,
                accessTokenFactory: () async => token,
                skipNegotiation: false,
              ),
            )
            .build();

    hubConnection.onclose((error) async {
      print("❌ الاتصال اتقفل: $error");
      onError(error?.toString() ?? 'Connection closed');

      await Future.delayed(const Duration(seconds: 5));
      try {
        await hubConnection.start();
        await hubConnection.invoke("JoinOrderGroup", args: [orderId]);
        print("🔄 تم إعادة الاتصال وضم الجروب Order_$orderId");
      } catch (e) {
        print("❌ فشل في إعادة الاتصال: $e");
      }
    });

    hubConnection.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final data = Map<String, dynamic>.from(arguments[0]);
          final message = ChatMessage.fromApiJson(data);
          onMessageReceived(message);
        } catch (e) {
          print("❌ Error parsing message: $e");
        }
      }
    });

    try {
      await hubConnection.start();
      print("✅ Connected to SignalR");

      // ✅ تم تعديل الميثود هنا
      await hubConnection.invoke("JoinOrderGroup", args: [orderId]);
      print("✅ Joined group: Order_$orderId");
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> sendMessage({
    required int orderId,
    required String sellerId,
    required String message,
    required String receiverId,
  }) async {
    if (hubConnection.state == HubConnectionState.connected) {
      try {
        await hubConnection.invoke(
          'SendMessage',
          args: [
            {
              "receiverId": receiverId,
              "messageText": message,
              "orderId": orderId,
            },
          ],
        );
        print("📤 Message sent: $message");
      } catch (e) {
        print("❌ Failed to send message: $e");
        throw Exception("Failed to send");
      }
    } else {
      print("⚠️ Connection is not active.");
    }
  }

  Future<void> disconnect() async {
    await hubConnection.stop();
  }
}
