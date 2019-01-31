import 'dart:typed_data';

final _minusOne = new BigInt.from(-1);

BigInt readBytes(Uint8List bytes) {
  var isNegative = false;
//  var isNegative = (bytes[0] & 0x80) != 0;
  var result = BigInt.zero;
  for (int i = 0; i < bytes.length; ++i) {
    result = result << 8;
    var x = false ? (bytes[i] ^ 0xff) : bytes[i];
    result += new BigInt.from(x);
  }
  if (isNegative) return (result + BigInt.one) * _minusOne;

  return result;
}

var _negOneArray = Uint8List.fromList([0xff]);
final _zeroList = new Uint8List.fromList([0]);
var _negOne = BigInt.from(-1);
final _b256 = new BigInt.from(256);

void _twosComplement(Uint8List result) {
  var carry = 1;
  for (int j = result.length - 1; j >= 0; --j) {
    // flip the bits
    result[j] ^= 0xFF;

    if (result[j] == 255 && carry == 1) {
      // overflow
      result[j] = 0;
      carry = 1;
    } else {
      result[j] += carry;
      carry = 0;
    }
  }
  result[0] = result[0] | 0x80;
}

/*
Uint8List bigIntToBytes(BigInt number) {
  var orig = number;

  if (number.bitLength == 0) {
    if (number == _negOne)
      return _negOneArray;
    else
      return _zeroList;
  }
// we may need one extra byte for padding
  var bytes = (number.bitLength / 8).ceil() + 1;
  var result = new Uint8List(bytes);

  number = number.abs();
  for (int i = 0, j = bytes - 1; i < (bytes); i++, --j) {
    var x = number.remainder(_b256).toInt();
    result[j] = x;
    number = number >> 8;
  }

  if (orig.isNegative) {
    _twosComplement(result);
    if ((result[1] & 0x80) ==
        0x80) // high order bit is a one - we don't need pad
      return result.sublist(1);
  } else {
    if ((result[1] & 0x80) != 0x80)
      return result.sublist(1); // hi order bit is a 0, we dont need pad
  }
  return result;
}
 */

List<int> bigIntToBytes(BigInt data) {
  String str;
  bool neg = false;
  if (data < BigInt.zero) {
    str = (~data).toRadixString(16);
    neg = true;
  } else {
    str = data.toRadixString(16);
  }
  int p = 0;
  int len = str.length;

  int blen = (len + 1) ~/ 2;
  int boff = 0;
  List bytes;
  if (neg) {
    if (len & 1 == 1) {
      p = -1;
    }
    int byte0 = ~int.parse(str.substring(0, p + 2), radix: 16);
    if (byte0 < -128) byte0 += 256;
    if (byte0 >= 0) {
      boff = 1;
      bytes = new List<int>(blen + 1);
      bytes[0] = -1;
      bytes[1] = byte0;
    } else {
      bytes = new List<int>(blen);
      bytes[0] = byte0;
    }
    for (int i = 1; i < blen; ++i) {
      int byte = ~int.parse(str.substring(p + (i << 1), p + (i << 1) + 2),
          radix: 16);
      if (byte < -128) byte += 256;
      bytes[i + boff] = byte;
    }
  } else {
    if (len & 1 == 1) {
      p = -1;
    }
    int byte0 = int.parse(str.substring(0, p + 2), radix: 16);
    if (byte0 > 127) byte0 -= 256;
    if (byte0 < 0) {
      boff = 1;
      bytes = new List<int>(blen + 1);
      bytes[0] = 0;
      bytes[1] = byte0;
    } else {
      bytes = new List<int>(blen);
      bytes[0] = byte0;
    }
    for (int i = 1; i < blen; ++i) {
      int byte =
      int.parse(str.substring(p + (i << 1), p + (i << 1) + 2), radix: 16);
      if (byte > 127) byte -= 256;
      bytes[i + boff] = byte;
    }
  }
  return bytes;
}

//Uint8List bigIntToBytes(BigInt data) {
//  String str;
//  bool neg = false;
//  if (data < BigInt.zero) {
//    str = (~data).toRadixString(16);
//    neg = true;
//  } else {
//    str = data.toRadixString(16);
//  }
//  int p = 0;
//  int len = str.length;
//
//  int blen = (len + 1) ~/ 2;
//  int boff = 0;
//  List bytes;
//  if (neg) {
//    if (len & 1 == 1) {
//      p = -1;
//    }
//    int byte0 = ~int.parse(str.substring(0, p + 2), radix: 16);
//    if (byte0 < -128) byte0 += 256;
//    if (byte0 >= 0) {
//      boff = 1;
//      bytes = new List<int>(blen + 1);
//      bytes[0] = -1;
//      bytes[1] = byte0;
//    } else {
//      bytes = new List<int>(blen);
//      bytes[0] = byte0;
//    }
//    for (int i = 1; i < blen; ++i) {
//      int byte =
//          ~int.parse(str.substring(p + (i << 1), p + (i << 1) + 2), radix: 16);
//      if (byte < -128) byte += 256;
//      bytes[i + boff] = byte;
//    }
//  } else {
//    if (len & 1 == 1) {
//      p = -1;
//    }
//    int byte0 = int.parse(str.substring(0, p + 2), radix: 16);
//    if (byte0 > 127) byte0 -= 256;
//    if (byte0 < 0) {
//      boff = 1;
//      bytes = new List<int>(blen + 1);
//      bytes[0] = 0;
//      bytes[1] = byte0;
//    } else {
//      bytes = new List<int>(blen);
//      bytes[0] = byte0;
//    }
//    for (int i = 1; i < blen; ++i) {
//      int byte =
//          int.parse(str.substring(p + (i << 1), p + (i << 1) + 2), radix: 16);
//      if (byte > 127) byte -= 256;
//      bytes[i + boff] = byte;
//    }
//  }
//  return new Uint8List.fromList(bytes);
//}
