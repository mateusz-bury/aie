import 'package:flutter/material.dart';
import '../service/CampaignService.dart';
import '../models/CampaignById.dart';
import 'CampaignPage.dart';
import '../layouts/UserPageLeyout.dart';

class EditCampaignPage extends StatefulWidget {
  final CampaignById campaign;

  const EditCampaignPage({super.key, required this.campaign});

  @override
  _EditCampaignPageState createState() => _EditCampaignPageState();
}

class _EditCampaignPageState extends State<EditCampaignPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.campaign.name);
    descriptionController = TextEditingController(
      text: widget.campaign.description,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await CampaignService.updateCampaign(
        widget.campaign.id,
        nameController.text,
        descriptionController.text,
      );

      if (!mounted) return;
      await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Sukces"),
              content: const Text("Kampania została pomyślnie zaktualizowana."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CampaignPage(campaignId: widget.campaign.id),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Błąd przy zapisie: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserPageLeyout(
      child: Scaffold(
        appBar: AppBar(title: const Text("Edytuj kampanię")),
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
                ElevatedButton(onPressed: _save, child: const Text("Zapisz")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
