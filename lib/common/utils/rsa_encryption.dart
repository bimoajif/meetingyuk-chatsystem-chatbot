import 'dart:math';
import 'dart:io';
import 'package:convert/convert.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:basic_utils/basic_utils.dart';

// ignore: camel_case_types
class E2EE_RSA {
  AsymmetricKeyPair<PublicKey, PrivateKey> generateRSAKeyPair() {
    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seeds = <int>[];
    for (var i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    final keyParams = RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 64);
    final keyGenerator = RSAKeyGenerator()
      ..init(ParametersWithRandom(keyParams, secureRandom));

    return keyGenerator.generateKeyPair();
  }

  String encrypter(PublicKey publicKey, String text) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    final chiper = encryptor.process(Uint8List.fromList(text.codeUnits));
    return hex.encode(chiper);
  }

  String decrypter(PrivateKey privateKey, String hex) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    final decryptedText =
        String.fromCharCodes(decryptor.process(HexUtils.decode(hex)));
    return decryptedText;
  }
}

void storePEMToFile(AsymmetricKeyPair<PublicKey, PrivateKey> keyPair) {
  String? pemPublickey =
      CryptoUtils.encodeRSAPublicKeyToPem(keyPair.publicKey as RSAPublicKey);
  String? pemPrivatekey =
      CryptoUtils.encodeRSAPrivateKeyToPem(keyPair.privateKey as RSAPrivateKey);
  File? privateKeyFile = File('key/private.pem');
  File? publicKeyFile = File('key/public.pem');
  try {
    privateKeyFile.writeAsStringSync(pemPrivatekey);
    publicKeyFile.writeAsStringSync(pemPublickey);
  } catch (e) {
    throw (e.toString());
  }
}

String readFile(path) {
  try {
    return File(path).readAsStringSync();
  } catch (e) {
    throw (e.toString());
  }
}

String extractKeyString(String keyString) {
  final items = <String>[
    '\n',
    '-----BEGIN PUBLIC KEY-----',
    '-----END PUBLIC KEY-----',
    '-----BEGIN PRIVATE KEY-----',
    '-----END PRIVATE KEY-----',
  ];
  for (var i = 0; i < items.length; i++) {
    keyString = keyString.replaceAll(items[i], '');
  }
  return keyString;
}

String addHeaderFooter(String keyString, bool isPublicKey) {
  const pubHeader = '-----BEGIN PUBLIC KEY-----';
  const pubFooter = '-----END PUBLIC KEY-----';
  const privHeader = '-----BEGIN PRIVATE KEY-----';
  const privFooter = '-----END PRIVATE KEY-----';

  final formattedKey = StringBuffer();

  for (var i = 0; i < keyString.length; i += 64) {
    formattedKey.write(keyString.substring(
        i, i + 64 < keyString.length ? i + 64 : keyString.length));
    formattedKey.write('\n');
  }

  return isPublicKey == true ? '$pubHeader\n$formattedKey$pubFooter' : '$privHeader\n$formattedKey$privFooter';
}
