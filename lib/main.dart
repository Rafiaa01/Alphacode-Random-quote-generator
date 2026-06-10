import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const QuoteApp());

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Quote Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        useMaterial3: true,
      ),
      home: const QuoteScreen(),
    );
  }
}

class Quote {
  final String text;
  final String author;
  const Quote(this.text, this.author);
}

const List<Quote> _quotes = [
  Quote("The only way to do great work is to love what you do.", "Steve Jobs"),
  Quote("In the middle of every difficulty lies opportunity.", "Albert Einstein"),
  Quote("It does not matter how slowly you go as long as you do not stop.", "Confucius"),
  Quote("Life is what happens when you're busy making other plans.", "John Lennon"),
  Quote("The future belongs to those who believe in the beauty of their dreams.", "Eleanor Roosevelt"),
  Quote("Spread love everywhere you go. Let no one ever come to you without leaving happier.", "Mother Teresa"),
  Quote("When you reach the end of your rope, tie a knot in it and hang on.", "Franklin D. Roosevelt"),
  Quote("Always remember that you are absolutely unique. Just like everyone else.", "Margaret Mead"),
  Quote("Do not go where the path may lead, go instead where there is no path and leave a trail.", "Ralph Waldo Emerson"),
  Quote("You will face many defeats in life, but never let yourself be defeated.", "Maya Angelou"),
  Quote("The greatest glory in living lies not in never falling, but in rising every time we fall.", "Nelson Mandela"),
  Quote("In the end, it's not the years in your life that count. It's the life in your years.", "Abraham Lincoln"),
  Quote("Never let the fear of striking out keep you from playing the game.", "Babe Ruth"),
  Quote("Life is either a daring adventure or nothing at all.", "Helen Keller"),
  Quote("Many of life's failures are people who did not realize how close they were to success when they gave up.", "Thomas A. Edison"),
];

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> with SingleTickerProviderStateMixin {
  late Quote _current;
  final Random _random = Random();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _current = _quotes[_random.nextInt(_quotes.length)];
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _newQuote() async {
    await _controller.reverse();
    setState(() {
      Quote next;
      do {
        next = _quotes[_random.nextInt(_quotes.length)];
      } while (next == _current);
      _current = next;
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.format_quote, size: 56, color: Color(0xFF6C63FF)),
                const SizedBox(height: 8),
                Text(
                  'Random Quote Generator',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: scheme.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Card(
                    elevation: 8,
                    shadowColor: const Color(0x336C63FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(36),
                      child: Column(
                        children: [
                          Text(
                            '"${_current.text}"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 40, height: 2, color: const Color(0xFF6C63FF)),
                              const SizedBox(width: 12),
                              Text(
                                '— ${_current.author}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: scheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(width: 40, height: 2, color: const Color(0xFF6C63FF)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FilledButton.icon(
                  onPressed: _newQuote,
                  icon: const Icon(Icons.refresh_rounded, size: 22),
                  label: const Text('New Quote', style: TextStyle(fontSize: 16)),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
