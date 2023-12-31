class CryptoNameDataSource {
  static String binanceSourceEuro(String cryptoName) {
    return 'BINANCE:${cryptoName}EUR';
  }

  static String cryptoNameAndSource({double? height}) {
//     return '''
// <!DOCTYPE html>
// <html lang="en">
// <head>
// <title>Load file or HTML string example</title>
// </head>
// <body>
// <div class="tradingview-widget-container">
// <div id="tradingview_4418d">
// </div>
// <div class="tradingview-widget-copyright">
// <a href="https://www.tradingview.com/" rel="noopener nofollow" target="_blank">
// <span class="blue-text">Track all markets on TradingView
// </span>
// </a>
// </div>
// <script type="text/javascript" src="https://s3.tradingview.com/tv.js">
// </script>
// <script type="text/javascript">
// new TradingView.widget({
//   "width": "100%",
//   "height": 1180,
//   "symbol": "$name",
//   "interval": "D",
//   "timezone": "Etc/UTC",
//   "theme": "dark",
//   "style": "1",
//   "locale": "en",
//   "toolbar_bg": "#121536",
//   "backgroundColor": "rgba(18, 21, 54, 1)",
//   "enable_publishing": false,
//   "save_image": false,
//   "container_id": "tradingview_4418d"
//   });
// </script>
// </div>
// </body>
// </html>''';
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
<title>Load file or HTML string example</title>
</head>
<body>
  <div class="tradingview-widget-container" style="height:100%;width:100%">
    <div id="tradingview_ffc51" style="height:100%;width:100%"></div>
    <div class="tradingview-widget-copyright"><a href="https://www.tradingview.com/" rel="noopener nofollow" target="_blank"><span class="blue-text">Track all markets on TradingView</span></a></div>
    <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
    <script type="text/javascript">
      new TradingView.widget(
        {
          "width": "100%",
          "height": $height,
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
</html>''';
  }
}
