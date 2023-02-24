import 'package:chatbot_meetingyuk/features/select_merchant/repository/select_merchant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getMerchantProvider = FutureProvider((ref) {
  final selectMerchantRepository = ref.watch(selectMerchantRepositoryProvider);
  return selectMerchantRepository.getMerchants();
});

final selectMerchantControllerProvider = Provider((ref) {
  final selectMerchantRepository = ref.watch(selectMerchantRepositoryProvider);
  return SelectMerchantController(ref: ref, selectMerchantRepository: selectMerchantRepository);
});

class SelectMerchantController {
  final ProviderRef ref;
  final SelectMerchantRepository selectMerchantRepository;

  SelectMerchantController({
    required this.ref,
    required this.selectMerchantRepository
  });

  void selectMerchant(BuildContext context, String desiredUid) {
    selectMerchantRepository.selectMerchant(context, desiredUid);
  }
}