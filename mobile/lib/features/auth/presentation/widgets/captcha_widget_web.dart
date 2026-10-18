import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

const _siteKey = String.fromEnvironment('RECAPTCHA_SITE_KEY');
const _viewType = 'gavac-recaptcha-v2';

@JS('gavacRenderRecaptcha')
external void _renderRecaptcha(JSNumber viewId, JSString siteKey);

@JS('gavacResetRecaptcha')
external void _resetRecaptcha(JSNumber viewId);

Widget buildCaptchaWidget({
  required ValueChanged<String?> onToken,
  required ValueChanged<VoidCallback> onResetReady,
}) {
  if (_siteKey.isEmpty) {
    return const Text(
      'Falta configurar RECAPTCHA_SITE_KEY para compilar la versión web.',
      style: TextStyle(color: Colors.red),
    );
  }

  return _CaptchaView(onToken: onToken, onResetReady: onResetReady);
}

class _CaptchaView extends StatefulWidget {
  const _CaptchaView({required this.onToken, required this.onResetReady});

  final ValueChanged<String?> onToken;
  final ValueChanged<VoidCallback> onResetReady;

  @override
  State<_CaptchaView> createState() => _CaptchaViewState();
}

class _CaptchaViewState extends State<_CaptchaView> {
  late final int _viewId = _CaptchaViewState._registerView();
  late final web.EventListener _tokenListener = _handleToken.toJS;
  late final web.EventListener _expiredListener = _handleExpired.toJS;
  late final web.EventListener _errorListener = _handleError.toJS;

  static int _nextViewId = 0;

  static int _registerView() {
    final id = _nextViewId++;
    ui_web.platformViewRegistry.registerViewFactory(
      '$_viewType-$id',
      (_) => web.HTMLDivElement()..id = 'gavac-recaptcha-$id',
    );
    return id;
  }

  @override
  void initState() {
    super.initState();
    web.window.addEventListener('gavacRecaptchaToken', _tokenListener);
    web.window.addEventListener('gavacRecaptchaExpired', _expiredListener);
    web.window.addEventListener('gavacRecaptchaError', _errorListener);
    widget.onResetReady(reset);
  }

  void _renderCaptcha(int _) {
    _renderRecaptcha(_viewId.toJS, _siteKey.toJS);
  }

  void _handleToken(web.Event event) {
    final detail =
        jsonDecode(((event as web.CustomEvent).detail! as JSString).toDart);
    if (detail is Map<String, dynamic> &&
        detail['viewId'] == _viewId &&
        detail['token'] is String) {
      widget.onToken(detail['token'] as String);
    }
  }

  void _handleExpired(web.Event event) {
    final detail =
        jsonDecode(((event as web.CustomEvent).detail! as JSString).toDart);
    if (detail is Map<String, dynamic> && detail['viewId'] == _viewId) {
      widget.onToken(null);
    }
  }

  void _handleError(web.Event event) {
    final detail =
        jsonDecode(((event as web.CustomEvent).detail! as JSString).toDart);
    if (detail is Map<String, dynamic> && detail['viewId'] == _viewId) {
      widget.onToken(null);
    }
  }

  void reset() {
    _resetRecaptcha(_viewId.toJS);
    widget.onToken(null);
  }

  @override
  void dispose() {
    web.window.removeEventListener('gavacRecaptchaToken', _tokenListener);
    web.window.removeEventListener('gavacRecaptchaExpired', _expiredListener);
    web.window.removeEventListener('gavacRecaptchaError', _errorListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: HtmlElementView(
        viewType: '$_viewType-$_viewId',
        onPlatformViewCreated: _renderCaptcha,
      ),
    );
  }
}
