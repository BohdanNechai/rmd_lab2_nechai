import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// Простий клас для передачі даних
class MqttData {
  final String topic;
  final String message;
  MqttData(this.topic, this.message);
}

class MqttService {
  final MqttServerClient client = MqttServerClient(
    'broker.hivemq.com',
    'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
  );

  // Тепер стрім передає об'єкт MqttData (топік і повідомлення)
  final _controller = StreamController<MqttData>.broadcast();
  Stream<MqttData> get messageStream => _controller.stream;

  Future<void> connect() async {
    client.port = 1883;
    client.logging(on: false);
    client.keepAlivePeriod = 20;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(client.clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print('MQTT Error: $e');
      client.disconnect();
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT Connected');

      // Підписуємось на все в smart_home
      client.subscribe('iot/smart_home/#', MqttQos.atMostOnce);

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        final topic = c[0].topic; // Отримуємо топік

        print('MQTT: [$topic] -> $payload');

        // Передаємо і топік, і повідомлення далі
        _controller.add(MqttData(topic, payload));
      });
    }
  }

  void disconnect() {
    client.disconnect();
  }
}
