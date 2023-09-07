// ignore_for_file: deprecated_member_use, avoid_print

import 'package:url_launcher/url_launcher.dart';

void launchUrlNow(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}
