import 'package:chatbot_meetingyuk/common/widgets/error_screen.dart';
import 'package:chatbot_meetingyuk/common/widgets/loader.dart';
import 'package:chatbot_meetingyuk/features/select_merchant/controller/select_merchant_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectMerchantScreen extends ConsumerWidget {
  static const String routeName = '/select-merchant';
  const SelectMerchantScreen({super.key});

  void selectMerchant(WidgetRef ref, BuildContext context, String desiredUid) {
    ref
        .read(selectMerchantControllerProvider)
        .selectMerchant(context, desiredUid);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 78,
          backgroundColor: Colors.white,
          elevation: 1,
          foregroundColor: Colors.black,
          centerTitle: false,
          title: const Text(
            'Tambah Pesan',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
          ),
        ),
        body: ref.watch(getMerchantProvider).when(
            data: (merchantList) => ListView.builder(
                  itemCount: merchantList.length,
                  itemBuilder: (context, index) {
                    final merchants = merchantList[index];
                    return InkWell(
                      onTap: () => selectMerchant(
                        ref,
                        context,
                        merchants.uid,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 0.0,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                          leading: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(merchants.profilePic),
                            ),
                          ),
                          title: Text(
                            merchants.name,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader()));
  }
}
