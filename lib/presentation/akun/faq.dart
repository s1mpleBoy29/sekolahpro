import 'package:flutter/material.dart';
import 'package:guardian_app/theme/theme_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  FaqPageScreen createState() => FaqPageScreen();
}

class FaqPageScreen extends State<FaqScreen> {
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
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) async {
            await _controller.runJavaScript("""
              var header = document.querySelector('header');
              if (header) header.style.display = 'none';

              var footer = document.querySelector('footer');
              if (footer) footer.style.display = 'none';
            """);

            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (error) {
            debugPrint("Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse('https://manage.sekolahpro.id/faq'));
  }

  Future<void> _onRefresh() async {
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: const Text(
          "FAQ",
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
          RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: WebViewWidget(controller: _controller),
              ),
            ),
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
