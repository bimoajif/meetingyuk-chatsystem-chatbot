import 'package:chatbot_meetingyuk/common/utils/utils.dart';
import 'package:chatbot_meetingyuk/models/user_model.dart';
import 'package:chatbot_meetingyuk/features/chat/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectMerchantRepositoryProvider = Provider(
  (ref) => SelectMerchantRepository(firestore: FirebaseFirestore.instance),
);

class SelectMerchantRepository {
  final FirebaseFirestore firestore;
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  SelectMerchantRepository({required this.firestore});

  Future<List<UserModel>> getMerchants() async {
    List<UserModel> merchants= [];
    try {
      final querySnapshot = await _usersCollection.orderBy('name').get();

      merchants = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel.fromMap(data);
      }).toList();

    } catch(e) {
      debugPrint(e.toString());
    }
    return merchants;
  }

  void selectMerchant(BuildContext context, String desiredUid) async {
    try {
      final merchantQuerySnapshot = await firestore.collection('users').where('uid', isEqualTo: desiredUid).get();

      if(merchantQuerySnapshot.docs.isEmpty) {
        throw Exception('No User Found!');
      }

      final merchantData = UserModel.fromMap(merchantQuerySnapshot.docs.first.data());
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, ChatScreen.routeName, arguments: {
        'profilePic' : merchantData.profilePic,
        'name' : merchantData.name,
        'uid': merchantData.uid
      });
    } catch(e) {
      showSnackbar(context: context, content: e.toString());
    }
  }
}

/**
 * In this implementation, the SelectMerchantRepository class is responsible 
 * for fetching data from the Firestore collection, and the SelectMerchantRepository
 * provider is created with a Provider from flutter_riverpod.
 * 
 * The SelectMerchantController creates a FutureProvider named 
 * selectMerchantRepositoryProvider that depends on the MerchantRepository 
 * provider and fetches the user data.
 * 
 * Finally, the SelectMerchantScreen is a ConsumerWidget that uses the 
 * SelectMerchantControllerProvider provider to display the user data in 
 * a ListView.builder widget. Note that the SelectMerchantScreen depends on the 
 * SelectMerchantController provider, which in turn depends on the 
 *    MerchantRepository provider.
 */
