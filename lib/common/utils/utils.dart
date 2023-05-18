import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:pointycastle/export.dart';
import 'package:basic_utils/basic_utils.dart';

void showSnackbar({required BuildContext context, required String content}){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content)
    )
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackbar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> takePhotoFromCamera(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackbar(context: context, content: e.toString());
  }
  return image;
}

Future<AsymmetricKeyPair<PublicKey, PrivateKey>> generateRSAKeyPair() async {
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

Future<void> storePEMToFile(AsymmetricKeyPair<PublicKey, PrivateKey> keyPair) async {
  String? pemPublickey =
      CryptoUtils.encodeRSAPublicKeyToPem(keyPair.publicKey as RSAPublicKey);
  String? pemPrivatekey =
      CryptoUtils.encodeRSAPrivateKeyToPem(keyPair.privateKey as RSAPrivateKey);
  File? privateKeyFile = File('key/private.pem');
  File? publicKeyFile = File('key/public.pem');
  try {
    await privateKeyFile.writeAsString(pemPrivatekey);
    await publicKeyFile.writeAsString(pemPublickey);
  } catch (e) {
    throw (e.toString());
  }
}

Future<String?> readFile(path) async {
  try {
    return await File(path).readAsString();
  } catch (e) {
    throw (e.toString());
  }
}

var logger = Logger();