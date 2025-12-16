import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final MqttServerClient client = MqttServerClient('broker.hivemq.com', 'flutter_client_id');

  Function(String data)? onData;
  MqttService() {
    // Initialize client settings in constructor if needed
  }

  void disconnect() {
    client.disconnect();
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  Future<void> connect() async {
    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.onDisconnected = () => print('MQTT disconnected');
    client.onConnected = () => print('MQTT connected');

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client_id')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print('MQTT Connect ERROR: $e');
      client.disconnect();
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client.subscribe('sensor/temperature', MqttQos.atMostOnce);

      client.updates!.listen((messages) {
        final msg = messages[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(msg.payload.message);

        if (onData != null) onData!(payload);
      });
    }
  }
}
