import 'package:verival/utils.dart';
import 'package:verival/crypto.dart';
import 'package:test/test.dart';

void main() {
  test("utils", () {
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
  });
}
