import 'package:flutter/material.dart';
import 'package:chatbot_meetingyuk/colors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../features/chat/screens/chat_screen.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        itemBuilder: ((context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(profilePic: '', name: 'BMerchant2', uid: 'NdYVY6RuJVALGcLBxAdh',)
                    )
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                    leading: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/placeholder-image-account.png'),
                      ),
                    ),
                    title: Text(
                      'Placeholder Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0
                      ),
                    ),
                    subtitle: Text(
                      'hello world!',
                      style: TextStyle(
                        fontSize: 14.0
                      ),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '4:20 pm',
                          style: TextStyle(
                            color: timestampHomeColor
                          ),
                        ),
                        SizedBox(height: 4,),
                        SizedBox(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: notificationColor,
                              borderRadius: BorderRadius.circular(50.0)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                              child: Text(
                                '999+',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic
                                ),
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
        })
      ),
    );
  }
}