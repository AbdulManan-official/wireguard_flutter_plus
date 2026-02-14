import 'package:flutter/material.dart';

class ConfigInputWidget extends StatefulWidget {
  final TextEditingController controller;

  const ConfigInputWidget({super.key, required this.controller});

  @override
  State<ConfigInputWidget> createState() => _ConfigInputWidgetState();
}

class _ConfigInputWidgetState extends State<ConfigInputWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Row(
          children: [
            const Icon(Icons.settings, color: Color(0xFF94A3B8)),
            const SizedBox(width: 12),
            Text(
              "Tunnel Configuration",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: const Color(0xFF94A3B8),
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: widget.controller,
              maxLines: 15,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: Color(0xFFE2E8F0),
              ),
              decoration: const InputDecoration(
                hintText: 'Paste your WireGuard config here...',
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
