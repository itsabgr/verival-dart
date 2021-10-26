import 'dart:typed_data';
import 'package:quiver/core.dart';
import 'package:verival/crypto.dart';
import 'package:verival/utils.dart';
import 'package:cbor/cbor.dart';


class Data {
  final Uint8List bytes;

  Data(this.bytes);

  int timestamp() {
    return ByteData.view(bytes.buffer).getUint64(0, Endian.big);
  }

  Map<dynamic, dynamic> unmarshal() {
    var cbor = Cbor();
    cbor.decodeFromList(bytes.sublist(8));
    var list = cbor.getDecodedData();
    if (list == null || list.length != 1 || list[0] is! Map) {
      return {};
    }
    return list[0];
  }

  static Data marshal(int time, Map<dynamic, dynamic> map) {
    var cbor = Cbor();
    var builder = MapBuilder.builder();
    builder.writeMapImpl(map);
    cbor.encoder.addBuilderOutput(builder.getData());
    List<int> b = List.from(u64tob(time));
    var data = cbor.output.getData();
    b.addAll(data.sublist(0, data.length - 1));
    return Data(Uint8List.fromList(b));
  }

  @override
  int get hashCode => bytes.hashCode;

  @override
  bool operator ==(other) => other is Data && 0 == eq([bytes, other.bytes]);
}

class Decoded {
  final Uint8List signature;
  final Data data;

  Decoded(this.signature, this.data);

  static Decoded decode(Uint8List b) {
    if (b.length < 8) {
      throw eINVALID;
    }
    if (b[0] != 0) {
      throw eINVALID;
    }
    var sigLen = b[1];
    if (b.length < sigLen + 2) {
      throw eINVALID;
    }
    return Decoded(
        b.sublist(2, 2 + sigLen), Data(b.sublist(2 + sigLen, b.length)));
  }

  static Uint8List encode(Uint8List signature, Data data) {
    if (signature.length >= 255) {
      throw eINVALID;
    }
    List<int> b = List.from([0, signature.length]);
    b.addAll(signature);
    b.addAll(data.bytes);
    return Uint8List.fromList(b);
  }

  @override
  int get hashCode => hash2(signature.hashCode, data.hashCode);

  @override
  bool operator ==(other) =>
      other is Decoded &&
      0 == eq([signature, other.signature]) &&
      data == other.data;
}

final eINVALID = "INVALID";
