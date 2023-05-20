class KeyPair {
  final String uid;
  final String publicKey;
  final String privateKey;

  KeyPair(
      {required this.uid, required this.publicKey, required this.privateKey});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'publicKey': publicKey,
      'privateKey': privateKey,
    };
  }

  factory KeyPair.fromMap(Map<String, dynamic> map) {
    return KeyPair(
      uid: map['uid'] ?? '',
      publicKey: map['publicKey'] ?? '',
      privateKey: map['privateKey'] ?? '',
    );
  }
}
