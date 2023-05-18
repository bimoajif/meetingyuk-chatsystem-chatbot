import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/random/fortuna_random.dart';

void main() {
  // Generate a new RSA key pair
  final keyGenerator = RSAKeyGenerator()
    ..init(ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 64),
        FortunaRandom())); // Use FortunaRandom as the secure random number generator
  final keyPair = keyGenerator.generateKeyPair();

  // Encrypt the message with the public key
  final message = 'Hello, World!';
  final plainText = Uint8List.fromList(utf8.encode(message));
  final publicKey = keyPair.publicKey as RSAPublicKey;
  final encryptor = RSAEngine()
    ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
  final encrypted =
      encryptor.process(plainText) as Uint8List;

  print('Encrypted message: ${base64.encode(encrypted)}');

  // Decrypt the message with the private key
  final privateKey = keyPair.privateKey as RSAPrivateKey;
  final decryptor = RSAEngine()
    ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
  final decrypted =
      decryptor.process(encrypted) as Uint8List;

  final decryptedText = utf8.decode(decrypted);
  print('Decrypted message: $decryptedText');
}
