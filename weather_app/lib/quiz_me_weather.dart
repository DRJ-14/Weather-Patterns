import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class QuizMeWeatherPage extends StatefulWidget {
  @override
  _QuizMeWeatherPageState createState() => _QuizMeWeatherPageState();
}

class _QuizMeWeatherPageState extends State<QuizMeWeatherPage> {
  int _currentIndex = 0;
  int _score = 0;
  bool _isTranslated = false;
  final Map<int, String> _userAnswers = {};
  final translator = GoogleTranslator();
  String? _feedback;

  late final List<Map<String, Object>> _originalQuestions;
  late List<Map<String, Object>> _questions;

  @override
  void initState() {
    super.initState();
    _originalQuestions = [
      {
        'question': 'What causes thunder?',
        'image':
            'https://images.pexels.com/photos/2684011/pexels-photo-2684011.jpeg',
        'options': ['Wind', 'Lightning', 'Rain'],
        'answer': 'Lightning',
      },
      {
        'question': 'Which season is the coldest?',
        'image':
            'https://weatherandthefourseasonsgr1.weebly.com/uploads/1/4/9/1/14919314/341858562.jpg?664n',
        'options': ['Summer', 'Winter', 'Spring'],
        'answer': 'Winter',
      },
      {
        'question': 'Which cloud is fluffy and white?',
        'image':
            'https://images.pexels.com/photos/4610805/pexels-photo-4610805.jpeg',
        'options': ['Cumulus', 'Stratus', 'Nimbus'],
        'answer': 'Cumulus',
      },
      {
        'question': 'What do we see in the sky after rain and sun?',
        'image':
            'https://images.pexels.com/photos/22129996/pexels-photo-22129996/free-photo-of-rainbow-over-a-station.jpeg',
        'options': ['Clouds', 'Rainbow', 'Lightning'],
        'answer': 'Rainbow',
      },
      {
        'question': 'What instrument measures temperature?',
        'image':
            'https://images.pexels.com/photos/139398/thermometer-headache-pain-pills-139398.jpeg',
        'options': ['Barometer', 'Thermometer', 'Rain Gauge'],
        'answer': 'Thermometer',
      },
      {
        'question': 'What do we wear to keep warm in winter?',
        'image':
            'https://images.pexels.com/photos/1620653/pexels-photo-1620653.jpeg',
        'options': ['Jacket', 'Swimsuit', 'Flip Flops'],
        'answer': 'Jacket',
      },
      {
        'question': 'What shines in the sky during the day?',
        'image':
            'https://images.pexels.com/photos/2132180/pexels-photo-2132180.jpeg',
        'options': ['Stars', 'Moon', 'Sun'],
        'answer': 'Sun',
      },
      {
        'question': 'What do we see in the sky at night?',
        'image':
            'https://images.pexels.com/photos/414523/pexels-photo-414523.jpeg',
        'options': ['Sun', 'Moon', 'Clouds'],
        'answer': 'Moon',
      },
      {
        'question': 'What covers the ground when it snows a lot?',
        'image':
            'https://images.pexels.com/photos/311066/pexels-photo-311066.jpeg',
        'options': ['Water', 'Ice', 'Snow'],
        'answer': 'Snow',
      },
      {
        'question': 'What makes the leaves fall from trees in autumn?',
        'image':
            'https://images.pexels.com/photos/30172561/pexels-photo-30172561/free-photo-of-serene-autumn-pathway-through-forest-landscape.jpeg',
        'options': ['Snow', 'Rain', 'Wind'],
        'answer': 'Wind',
      },
      {
        'question': 'What do we wear on our feet in rainy weather?',
        'image':
            'https://images.pexels.com/photos/3036397/pexels-photo-3036397.jpeg',
        'options': ['Sandals', 'Rain boots', 'Slippers'],
        'answer': 'Rain boots',
      },
      {
        'question': 'What do we feel when the sun shines?',
        'image':
            'https://images.pexels.com/photos/783222/pexels-photo-783222.jpeg',
        'options': ['Cold', 'Warmth', 'Snowflakes'],
        'answer': 'Warmth',
      },
    ];

    // Start with English questions
    _questions = List.from(_originalQuestions);
  }

