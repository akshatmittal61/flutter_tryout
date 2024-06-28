import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favs = <WordPair>[];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFav() {
    if (favs.contains(current)) {
      favs.remove(current);
    } else {
      favs.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget pageToRender = Placeholder();
    switch (selectedIndex) {
      case 0:
        pageToRender = GeneratorPage();
      case 1:
        pageToRender = FavoritesPage();
      default:
        throw UnimplementedError('no widget for index $selectedIndex');
    }
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
              child: NavigationRail(
            extended: false,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
                selectedIcon: Icon(Icons.home_filled),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite_border),
                label: Text('Favorites'),
                selectedIcon: Icon(Icons.favorite),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
          )),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: pageToRender,
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    WordPair word = appState.current;
    var btnIcon =
        appState.favs.contains(word) ? Icons.favorite : Icons.favorite_border;

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('I don\'t see how that is a random idea:'),
          SizedBox(height: 10),
          ResultCard(word: word),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => appState.toggleFav(),
                label: Text('Like'),
                icon: Icon(btnIcon),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              )
            ],
          )
        ]);
  }
}

/* class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var words = appState.favs;
    return ListView(
      children: words
          .map((w) => ResultCard(word: w))
          .toList(),
    );
  }
} */

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var words = appState.favs;
    var theme = Theme.of(context);
    var style =
        theme.textTheme.titleLarge!.copyWith(color: theme.colorScheme.primary);
    /* return Column(
      children: [
        Expanded(
          child: Text('You have ${words.length} favorite${words.length == 1 ? '' : 's'}:', style: style),
        ),
        Expanded(
            child: ListView(
          children: words
              .map((w) => Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.favorite),
                    ),
                    Text(w.asPascalCase),
                  ]))
              .toList(),
        ))
      ],
    ); */
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
            'You have ${words.length} favorite${words.length == 1 ? '' : 's'}:',
            style: style),
      ),
      ...words
          .map((w) => ListTile(
                leading: Icon(Icons.favorite),
                title: Text(w.asPascalCase),
              ))
          .toList(),
    ]);
  }
}

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.word,
  });

  final WordPair word;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 24, 12, 24),
        child: Text(
          'Anyway, here it is: ${word.asPascalCase}',
          style: style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
