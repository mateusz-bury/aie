import 'package:flutter/material.dart';
import '../service/CampaignService.dart';
import '../layouts/UserPageLeyout.dart';
import 'CampaignPage.dart';

class CreateCampaignPage extends StatefulWidget {
  const CreateCampaignPage({super.key});

  @override
  _CreateCampaignPageState createState() => _CreateCampaignPageState();
}

class _CreateCampaignPageState extends State<CreateCampaignPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> _createCampaign() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Wywołanie metody serwisu do stworzenia kampanii
      final createdCampaignId = await CampaignService.createCampaign(
        nameController.text,
        descriptionController.text,
      );

      if (!mounted) return;
      await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Sukces"),
              content: const Text("Kampania została pomyślnie utworzona."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
      );

      if (!mounted) return;
      // Przekierowanie do strony nowo utworzonej kampanii
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CampaignPage(campaignId: createdCampaignId),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd przy tworzeniu kampanii: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserPageLeyout(
      child: Scaffold(
        appBar: AppBar(title: const Text("Utwórz nową kampanię")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nazwa kampanii',
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Wpisz nazwę' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Opis kampanii'),
                  maxLines: 4,
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Wpisz opis' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _createCampaign,
                  child: const Text("Utwórz kampanię"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
