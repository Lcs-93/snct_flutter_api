import 'package:flutter/material.dart';
import 'package:snct/services/auth_service.dart';
import 'package:snct/vues/accueil_vue.dart';
import 'package:snct/vues/login_page.dart';
import 'package:snct/vues/compte_page.dart' as compte;
import 'package:snct/vues/admin_page.dart' as admin;

class NavabarVue extends StatefulWidget {
  final int initialPageIndex;

  const NavabarVue({super.key, this.initialPageIndex = 0});

  @override
  State<NavabarVue> createState() => _NavabarVueState();
}

class _NavabarVueState extends State<NavabarVue> {
  late int currentPageIndex;
  bool isLoggedIn = false;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final user = await AuthService.getUser();
    final role = await AuthService.getUserRole();

    setState(() {
      isLoggedIn = user != null;
      isAdmin = role == 'admin';
    });
  }

  void updatePage(int index) {
    setState(() => currentPageIndex = index);
    checkLoginStatus(); // re-vérifie si admin
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const ListeTram(),
      isLoggedIn ? const Text('Billet') : const LoginPage(),
      isLoggedIn
          ? (isAdmin
              ? admin.AdminPage(onChangePage: updatePage)
              : compte.ComptePage(onChangePage: updatePage))
          : const LoginPage(),
    ];

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: updatePage,
        indicatorColor: const Color.fromARGB(255, 141, 205, 255),
        selectedIndex: currentPageIndex,
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home), label: 'Accueil'),
          const NavigationDestination(icon: Icon(Icons.confirmation_number), label: 'Billets'),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: isAdmin ? 'Admin' : 'Compte',
          ),
        ],
      ),
      body: Card(child: Center(child: pages[currentPageIndex])),
    );
  }
}
