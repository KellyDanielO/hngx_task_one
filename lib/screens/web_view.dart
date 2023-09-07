// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/colors.dart';
import '../constants/function.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://github.com/KellyDanielO'),
      );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.arrow_left, color: AppColors.mainColor,),),
        title: Text(
          'Donate',
          style: TextStyle(
            color: AppColors.mainColor,
            fontSize: width * .01 + 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          NavigationControls(controller: controller),
          Menu(controller: controller),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (await controller.canGoBack()) {
            await controller.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: Container(
          height: height,
          width: width,
          color: AppColors.mainBg,
          child: WebViewStack(controller: controller),
        ),
      ),
    );
  }
}

class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, super.key}); // MODIFY

  final WebViewController controller; // ADD

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onNavigationRequest: (navigation) {
            final host = Uri.parse(navigation.url).host;
            if (host.contains('youtube.com')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Blocking navigation to $host',
                  ),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: widget.controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
            color: AppColors.primaryColor,
          ),
      ],
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({required this.controller, super.key});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.mainColor,),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text(
                    'No back history item',
                    style: TextStyle(
                      color: AppColors.mainBg,
                    ),
                  ),
                  backgroundColor: AppColors.mainColor,
                ),
              );
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: AppColors.mainColor,),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoForward()) {
              await controller.goForward();
            } else {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text(
                    'No forward history item',
                    style: TextStyle(
                      color: AppColors.mainBg,
                    ),
                  ),
                  backgroundColor: AppColors.mainColor,
                ),
              );
              return;
            }
          },
        ),
      ],
    );
  }
}

enum _MenuOptions {
  navigationDelegate,
  reload,
}

class Menu extends StatelessWidget {
  const Menu({required this.controller, super.key});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuOptions>(
      onSelected: (value) async {
        switch (value) {
          case _MenuOptions.navigationDelegate:
            launchUrlNow('https://github.com/KellyDanielO');
            break;
          case _MenuOptions.reload:
            controller.reload();
            break;
        }
      },
      color: AppColors.mainColor,
      itemBuilder: (context) => [
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.navigationDelegate,
          child: Text('Open in browser'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.reload,
          child: Text('Reload'),
        ),
      ],
    );
  }
}


