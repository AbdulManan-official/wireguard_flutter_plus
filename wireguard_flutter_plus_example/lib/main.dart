import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wireguard_flutter_plus/wireguard_flutter_plus.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('WireGuard Example App')),
        body: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final wireguard = WireGuardFlutter.instance;

  String downloadCount = "0.0";
  String uploadCount = "0.0";
  String totalDownload = "0";
  String totalUpload = "0";
  String duration = "00:00:00";

  String vpnState = VpnEngine.vpnDisconnected;

  StreamSubscription? _vpnStatusSubscription;
  StreamSubscription? _vpnTraffic;
  var _config = TextEditingController(
    text: '''[Interface]
PrivateKey = +J0GRTgbvFWolFnFphZki0K0hOWCcs67JsVEl+lMcno=
Address = 10.104.0.224/32
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = YLaLJahXZ6NuASXQLPl0eUPVAypirpaLuuO7tZa2bmo=
Endpoint = 147.135.15.16:443
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
 ''',
  );

  @override
  void initState() {
    super.initState();
    debugPrint("HomeController initialized");
    Future.delayed(Duration(milliseconds: 500), () {
      // Always listen to traffic snapshot (subscribe only once)
      _vpnTraffic = wireguard.trafficSnapshot.listen((data) {
        debugPrint("Traffic data received: $data");
        downloadCount = data["downloadSpeed"].toString();
        uploadCount = data["uploadSpeed"].toString();
        totalDownload = data["totalDownload"].toString();
        totalUpload = data["totalUpload"].toString();
        duration = data["duration"].toString();
        setState(() {
          debugPrint("Updated traffic data: $downloadCount, $uploadCount");
        });
      });

      // Always listen to VPN status snapshot
      _vpnStatusSubscription = wireguard.vpnStageSnapshot.listen((event) async {
        debugPrint("VPN status changed: $event");
        vpnState = event.name;
        setState(() {});
      });

      // Check if VPN is connected at startup
      wireguard.isConnected().then((isConnected) {
        if (isConnected) {
          debugPrint("VPN is already connected");

          vpnState = VpnEngine.vpnConnected;
          setState(() {});
        } else {
          debugPrint("VPN is not connected");

          vpnState = VpnEngine.vpnDisconnected;
          setState(() {});
        }
      });
    });
  }

  Future<void> initialize() async {
    try {
      await wireguard.initialize(
        interfaceName: "wg_vpn",
        vpnName: "Orban VPN", // Custom VPN name for notification
      );
      debugPrint("initialize success 'wg_vpn' with custom name 'Orban VPN'");
    } catch (error, stack) {
      debugPrint("failed to initialize: $error\n$stack");
    }
  }

  void startVpn() async {
    try {
      await wireguard.startVpn(
        serverAddress: '144.217.253.149:443',
        wgQuickConfig: _config.text,
        providerBundleIdentifier: 'com.orbanvpn.wireguard.WGExtension',
      );
    } catch (error, stack) {
      debugPrint("failed to start $error\n$stack");
    }
  }

  void disconnect() async {
    try {
      await wireguard.stopVpn();
      wireguard.stopVpn();

      vpnState = VpnEngine.vpnDisconnected;
      downloadCount = "0.0";
      uploadCount = "0.0";
      totalDownload = "0";
      totalUpload = "0";
      duration = "00:00:00";
      setState(() {});
    } catch (e, str) {
      debugPrint('Failed to disconnect $e\n$str');
    }
  }

  void getStatus() async {
    debugPrint("getting stage");
    final stage = await wireguard.stage();

    debugPrint("stage: $stage");

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('stage: $stage')));
    }
  }

  String formatSpeed(double speedInKBps, {int decimals = 2}) {
    const suffixes = ["Byts", "KB/s", "MB/s", "GB/s", "TB/s"];

    if (speedInKBps < 1024) {
      return '${speedInKBps.toStringAsFixed(decimals)} ${suffixes[0]}';
    }

    int i = (log(speedInKBps) / log(1024)).floor();
    return '${(speedInKBps / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('VPN State: $vpnState'),
              Text("Duration: $duration"),
              const SizedBox(height: 10),
              Text(
                'Total Download: ${formatSpeed(double.parse(totalDownload))}',
              ),
              Text('Total Upload: ${formatSpeed(double.parse(totalUpload))}'),
              const SizedBox(height: 10),
              Text(
                'Download Speed: ${formatSpeed(double.parse(downloadCount))}',
              ),
              Text('Upload Speed: ${formatSpeed(double.parse(uploadCount))}'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _config,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'WireGuard Config',
                  hintText: 'Paste your WireGuard config here',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              TextButton(
                onPressed: initialize,
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all<Size>(
                    const Size(100, 50),
                  ),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  ),
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.blueAccent,
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                    Colors.white.withOpacity(0.1),
                  ),
                ),
                child: const Text(
                  'initialize',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 20),
              TextButton(
                onPressed: startVpn,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(100, 50),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blueAccent,
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                    Colors.white.withOpacity(0.1),
                  ),
                ),
                child: const Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 20),
              TextButton(
                onPressed: disconnect,
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all<Size>(
                    const Size(100, 50),
                  ),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  ),
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.blueAccent,
                  ),
                  overlayColor: WidgetStateProperty.all<Color>(
                    Colors.white.withOpacity(0.1),
                  ),
                ),
                child: const Text(
                  'Disconnect',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: getStatus,
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all<Size>(const Size(100, 50)),
              padding: WidgetStateProperty.all(
                const EdgeInsets.fromLTRB(20, 15, 20, 15),
              ),
              backgroundColor: WidgetStateProperty.all<Color>(
                Colors.blueAccent,
              ),
              overlayColor: WidgetStateProperty.all<Color>(
                Colors.white.withOpacity(0.1),
              ),
            ),
            child: const Text(
              'Get status',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class VpnEngine {
  ///All Stages of connection
  static const String vpnConnecting = "connecting";
  static const String vpnConnected = "connected";
  static const String vpnDisconnecting = "disconnecting";
  static const String vpnDisconnected = "disconnected";
  static const String vpnWaitConnection = "waitingConnection";
  static const String vpnAuthenticating = "authenticating";
  static const String vpnReconnect = "reconnect";
  static const String vpnNoConnection = "noConnection";
  static const String vpnPrepare = "preparing";
  static const String vpnDenied = "denied";
  static const String vpnExiting = "exiting";
}
