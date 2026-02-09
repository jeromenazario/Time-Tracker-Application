import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Time Tracker',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Projects'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/projects');
              },
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Tasks'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/tasks');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add time entry'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/add');
              },
            ),
            ListTile(
              leading: Icon(Icons.storage),
              title: Text('Storage & Data'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/storage');
              },
            ),
          ],
        ),
      ),
    );
  }
}
