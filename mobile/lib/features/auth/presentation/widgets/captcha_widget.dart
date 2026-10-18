import 'package:flutter/material.dart';

import 'captcha_widget_stub.dart'
    if (dart.library.js_interop) 'captcha_widget_web.dart' as platform;

class CaptchaWidget extends StatelessWidget {
  const CaptchaWidget({
    super.key,
    required this.onToken,
    required this.onResetReady,
  });

  final ValueChanged<String?> onToken;
  final ValueChanged<VoidCallback> onResetReady;

  @override
  Widget build(BuildContext context) => platform.buildCaptchaWidget(
        onToken: onToken,
        onResetReady: onResetReady,
      );
}
