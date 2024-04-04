import 'package:flutter/material.dart';
import 'package:parck_ease_admin_panel/controllers/MenuAppController.dart';
import 'package:parck_ease_admin_panel/responsive.dart';
import 'package:parck_ease_admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:parck_ease_admin_panel/screens/main/components/Support.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedMenuIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(
        onItemSelected: (index) {
          setState(() {
            _selectedMenuIndex = index;
          });
          Navigator.of(context).pop(); // Ferme le tiroir de navigation
        },
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Afficher ce menu latéral uniquement pour un grand écran
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // prend 1/6 de l'écran
                child: SideMenu(
                  onItemSelected: (index) {
                    setState(() {
                      _selectedMenuIndex = index;
                    });
                  },
                ),
              ),
            Expanded(
              // Il prend 5/6 de l'écran
              flex: 5,
              child: _buildBody(), // Utiliser _buildBody ici
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedMenuIndex) {
      case 0:
        return DashboardScreen();
      case 1:
        return SupportScreen();
      // Ajouter d'autres cas pour d'autres indices
      default:
        return DashboardScreen();
    }
  }
}

