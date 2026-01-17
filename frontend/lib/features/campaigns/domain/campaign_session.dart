class CampaignSession {
  final int id;
  final int campaignId;
  final String title;
  final String? description;
  final DateTime createDate;

  const CampaignSession({
    required this.id,
    required this.campaignId,
    required this.title,
    required this.createDate,
    this.description,
  });

  factory CampaignSession.fromJson(Map<String, dynamic> json) {
    return CampaignSession(
      id: json['id'] as int,
      campaignId: json['campaignId'] as int,
      title: (json['title'] ?? '') as String,
      description: json['description'] as String?,
      createDate: DateTime.parse(json['createDate'] as String),
    );
  }
}
