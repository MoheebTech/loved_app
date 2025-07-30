import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loved_app/widgets/custom_toasts.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomUrlLaunchers {
  Future<void> openwhatsapp(BuildContext context, {required String number, required String text}) async {
    var whatsapp = number;
    var whatsappURlAndroid = 'whatsapp://send?phone=$whatsapp&text=$text';

    var whatappURLIos = 'https://wa.me/$whatsapp?text=$text';

    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(whatappURLIos))) {
        await launchUrl(Uri.parse(whatappURLIos));
      } else {
        CustomToast.failToast(msg: 'Whatsapp is not installed');
      }
    } else if (Platform.isAndroid) {
      // andriod

      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        CustomToast.failToast(msg: 'Whatsapp is not installed');
      }
    }
  }

  Future<void> openUrl(BuildContext context, String? url) async {
    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(url!))) {
        await launchUrl(Uri.parse(url));
      } else {
        CustomToast.failToast(msg: 'Could not launch $url');
      }
    } else if (Platform.isAndroid) {
      if (await canLaunchUrl(Uri.parse(url!))) {
        await launchUrl(
          Uri.parse(
            url,
          ),
        );
      } else {
        CustomToast.failToast(msg: 'Could not launch $url');
      }
    }
  }

  String obscureBeforeAt(String input) {
    if (input.isEmpty || !input.contains('@')) {
      return input;
    }

    List<String> parts = input.split('@');
    String localPart = parts[0];
    String domainPart = parts[1];

    if (localPart.length == 1) {
      return localPart + '@' + domainPart;
    } else if (localPart.length == 2) {
      return localPart[0] + '*' + '@' + domainPart;
    } else if (localPart.length == 3) {
      return localPart[0] + '*' + localPart[2] + '@' + domainPart;
    } else {
      String visibleStart = localPart.substring(0, 2);
      String visibleEnd = localPart.substring(localPart.length - 2);
      String obscuredPart = '*' * (localPart.length - 4);
      return visibleStart + obscuredPart + visibleEnd + '@' + domainPart;
    }
  }

  String obscureHalfPhone(String input) {
    if (input.isEmpty) {
      return '';
    }

    int midpoint = input.length ~/ 2;
    String visiblePart = input.substring(0, midpoint);
    String obscuredPart = '*' * (input.length - midpoint - 2);
    String lastTwoChars = input.length > 1 ? input.substring(input.length - 2) : input;

    return visiblePart + obscuredPart + lastTwoChars;
  }
}
