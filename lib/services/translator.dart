import 'dart:convert';
import 'package:http/http.dart' as http;

class Translator {
  static final Map<String, String> _cache = {};

  /// Переводит текст с английского на русский через Google Translate (неофициальный API)
  static Future<String> translate(String text) async {
    // Если уже переводили - возвращаем из кэша
    if (_cache.containsKey(text)) {
      return _cache[text]!;
    }

    if (text.trim().isEmpty) return text;

    try {
      // Обрезаем слишком длинный текст
      String shortText = text.length > 1000 ? text.substring(0, 1000) : text;

      // Google Translate неофициальный API
      final url = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?'
            'client=gtx&sl=en&tl=ru&dt=t&q=${Uri.encodeComponent(shortText)}',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        // Google возвращает массив массивов
        final data = jsonDecode(response.body);

        // Собираем перевод из кусочков
        String translated = '';
        if (data is List && data.isNotEmpty && data[0] is List) {
          for (var item in data[0]) {
            if (item is List && item.isNotEmpty) {
              translated += item[0].toString();
            }
          }
        }

        if (translated.isNotEmpty) {
          _cache[text] = translated;
          return translated;
        }

        return text;
      } else {
        return text;
      }
    } catch (e) {
      print('Ошибка перевода: $e');
      return text;
    }
  }
}