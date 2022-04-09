import "package:http/http.dart" as http;
import "dart:convert";

/// Accesses Web service.
class WebClient {
  dynamic serverUrl;
  dynamic parser;

  WebClient() {
    parser = ResponseParser();
  }

  /// Fetches the information from the given [url].
  getInfo(url) async {
    serverUrl = url;
    url = Uri.parse(url + "info/");
    var response = await http.get(url);
    return parser.parseInfo(response);
  }

  /// Creates a new game from the given [strategy].
  ///
  /// Returns [pid] to identify unique game session.
  createNewGame(strategy) async {
    var url = serverUrl + "new/?strategy=" + strategy;
    url = Uri.parse(url);
    var response = await http.get(url);
    return parser.parseInfo(response);
  }

  /// Connects to url/play and makes a move based on [indices] if [pid] is correct.
  makeMove(pid, indices) async {
    // Make a connection to url/play
    var url = serverUrl +
        "play/?pid=" +
        pid +
        "&move=" +
        indices[0].toString() +
        ',' +
        indices[1].toString();
    url = Uri.parse(url);
    var response = await http.get(url);
    return parser.parseInfo(response);
  }
}

/// Parse Json.
class ResponseParser {
  // Info
  parseInfo(response) {
    return json.decode(response.body);
  }
}
