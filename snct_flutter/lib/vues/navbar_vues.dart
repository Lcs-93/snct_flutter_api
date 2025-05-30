import 'package:flutter/material.dart';
import 'package:snct/services/auth_service.dart';
import 'package:snct/vues/accueil_vue.dart';
import 'package:snct/vues/compte_page.dart';
import 'package:snct/vues/login_page.dart';

class NavabarVue extends StatefulWidget {
  final int initialPageIndex;

  const NavabarVue({super.key, this.initialPageIndex = 0});

  @override
  State<NavabarVue> createState() => _NavabarVueState();
}

class _NavabarVueState extends State<NavabarVue> {
  late int currentPageIndex;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final user = await AuthService.getUser();
    setState(() {
      isLoggedIn = user != null;
    });
  }

void updatePage(int index) {
  setState(() => currentPageIndex = index);
}

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const ListeTram(),
      isLoggedIn ? const Text('Billet') : const LoginPage(),
      isLoggedIn ? ComptePage(onChangePage: updatePage) : const LoginPage(),
    ];

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: updatePage,
        indicatorColor: const Color.fromARGB(255, 141, 205, 255),
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.confirmation_number), label: 'Billets'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Compte'),
        ],
      ),
      body: Card(child: Center(child: pages[currentPageIndex])),
    );
  }
}
