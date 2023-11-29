import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tredingview_v1/appbar/navtxt.dart';
import 'package:tredingview_v1/tradingview/service/data_souce.dart';
import 'package:webview_flutter/webview_flutter.dart';

const tradingviewHTML = '''
  <!DOCTYPE html>
  <html lang="en">
  <head>
  <title>Load file or HTML string example</title>
  </head>
  <body>
    <div class="tradingview-widget-container" style="height:100%;width:100%">
      <div id="tradingview_ffc51" style="height:calc(100% - 32px);width:100%"></div>
      <div class="tradingview-widget-copyright"><a href="https://www.tradingview.com/" rel="noopener nofollow" target="_blank"><span class="blue-text">Track all markets on TradingView</span></a></div>
      <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
      <script type="text/javascript">
        new TradingView.widget(
          {
            "autosize": true,
            "symbol": "NASDAQ:AAPL",
            "interval": "D",
            "timezone": "Etc/UTC",
            "theme": "light",
            "style": "1",
            "locale": "en",
            "enable_publishing": false,
            "allow_symbol_change": true,
            "container_id": "tradingview_ffc51"
          }
        );
      </script>
    </div>
  </body>
  </html>
''';

class TradingViewChart extends StatefulWidget {
  const TradingViewChart({Key? key}) : super(key: key);

  @override
  State<TradingViewChart> createState() => _TradingViewChartState();
}

class _TradingViewChartState extends State<TradingViewChart> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();

    // controller = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setBackgroundColor(const Color(0x00000000))
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onProgress: (int progress) {
    //         debugPrint('progress');
    //       },
    //       onPageStarted: (String url) {
    //         debugPrint('started');
    //       },
    //       onPageFinished: (String url) {
    //         debugPrint('finished');
    //       },
    //     ),
    //   )
    //   ..enableZoom(true)
    //   ..loadHtmlString(
    //       CryptoNameDataSource.cryptoNameAndSource(widget.cryptoName));

    // controller = onWebViewCreated();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavTxt(
        title: "Trading View",
        context: context,
      ),
      body: WebView(
        initialUrl: '',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
          webViewController.loadHtmlString(
              CryptoNameDataSource.cryptoNameAndSource(
                  height: MediaQuery.of(context).size.height));
        },
        javascriptMode: JavascriptMode.unrestricted,
        backgroundColor: const Color(0x00000000),
        // zoomEnabled: true,
      ),
    );
  }
}
