import 'package:rss_dart/dart_rss.dart';

class NewsItem {
  final String title;
  final String description;
  final String link;
  final DateTime? pubDate;

  NewsItem({
    required this.title,
    required this.description,
    required this.link,
    this.pubDate,
  });

  factory NewsItem.fromRssItem(RssItem item) {
    return NewsItem(
      title: _cleanText(item.title ?? 'Без заголовка'),
      description: _extractDescription(item.description ?? ''),
      link: item.link ?? '',
      pubDate: item.pubDate != null ? DateTime.tryParse(item.pubDate!) : null,
    );
  }

  // 🧹 Очищаем HTML-теги из текста
  static String _cleanText(String text) {
    return text
        .replaceAll(RegExp(r'<[^>]*>'), '') // убираем HTML-теги
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&#39;', "'")
        .trim();
  }

  // 📝 Извлекаем нормальное описание из HTML
  static String _extractDescription(String html) {
    if (html.isEmpty) return 'Описание отсутствует';

    // Убираем все HTML-теги
    String text = _cleanText(html);

    // Убираем ссылки типа "https://..." из текста
    text = text.replaceAll(RegExp(r'https?://\S+'), '');

    // Убираем лишние пробелы
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Если после очистки пусто - возвращаем заглушку
    if (text.isEmpty) {
      return 'Читайте подробнее по ссылке ниже...';
    }

    return text;
  }
}