library compte_page;
import 'package:flutter/material.dart';
import 'package:snct/services/auth_service.dart';
import 'package:snct/models/user.dart';

class ComptePage extends StatefulWidget {
  final Function(int)? onChangePage;

  const ComptePage({super.key, this.onChangePage});

  @override
  State<ComptePage> createState() => _ComptePageState();
}

class _ComptePageState extends State<ComptePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final data = await AuthService.getUser();
    if (data != null) {
      setState(() => user = User.fromJson(data));
    }
  }

  Future<void> editName() async {
    final controller = TextEditingController(text: user?.name ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Modifier le nom'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Nouveau nom"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await AuthService.updateName(
                controller.text.trim(),
                context,
              );
              Navigator.pop(context);
              if (success) loadUser();
            },
            child: const Text("Sauvegarder"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteAccount() async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer le compte"),
        content: const Text("Es-tu sûr de vouloir supprimer ton compte ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.deleteAccount(context);
    }
  }

  void goToPage(int index) {
    if (widget.onChangePage != null) {
      widget.onChangePage!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FF),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
              child: ListView(
                children: [
                  const Icon(Icons.account_circle, size: 90, color: Colors.deepPurple),
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          user!.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user!.email,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        const Chip(
                          label: Text("Voyageur régulier"),
                          avatar: Icon(Icons.verified, color: Colors.white, size: 18),
                          backgroundColor: Colors.deepPurple,
                          labelStyle: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Icon(Icons.credit_card, color: Colors.deepPurple),
                      title: Text("Carte Visa - **** 1234"),
                      subtitle: Text("Exp. 12/28"),
                      trailing: TextButton(
                        onPressed: () {},
                        child: const Text("Modifier"),
                      ),
                    ),
                  ),
                  _buildButton(Icons.receipt, "Voir mes billets", () => goToPage(1)),
                  _buildButton(Icons.train, "Réserver un billet", () => goToPage(0)),
                  _buildButton(Icons.edit, "Modifier mon nom", editName),
                  _buildButton(Icons.logout, "Se déconnecter", () => AuthService.logout(context), color: Colors.red),
                  _buildButton(Icons.delete_forever, "Supprimer mon compte", deleteAccount, color: Colors.redAccent),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text("Options", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  _decorativeItem(Icons.person_outline, "Mes données"),
                  _decorativeItem(Icons.settings, "Paramètres"),
                  _decorativeItem(Icons.language, "Langue"),
                  _decorativeItem(Icons.flag, "Pays"),
                  _decorativeItem(Icons.help_outline, "Aide"),
                  _decorativeItem(Icons.download, "Télécharger mes données", onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Téléchargement en cours...")),
                    );
                  }),
                ],
              ),
            ),
    );
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onPressed, {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.deepPurple,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _decorativeItem(IconData icon, String label, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(label),
      onTap: onTap,
    );
  }
}
