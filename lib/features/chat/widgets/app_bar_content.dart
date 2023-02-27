import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppBarContent extends StatelessWidget {
  final String profilePic;
  final String name;
  final String status;
  final Color color;
  const AppBarContent({
    super.key, 
    required this.profilePic, 
    required this.name,
    required this.status,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 40.0,
          width: 40.0,
          child: CircleAvatar(
            backgroundImage: NetworkImage(profilePic),
          ),
        ),
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0
                  ),
                ),
                Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color
                  ),
                )
              ],
            ),
            Text(
              status,
              style: const TextStyle(
                fontSize: 14.0,
                color: Color(0xFF666666)
              ),
            ),
          ],
        )
      ],
    );
  }
}
