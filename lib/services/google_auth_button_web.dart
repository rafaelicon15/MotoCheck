import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart' as google_web;

Widget googleAuthButton() {
  return google_web.renderButton(
    configuration: google_web.GSIButtonConfiguration(
      theme: google_web.GSIButtonTheme.outline,
      size: google_web.GSIButtonSize.large,
      type: google_web.GSIButtonType.standard,
      text: google_web.GSIButtonText.signinWith,
      shape: google_web.GSIButtonShape.pill,
      logoAlignment: google_web.GSIButtonLogoAlignment.left,
      minimumWidth: 280,
    ),
  );
}
