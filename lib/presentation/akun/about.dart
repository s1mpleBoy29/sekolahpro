import 'package:flutter/material.dart';
import 'package:guardian_app/theme/theme_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  AboutPageScreen createState() => AboutPageScreen();
}

class AboutPageScreen extends State<AboutScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {},
          onPageStarted: (url) {
            debugPrint("Start loading: $url");
          },
          onPageFinished: (url) async {
            setState(() {
              isLoading = false;
            });
            // Inject JavaScript untuk menghilangkan header & footer
            await _controller.runJavaScript("""
              var header = document.querySelector('header');
              if (header) header.style.display = 'none';

              var footer = document.querySelector('footer');
              if (footer) footer.style.display = 'none';
            """);
          },
          onWebResourceError: (error) {
            debugPrint("Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse('https://manage.sekolahpro.id/about'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: const Text(
          "TENTANG KAMI",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
