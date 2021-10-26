import 'dart:convert';
import 'dart:typed_data';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;
import 'package:crypto/crypto.dart';
import 'package:verival/utils.dart';

void main() {
  {
    var b = rand(222);
    assert(0 == eq([b, decodeString(encodeToString(b))]));
  }
  {
    var b1 = rand(222);
    var b2 = clone(b1);
    assert(0 == eq([b1, b2]));
    var d1 = digest(b1);
    var d2 = digest(b2);
    assert(0 == eq([d1, d2]));
  }
  {
    var sk = genSK();
    var pk = derivePK(sk);
    var msg = rand(222);
    var sig = sign(sk, msg);
    assert(verify(msg, sig, pk));
  }
  {
    var sk = decodeString(
        "DA2Tv+tROfMY974CxL7R2AKIZdbUflTOXa3h6I2WsokhVSKWmrX2khzOp434wpMCqQCJC/AqM6hejdJSRx/oVg==");
    var pk = decodeString("IVUilpq19pIczqeN+MKTAqkAiQvwKjOoXo3SUkcf6FY=");
    var msg = decodeString("Is6v1KR8z5AA5UMN8POoXLE8S2wtxKZeeNR5AHrf8SE=");
    var sig = sign(sk, msg);
    assert(encodeToString(sig) ==
        "qYQsCeAjkDLZVSdrG2nXcTFyYR7td+XblD2RFa3iD8fVBcyB5i313rHGEbhx2Bh8/LaaCfNIwY2kAOPAX85YAg==");
    assert(verify(msg, sig, pk));
  }
}

Uint8List digest(Uint8List data) {
  return Uint8List.fromList(sha256.convert(data).bytes);
}

String encodeToString(Uint8List data) {
  return base64Encode(data);
}

Uint8List decodeString(String str) {
  return base64Decode(str);
}

Uint8List deriveSK(Uint8List seed) {
  return Uint8List.fromList(ed.newKeyFromSeed(seed).bytes);
}

Uint8List genSK() {
  return Uint8List.fromList(ed.generateKey().privateKey.bytes);
}

Uint8List derivePK(Uint8List sk) {
  return sk.sublist(32);
}

Uint8List sign(Uint8List sk, Uint8List msg) {
  return ed.sign(ed.PrivateKey(sk), msg);
}

bool verify(Uint8List msg, Uint8List sign, Uint8List pk) {
  return ed.verify(ed.PublicKey(pk), msg, sign);
}
