import 'package:dictionaryapp/model/word_model.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Words> words = [];

  //static Iterable<String>? titles;
  static Iterable<String>? display_list = [];
  static List<String>? display_list2 = [];
  static String? word_recent;

  Future getWebsiteData(String word) async {
    final url = Uri.parse('https://sentence.yourdictionary.com/$word');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    List<String>? titles = html
        .querySelectorAll('div.sentence-item > div > p')
        .map((e) => e.innerHtml.trim())
        .toList(growable: false);

    //display_list = titles.where((element) => element.length < 60);

    //print('Count: ${display_list!.length}');

    setState(() {
      words = List.generate(
          titles.length,
          (index) => Words(
              word: titles[index]
                  .replaceAll('<strong>', '')
                  .replaceAll('</strong>', '')));
    });
  }

  void updateWord(String word) {
    setState(() {
      getWebsiteData(word);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 100),
                  TextField(
                    onChanged: (word) => word_recent = word,
                    decoration: InputDecoration(
                        hintText: 'Search Word',
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 5),
                  TextButton(
                      onPressed: () => {updateWord(word_recent!)},
                      child: Text('Apply')),
                  Expanded(
                    child: ListView.builder(
                      itemCount: words.length,
                      itemBuilder: (context, index) {
                        final word = words[index];

                        return ListTile(
                          title: Text(word.word),
                        );
                      },
                    ),
                  )
                ],
              ))),
    );
  }
}
