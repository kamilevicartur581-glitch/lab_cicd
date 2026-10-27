import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Новости',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: const NewsScreen(),
    );
  }
}

// ================== МОДЕЛЬ ДАННЫХ ==================
class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});
}

// ================== ЭКРАН ==================
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<Post>> futurePosts;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    futurePosts = _fetchFakePosts(); // Имитация загрузки из сети
  }

  // 🎭 ИМИТАЦИЯ СЕТИ
  Future<List<Post>> _fetchFakePosts() async {
    await Future.delayed(const Duration(seconds: 2)); // Крутилка 2 сек

    // Базовые темы для генерации
    List<String> topics = [
      'В России запустили новый спутник',
      'Курс доллара снизился на торгах',
      'Вышло крупное обновление Flutter',
      'Синоптики предупредили о похолодании',
      'В Москве открыли новую станцию метро',
      'Ученые нашли новый вид животных',
      'Новый закон о поддержке IT-специалистов',
      'Сборная России выиграла товарищеский матч',
      'Искусственный интеллект научился писать музыку',
      'В мире отметили День программиста',
      'Анонсирован выход нового iPhone',
      'На Марсе обнаружены следы воды',
      'В Москве прошел фестиваль уличной еды',
      'Открыт набор в космонавты',
      'Разработан новый электромобиль',
      'Цены на бензин остались без изменений',
      'В театрах стартует новый сезон',
      'Ученые создали вакцину от всех болезней',
      'Российские хакеры выиграли соревнования',
      'Появился новый тренд в TikTok',
      'Банк России снизил ключевую ставку',
      'В Сочи открылся горнолыжный сезон',
      'Найден рецепт идеального борща',
      'Ученые раскрыли секрет долголетия',
      'Вышел новый сезон популярного сериала',
      'В школы внедряют уроки робототехники',
      'Найдена самая старая книга в мире',
      'В Антарктиде зафиксировали рекордную температуру',
      'Открыт новый вид динозавров',
      'Российский фильм получил награду на фестивале',
    ];

    // Генерируем список из 30 постов
    return List.generate(topics.length, (index) {
      return Post(
        id: index + 1,
        title: topics[index],
        body: 'Подробности этой новости появятся позже. Это тестовый текст для демонстрации работы приложения. '
            'Здесь могла быть ваша реклама, но мы пишем новости. Данные сгенерированы автоматически для лабораторной работы.',
      );
    });
  }

  void _retry() {
    setState(() {
      futurePosts = _fetchFakePosts(); // Повторный "запрос"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📰 Новости'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 🔍 Поиск
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск по заголовку...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // 📋 Список новостей
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: futurePosts,
              builder: (context, snapshot) {
                // 1. Загрузка
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.deepPurple),
                        SizedBox(height: 16),
                        Text('Загрузка новостей...', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                // 2. Ошибка
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.sentiment_dissatisfied, size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('Ошибка загрузки данных', style: TextStyle(fontSize: 18, color: Colors.grey)),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _retry,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Повторить попытку'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // 3. Успех
                if (snapshot.hasData) {
                  var posts = snapshot.data!;

                  if (_searchQuery.isNotEmpty) {
                    posts = posts.where((post) => post.title.toLowerCase().contains(_searchQuery)).toList();
                  }

                  if (posts.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Ничего не найдено', style: TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            child: Text('${post.id}', style: TextStyle(color: Colors.deepPurple.shade900, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepPurple),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailScreen(post: post),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================== ЭКРАН ДЕТАЛЕЙ ==================
class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали новости'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                post.body,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}