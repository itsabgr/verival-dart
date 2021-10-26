import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

void update(Uint8List update, Uri url) async {
  var cli = HttpClient();
  var req = await cli.putUrl(url);
  req.contentLength = update.length;
  req.add(update);
  var res = await req.close();
  if (res.statusCode != 204) {
    throw res.statusCode;
  }
}

Future<Uint8List> retrieve(Uint8List pk, Uri url) async {
  var cli = HttpClient();
  var req = await cli.postUrl(url);
  req.contentLength = pk.length;
  req.add(pk);
  var res = await req.close();
  if (res.statusCode != 200) {
    throw res.statusCode;
  }
  var completer = Completer<Uint8List>();
  var buff = BytesBuilder();
  res.listen(
    (data) {
      buff.add(data);
    },
    onDone: () {
      completer.complete(buff.toBytes());
    },
    onError: (e) {
      completer.completeError(e);
    },
    cancelOnError: true,
  );
  return completer.future;
}
