import 'package:flutter/material.dart';
import '../service/CampaignService.dart';
import '../models/CampaignById.dart';

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

    // try {
    //   await CampaignService.updateCampaign(
    //     widget.campaign.id,
    //     name: nameController.text,
    //     description: descriptionController.text,
    //   );

    Navigator.pop(context, true); // powrót do CampaignPage, odświeżamy dane
    // } catch (e) {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(SnackBar(content: Text('Błąd przy zapisie: $e')));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edytuj kampanię")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nazwa kampanii'),
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
    );
  }
}
