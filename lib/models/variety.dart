import 'dart:typed_data';

class PotatoVariety {
  final int? id;
  final String name;
  
  // Карточка 1
  final Uint8List? imageBlob;
  final String maturationPeriod;
  final String purpose;
  final String taste;
  final String yieldValue;
  final String marketability;
  final String storageQuality;
  final String starchContent;
  final String culinaryType;
  
  // Карточка 2
  final String shape;
  final String skinStructure;
  final String skinColor;
  final String fleshColor;
  final String eyeDepth;
  final String tubersPerBush;
  final String tuberWeight;
  
  // Карточка 3
  final Uint8List? plantImageBlob;
  final String bushHeightShape;
  final String leafShape;
  final String sprout;
  final String anthocyaninColoring;
  final String inflorescence;
  final String flowerColor;
  final String berryFormation;
  
  // Карточка 4
  final String registryYear;
  final String patentHolders;
  final String originator;
  final String recommendedRegions;
  final String youtubeUrl;
  
  // Карточка 5
  final String phytophthora;
  final String cancer;
  final String rhizoctonia;
  final String commonScab;
  final String nematode;
  final String viruses;
  final String mechanicalDamage;
  final String alternaria;
  final String fusarium;
  final String blackLeg;
  final String ringRot;
  final String other;

  const PotatoVariety({
    this.id,
    required this.name,
    this.imageBlob,
    this.maturationPeriod = '',
    this.purpose = '',
    this.taste = '',
    this.yieldValue = '',
    this.marketability = '',
    this.storageQuality = '',
    this.starchContent = '',
    this.culinaryType = '',
    this.shape = '',
    this.skinStructure = '',
    this.skinColor = '',
    this.fleshColor = '',
    this.eyeDepth = '',
    this.tubersPerBush = '',
    this.tuberWeight = '',
    this.plantImageBlob,
    this.bushHeightShape = '',
    this.leafShape = '',
    this.sprout = '',
    this.anthocyaninColoring = '',
    this.inflorescence = '',
    this.flowerColor = '',
    this.berryFormation = '',
    this.registryYear = '',
    this.patentHolders = '',
    this.originator = '',
    this.recommendedRegions = '',
    this.youtubeUrl = '',
    this.phytophthora = '',
    this.cancer = '',
    this.rhizoctonia = '',
    this.commonScab = '',
    this.nematode = '',
    this.viruses = '',
    this.mechanicalDamage = '',
    this.alternaria = '',
    this.fusarium = '',
    this.blackLeg = '',
    this.ringRot = '',
    this.other = '',
  });

  factory PotatoVariety.fromMap(Map<String, dynamic> map) {
    return PotatoVariety(
      id: map['id'] as int?,
      name: map['name'] as String,
      imageBlob: map['image_blob'] as Uint8List?,
      maturationPeriod: map['maturation_period'] ?? '',
      purpose: map['purpose'] ?? '',
      taste: map['taste'] ?? '',
      yieldValue: map['yield_value'] ?? '',
      marketability: map['marketability'] ?? '',
      storageQuality: map['storage_quality'] ?? '',
      starchContent: map['starch_content'] ?? '',
      culinaryType: map['culinary_type'] ?? '',
      shape: map['shape'] ?? '',
      skinStructure: map['skin_structure'] ?? '',
      skinColor: map['skin_color'] ?? '',
      fleshColor: map['flesh_color'] ?? '',
      eyeDepth: map['eye_depth'] ?? '',
      tubersPerBush: map['tubers_per_bush'] ?? '',
      tuberWeight: map['tuber_weight'] ?? '',
      plantImageBlob: map['plant_image_blob'] as Uint8List?,
      bushHeightShape: map['bush_height_shape'] ?? '',
      leafShape: map['leaf_shape'] ?? '',
      sprout: map['sprout'] ?? '',
      anthocyaninColoring: map['anthocyanin_coloring'] ?? '',
      inflorescence: map['inflorescence'] ?? '',
      flowerColor: map['flower_color'] ?? '',
      berryFormation: map['berry_formation'] ?? '',
      registryYear: map['registry_year'] ?? '',
      patentHolders: map['patent_holders'] ?? '',
      originator: map['originator'] ?? '',
      recommendedRegions: map['recommended_regions'] ?? '',
      youtubeUrl: map['youtube_url'] ?? '',
      phytophthora: map['phytophthora'] ?? '',
      cancer: map['cancer'] ?? '',
      rhizoctonia: map['rhizoctonia'] ?? '',
      commonScab: map['common_scab'] ?? '',
      nematode: map['nematode'] ?? '',
      viruses: map['viruses'] ?? '',
      mechanicalDamage: map['mechanical_damage'] ?? '',
      alternaria: map['alternaria'] ?? '',
      fusarium: map['fusarium'] ?? '',
      blackLeg: map['black_leg'] ?? '',
      ringRot: map['ring_rot'] ?? '',
      other: map['other'] ?? '',
    );
  }
}