import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sport_center_attribute.dart';

class CopyableLink extends StatelessWidget {
  const CopyableLink({
    super.key,
    required this.link,
    required this.linkApp,
  });

  final String? link;
  final String linkApp;

  String _displayLink(String? link) {
    return link != null && link.isNotEmpty ? link : '_';
  }

  @override
  Widget build(BuildContext context) {
    String linkString = _displayLink(link);
    return GestureDetector(
      onLongPress: () {
        final data = ClipboardData(
          text: _displayLink(linkString),
        );
        Clipboard.setData(data);
        final snackBar =
            SnackBar(content: Text('$linkApp link copied to clipboard'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '$linkApp link: ',
                style: const TextStyle(fontSize: 16),
              ),
              TextSpan(
                text: linkString,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
