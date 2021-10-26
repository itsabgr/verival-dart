import 'dart:typed_data';
import 'package:verival/utils.dart';
import 'package:verival/codec.dart';
import 'package:verival/crypto.dart';
import 'package:test/test.dart';

void main() {
  test("codec", () {
    {
      var now = timestamp();
      var args = {"a": "b", "c": 1, 1: "s", "PK": rand(99)};
      var data = Data.marshal(now, args);
      var sk = genSK();
      var sig = sign(sk, data.bytes);
      var update = Decoded.encode(sig, data);
      var decoded = Decoded.decode(update);
      var args2 = decoded.data.unmarshal();
      args.forEach((key, value) {
        if (value is Uint8List) {
          assert(0 == eq([args2[key], value]));
          return;
        }
        assert(args2[key] == value);
      });
      assert(verify(decoded.data.bytes, decoded.signature, derivePK(sk)));
    }
  });
}
