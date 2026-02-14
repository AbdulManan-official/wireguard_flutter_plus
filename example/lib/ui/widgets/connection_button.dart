import 'package:flutter/material.dart';

class ConnectionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String status;
  final String duration;

  const ConnectionButton({
    super.key,
    required this.onPressed,
    required this.status,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    Color glowColor;
    String label;
    IconData icon;
    bool isPulsing = false;

    switch (status) {
      case "connected":
        buttonColor = Theme.of(context).colorScheme.primary;
        glowColor = buttonColor.withOpacity(0.4);
        label = "Connected";
        icon = Icons.shield;
        break;
      case "connecting":
      case "authenticating":
      case "preparing":
      case "waitingConnection":
        buttonColor = Theme.of(context).colorScheme.secondary;
        glowColor = buttonColor.withOpacity(0.4);
        label = "Connecting...";
        icon = Icons.sync;
        isPulsing = true;
        break;
      case "disconnecting":
        buttonColor = Colors.orange;
        glowColor = buttonColor.withOpacity(0.4);
        label = "Disconnecting...";
        icon = Icons.sync_disabled;
        break;
      case "denied":
      case "noConnection":
        buttonColor = Theme.of(context).colorScheme.error;
        glowColor = buttonColor.withOpacity(0.4);
        label = "Error";
        icon = Icons.error_outline;
        break;
      case "disconnected":
      default:
        buttonColor = const Color(0xFF334155); // Inactive grey/blue
        glowColor = Colors.transparent;
        label = "Connect";
        icon = Icons.power_settings_new;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0F172A), // Background filler
              boxShadow: [
                BoxShadow(
                  color: glowColor,
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
              border: Border.all(
                color: buttonColor.withOpacity(0.3),
                width: 4,
              ),
            ),
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: buttonColor.withOpacity(0.1),
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: buttonColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: buttonColor,
                letterSpacing: 1.2,
              ),
        ),
        if (status == "connected") ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Text(
              duration,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ]
      ],
    );
  }
}
