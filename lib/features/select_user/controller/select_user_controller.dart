import 'package:chatbot_meetingyuk/features/select_user/repository/select_user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserProvider = FutureProvider((ref) {
  final selectUserRepository = ref.watch(selectUserRepositoryProvider);
  return selectUserRepository.getUsers();
});

final selectUserControllerProvider = Provider((ref) {
  final selectUserRepository = ref.watch(selectUserRepositoryProvider);
  return SelectUserController(ref: ref, selectUserRepository: selectUserRepository);
});

class SelectUserController {
  final ProviderRef ref;
  final SelectUserRepository selectUserRepository;

  SelectUserController({
    required this.ref,
    required this.selectUserRepository
  });

  void selectUser(BuildContext context, String desiredUid) {
    selectUserRepository.selectUser(context, desiredUid);
  }
}