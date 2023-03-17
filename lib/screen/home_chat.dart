import 'package:chatbot_meetingyuk/common/utils/utils.dart';
import 'package:chatbot_meetingyuk/features/auth/controller/auth_controller.dart';
import 'package:chatbot_meetingyuk/features/chatbot/screen/chatbot_screen.dart';
import 'package:chatbot_meetingyuk/features/select_merchant/screens/select_merchant_screen.dart';
import 'package:chatbot_meetingyuk/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../features/chat/widgets/contact_list.dart';

class HomeChat extends ConsumerStatefulWidget {
  static const String routeName = '/home-chat';
  const HomeChat({super.key});

  @override
  ConsumerState<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends ConsumerState<HomeChat>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // ignore: todo
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      default:
        ref.read(authControllerProvider).setUserState(false);
        break;
      // case AppLifecycleState.inactive:
      // case AppLifecycleState.detached:
      // case AppLifecycleState.paused:
      //   ref.read(authControllerProvider).setUserState(false);
      //   break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        toolbarHeight: 78.0,
        centerTitle: false,
        title: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Image.asset(
              'assets/images/meetingyuk-logo.png',
              height: 28,
              semanticLabel: 'MeetingYuk Logo',
            ),
          ],
        ),
        foregroundColor: Colors.black,
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
              left: 24.0,
              bottom: 8.0,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                const Text(
                  'Chat',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: ContactList())
        ],
      ),
      floatingActionButton: SpeedDial(
        buttonSize: const Size(72.0, 72.0),
        childrenButtonSize: const Size(72.0, 72.0),
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        elevation: 0,
        icon: CustomIcon.chatbotIcon,
        activeIcon: Icons.clear,
        backgroundColor: const Color(0xFF5ABCD0),
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.black,
        spaceBetweenChildren: 15,
        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.add,
              size: 32.0,
            ),
            label: 'Start New Chat',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              logger.v('icon 2 pressed');
              Navigator.pushNamed(context, SelectMerchantScreen.routeName);
            },
          ),
          SpeedDialChild(
            child: const Icon(
              CustomIcon.chatbotIcon,
              size: 32.0,
            ),
            label: 'Chatbot',
            labelStyle: const TextStyle(
              fontSize: 18.0,
            ),
            onTap: () => Navigator.pushNamed(context, ChatbotScreen.routeName)
          )
        ],
      ),
    );
  }
}