  void _answerQuestion(String selected) {
    final correct = _questions[_currentIndex]['answer'] as String;
    if (selected == correct) {
      _score++;
      _feedback = '✅ Correct! 🎉';
    } else {
      _feedback = '❌ Wrong! Correct answer: $correct';
    }
    setState(() {
      _userAnswers[_currentIndex] = selected;
      _userAnswers[_currentIndex] = selected;
      // _currentIndex++;
    });
  }

  Future<void> _toggleTranslation() async {
    if (!_isTranslated) {
      final translated = await Future.wait(
        _originalQuestions.map((q) async {
          final translatedQuestion = await translator.translate(
            q['question'] as String,
            to: 'es',
          );
          final translatedAnswer = await translator.translate(
            q['answer'] as String,
            to: 'es',
          );
          return <String, Object>{
            'question': translatedQuestion.text,
            'image': q['image'] as String,
            'options': q['options'] as List<String>,
            'answer': translatedAnswer.text,
          };
        }),
      );

      setState(() {
        _questions = translated;
        _isTranslated = true;
      });
    } else {
      setState(() {
        _questions = List.from(_originalQuestions);
        _isTranslated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isQuizDone = _currentIndex >= _questions.length;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 600 ? screenWidth * 0.7 : screenWidth * 0.9;

    return Scaffold(
      extendBodyBehindAppBar:
          true, // ✅ this allows the background to go behind AppBar
      backgroundColor: Colors.transparent, // so background image shows
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.7),
        elevation: 0,
        title: const Text(
          'Weather Quiz Time!',
          style: TextStyle(fontFamily: 'ComicSans', color: Colors.black),
        ),
        centerTitle: true,
        actions:
            isQuizDone
                ? [
                  IconButton(
                    icon: const Icon(Icons.translate),
                    tooltip:
                        _isTranslated
                            ? 'Translate to English'
                            : 'Translate to Spanish',
                    onPressed: _toggleTranslation,
                  ),
                ]
                : null,
      ),
      body: Stack(
        children: [
          // ✅ Fullscreen background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/quiz_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // ✅ Foreground quiz content
          isQuizDone ? _buildResults(cardWidth) : _buildQuestionCard(cardWidth),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(double cardWidth) {
    final q = _questions[_currentIndex];
    return Center(
      child: Card(
        elevation: 10,
        color: Colors.yellow[100],
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: cardWidth,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                q['image'] as String,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                q['question'] as String,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicSans',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (_feedback != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _feedback!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          _feedback!.startsWith("✅")
                              ? Colors.green
                              : Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_userAnswers.containsKey(_currentIndex))
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex++;
                      _feedback = null;
                    });
                  },
                  child: Text("Next Question ➡️"),
                ),

              ...(q['options'] as List<String>).map(
                (opt) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _HoverButton(
                    label: opt,
                    onTap: () => _answerQuestion(opt),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(double cardWidth) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Card(
          elevation: 8,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Quiz Finished!',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicSans',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Your score is $_score / ${_questions.length}',
                  style: TextStyle(fontSize: 22, fontFamily: 'ComicSans'),
                ),
                const SizedBox(height: 24),
                const Divider(thickness: 2),
                const Text(
                  'Review Answers:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ..._questions.asMap().entries.map((entry) {
                  int index = entry.key;
                  var q = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      tileColor: Colors.lightBlue[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: Image.network(
                        q['image'] as String,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        q['question'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'Your answer: ${_userAnswers[index] ?? 'N/A'}\nCorrect answer: ${q['answer']}',
                        style: TextStyle(
                          color:
                              (_userAnswers[index] == q['answer'])
                                  ? Colors.green
                                  : Colors.redAccent,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                if (_feedback != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _feedback!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            _feedback!.startsWith("✅")
                                ? Colors.green
                                : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_userAnswers.containsKey(_currentIndex))
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex++;
                        _feedback = null;
                      });
                    },
                    child: Text("Next Question ➡️"),
                  ),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _score = 0;
                      _currentIndex = 0;
                      _userAnswers.clear();
                      _questions = List.from(_originalQuestions);
                      _isTranslated = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                  ),
                  child: const Text('Play Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _HoverButton({required this.label, required this.onTap});

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _hovering ? Colors.deepPurpleAccent : Colors.lightBlueAccent,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: widget.onTap,
        child: Text(
          widget.label,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'ComicSans',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
