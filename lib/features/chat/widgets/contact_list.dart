import 'package:chatbot_meetingyuk/common/widgets/loader.dart';
import 'package:chatbot_meetingyuk/features/chat/controller/chat_controller.dart';
import 'package:chatbot_meetingyuk/models/chat_contact.dart';
import 'package:flutter/material.dart';
import 'package:chatbot_meetingyuk/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../screens/chat_screen.dart';

class ContactList extends ConsumerWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).chatContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  var chatContactData = snapshot.data![index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, ChatScreen.routeName,
                              arguments: {
                                'profilePic': chatContactData.profilePic,
                                'name': chatContactData.name,
                                'uid': chatContactData.contactId,
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 0.0),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            leading: SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(chatContactData.profilePic)),
                            ),
                            title: Text(
                              chatContactData.name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18.0),
                            ),
                            subtitle: Text(
                              chatContactData.lastMessage,
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  DateFormat('Hm')
                                      .format(chatContactData.timeSent),
                                  style: const TextStyle(
                                      color: timestampHomeColor),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                SizedBox(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        color: notificationColor,
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 8.0),
                                      child: Text(
                                        '999+',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }));
          }),
    );
  }
}
