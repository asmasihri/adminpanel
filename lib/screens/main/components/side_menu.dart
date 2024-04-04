import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parck_ease_admin_panel/screens/Login.dart';
import 'package:parck_ease_admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:parck_ease_admin_panel/screens/main/components/Support.dart';
import 'package:parck_ease_admin_panel/screens/main/main_screen.dart';

class SideMenu extends StatelessWidget {
    final Function(int) onItemSelected;

  const SideMenu({
        required this.onItemSelected,

    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
                  press: () => onItemSelected(0),

          ),
         
         
          DrawerListTile(
            title: "Contact",
            svgSrc: "assets/icons/menu_task.svg",
                   press: () => onItemSelected(1),

          ),
          DrawerListTile(
            title: "Logout",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
               Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LoginView(),
    ),);

            },
          ),
         
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
