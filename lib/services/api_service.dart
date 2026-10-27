import 'package:http/http.dart' as http;
import 'package:rss_dart/dart_rss.dart';
import '../models/news_model.dart';

class ApiService {
  Future<List<NewsItem>> fetchNews() async {
    // Используем Google News RSS с запросом, например, "Россия" и русским языком
    // Вы можете заменить "Россия" на любую интересующую тему: "технологии", "спорт" и т.д.
    final String feedUrl = 'https://news.google.com/rss/search?q=Россия&hl=ru&gl=RU&ceid=RU:ru';

    try {
      final response = await http.get(Uri.parse(feedUrl));

      if (response.statusCode == 200) {
        // Парсим RSS 2.0 фид
        final RssFeed feed = RssFeed.parse(response.body);

        // Преобразуем список RssItem в список наших моделей NewsItem
        // И отсекаем элементы без заголовка
        return feed.items
            .where((item) => item.title != null && item.title!.isNotEmpty)
            .map((item) => NewsItem.fromRssItem(item))
            .toList();
      } else {
        throw Exception('Не удалось загрузить новости. Код ответа: ${response.statusCode}');
      }
    } catch (e) {
      // Пробрасываем ошибку дальше, чтобы её можно было показать в UI
      throw Exception('Ошибка при получении новостей: $e');
    }
  }
}