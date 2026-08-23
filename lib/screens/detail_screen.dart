import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/variety.dart';

class DetailScreen extends StatelessWidget {
  final PotatoVariety variety;

  const DetailScreen({super.key, required this.variety});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(variety.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Card1(variety: variety),
            const SizedBox(height: 16),
            _Card2(variety: variety),
            const SizedBox(height: 16),
            _Card3(variety: variety),
            const SizedBox(height: 16),
            _Card4(variety: variety),
            const SizedBox(height: 16),
            _Card5(variety: variety),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// =============================================
// КАРТОЧКА 1: Хозяйственные важные признаки
// =============================================
class _Card1 extends StatelessWidget {
  final PotatoVariety variety;
  const _Card1({required this.variety});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('📋 Хозяйственные важные признаки', Colors.green),
            const SizedBox(height: 16),
            _buildImage(variety.imageBlob, 'Фото клубней'),
            const SizedBox(height: 16),
            _buildRow('Срок созревания', variety.maturationPeriod),
            _buildRow('Направление использования', variety.purpose),
            _buildRow('Вкус', variety.taste),
            _buildRow('Урожайность, ц/га', variety.yieldValue),
            _buildRow('Товарность, %', variety.marketability),
            _buildRow('Лежкость, %', variety.storageQuality),
            _buildRow('Содержание крахмала, %', variety.starchContent),
            _buildRow('Кулинарный тип', variety.culinaryType),
          ],
        ),
      ),
    );
  }
}

// =============================================
// КАРТОЧКА 2: Характеристика клубней
// =============================================
class _Card2 extends StatelessWidget {
  final PotatoVariety variety;
  const _Card2({required this.variety});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('🥔 Характеристика клубней', Colors.orange),
            const SizedBox(height: 16),
            _buildRow('Форма', variety.shape),
            _buildRow('Структура кожуры', variety.skinStructure),
            _buildRow('Цвет кожуры', variety.skinColor),
            _buildRow('Цвет мякоти', variety.fleshColor),
            _buildRow('Глубина глазков', variety.eyeDepth),
            _buildRow('Количество клубней на куст, шт.', variety.tubersPerBush),
            _buildRow('Масса товарного клубня, гр.', variety.tuberWeight),
          ],
        ),
      ),
    );
  }
}

// =============================================
// КАРТОЧКА 3: Морфологические характеристики
// =============================================
class _Card3 extends StatelessWidget {
  final PotatoVariety variety;
  const _Card3({required this.variety});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('🌿 Морфологические характеристики', Colors.blue),
            const SizedBox(height: 16),
            _buildImage(variety.plantImageBlob, 'Фото ростка'),
            const SizedBox(height: 16),
            _buildRow('Высота и форма', variety.bushHeightShape),
            _buildRow('Форма листьев', variety.leafShape),
            _buildRow('Световой росток', variety.sprout),
            _buildRow('Антоциановая окраска', variety.anthocyaninColoring),
            _buildRow('Соцветие', variety.inflorescence),
            _buildRow('Цвет цветков', variety.flowerColor),
            _buildRow('Ягодообразование', variety.berryFormation),
          ],
        ),
      ),
    );
  }
}

// =============================================
// КАРТОЧКА 4: Общая информация
// =============================================
class _Card4 extends StatelessWidget {
  final PotatoVariety variety;
  const _Card4({required this.variety});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('📖 Общая информация', Colors.purple),
            const SizedBox(height: 16),
            _buildRow('Год внесения в реестр РФ', variety.registryYear),
            _buildRow('Патентообладатели', variety.patentHolders),
            _buildRow('Оригинатор', variety.originator),
            _buildRow('Рекомендуемые регионы', variety.recommendedRegions),
            const SizedBox(height: 16),
            if (variety.youtubeUrl.isNotEmpty) _buildYoutubeButton(context, variety.youtubeUrl),
          ],
        ),
      ),
    );
  }

  Widget _buildYoutubeButton(BuildContext context, String url) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: url));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Ссылка на YouTube скопирована!'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        icon: const Icon(Icons.play_circle_fill, color: Colors.white),
        label: const Text('📺 Смотреть видео на YouTube', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

// =============================================
// КАРТОЧКА 5: Устойчивость
// =============================================
class _Card5 extends StatelessWidget {
  final PotatoVariety variety;
  const _Card5({required this.variety});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('🛡️ Устойчивость', Colors.red),
            const SizedBox(height: 16),
            _buildRow('Фитофтороз', variety.phytophthora),
            _buildRow('Рак картофеля', variety.cancer),
            _buildRow('Ризоктониоз', variety.rhizoctonia),
            _buildRow('Парша обыкновенная', variety.commonScab),
            _buildRow('Нематода картофельная', variety.nematode),
            _buildRow('Вирусы', variety.viruses),
            _buildRow('Механические повреждения', variety.mechanicalDamage),
            _buildRow('Альтернариоз', variety.alternaria),
            _buildRow('Фузариоз', variety.fusarium),
            _buildRow('Чёрная ножка', variety.blackLeg),
            _buildRow('Кольцевая гниль', variety.ringRot),
            _buildRow('Другое', variety.other),
          ],
        ),
      ),
    );
  }
}

// =============================================
// ВСПОМОГАТЕЛЬНЫЕ ВИДЖЕТЫ (БЕЗ withOpacity!)
// =============================================

Widget _buildHeader(String title, MaterialColor color) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.info_outline, color: color),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: color.shade800,
          ),
        ),
      ),
    ],
  );
}

Widget _buildImage(dynamic imageBytes, String placeholderText) {
  if (imageBytes != null && imageBytes.isNotEmpty) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.memory(
        imageBytes,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(placeholderText),
      ),
    );
  }
  return _buildPlaceholder(placeholderText);
}

Widget _buildPlaceholder(String text) {
  return Container(
    width: double.infinity,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_not_supported, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(text, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
      ],
    ),
  );
}

Widget _buildRow(String label, String value) {
  if (value.isEmpty) return const SizedBox.shrink();
  
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 180,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}