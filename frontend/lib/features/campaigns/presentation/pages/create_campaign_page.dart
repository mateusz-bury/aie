import 'package:flutter/material.dart';
import 'package:aie/features/campaigns/data/campaign_service.dart';

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
      await CampaignService.createCampaign(
        nameController.text,
        descriptionController.text,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd przy tworzeniu kampanii: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
