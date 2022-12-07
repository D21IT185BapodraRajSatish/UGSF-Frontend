import 'package:flutter/material.dart';
import 'package:flutter_and_mysql_server/utils/utils.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 68,
                      backgroundColor: Colors.grey[350],
                    ),
                    VSpace.lg,
                    const Text("Name Of Admin", style: TextStyle(fontSize: 24)),
                  ]),
            ),
            VSpace.med,
            VSpace.lg,
            const Text(
              "Date Of Birth: DD/MM/YYYY",
              style: TextStyle(fontSize: 16),
            ),
            VSpace.med,
            const Text(
              "Personal ID : 12346789",
              style: TextStyle(fontSize: 16),
            ),
            VSpace.med,
            const Text(
              "Address: ABC",
              style: TextStyle(fontSize: 16),
            ),
            VSpace.med,
            const Text(
              "Email : rajbapodra117@gmail.com",
              style: TextStyle(fontSize: 16),
            ),
            VSpace.med,
            const Text(
              "Mobile No : 8758676551",
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, "/login");
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                  elevation: MaterialStateProperty.all(8),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
