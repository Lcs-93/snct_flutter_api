import 'package:flutter/material.dart';
import 'package:snct/services/auth_service.dart';
import 'package:snct/models/user.dart';
import 'package:snct/vues/panne_form_page.dart';
import 'package:snct/vues/train_form_page.dart';

class AdminPage extends StatefulWidget {
  final Function(int)? onChangePage;

  const AdminPage({super.key, this.onChangePage});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
                  const Icon(Icons.admin_panel_settings, size: 90, color: Colors.deepPurple),
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
                          label: Text("Administrateur"),
                          avatar: Icon(Icons.verified, color: Colors.white, size: 18),
                          backgroundColor: Colors.deepPurple,
                          labelStyle: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildButton(Icons.receipt, "Voir mes billets", () => goToPage(1)),
                  _buildButton(Icons.train, "Réserver un billet", () => goToPage(0)),
                  _buildButton(Icons.add_alert, "Signaler une panne", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PanneFormPage()));
                  }),
                  _buildButton(Icons.add_box, "Créer un nouveau train", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainFormPage()));
                  }),
                  _buildButton(Icons.edit, "Modifier mon nom", () async {
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
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
                          ElevatedButton(
                            onPressed: () async {
                              final success = await AuthService.updateName(controller.text.trim(), context);
                              Navigator.pop(context);
                              if (success) loadUser();
                            },
                            child: const Text("Sauvegarder"),
                          ),
                        ],
                      ),
                    );
                  }),
                  _buildButton(Icons.logout, "Se déconnecter", () => AuthService.logout(context), color: Colors.red),
                  _buildButton(Icons.delete_forever, "Supprimer mon compte", () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Supprimer le compte"),
                        content: const Text("Es-tu sûr de vouloir supprimer ton compte ?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annuler")),
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
                  }, color: Colors.redAccent),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text("Options", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  _decorativeItem(Icons.settings, "Paramètres"),
                  _decorativeItem(Icons.language, "Langue"),
                  _decorativeItem(Icons.flag, "Pays"),
                  _decorativeItem(Icons.help_outline, "Aide"),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _decorativeItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(label),
    );
  }
}
