import 'package:Task/WordMarker.dart';
import 'package:flutter/material.dart';

class WordSearch extends StatefulWidget {
  const WordSearch({Key key, this.alphabet, this.words, this.wordsPerLine})
      : super(key: key);

  final int wordsPerLine;
  final List<String> alphabet;
  final List<String> words;

  @override
  _WordSearchState createState() => _WordSearchState();
}

class _WordSearchState extends State<WordSearch> {
  final markers = <WordMarker>[];
  int correctAnswers = 0;
  var uniqueLetters;


  @override
  void initState() {
    super.initState();
    uniqueLetters = widget.alphabet
        .map((letter) => {'letter': letter, 'key': GlobalKey()})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GridView.count(
            crossAxisCount: widget.wordsPerLine,
            children: <Widget>[
              for (int i = 0; i != uniqueLetters.length; ++i)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      final key = uniqueLetters[i]['key'];
                      final renderBox = key.currentContext.findRenderObject();
                      final markerRect = renderBox.localToGlobal(Offset.zero,
                              ancestor: context.findRenderObject()) &
                          renderBox.size;
                      if (markers.length == correctAnswers) {
                        addMarker(markerRect, i);
                      } else if (widget.words
                          .contains(pathAsString(markers.last.startIndex, i))) {
                        markers.last = adjustedMarker(markers.last, markerRect);
                        ++correctAnswers;
                      } else {
                        markers.removeLast();
                      }
                    });
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      key: uniqueLetters[i]['key'],
                      child: Text(
                        uniqueLetters[i]['letter'],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          ...markers,
        ],
      ),
    );
  }

  void addMarker(Rect rect, int startIndex) {
    markers.add(WordMarker(
      rect: rect,
      startIndex: startIndex,
    ));
  }

  WordMarker adjustedMarker(WordMarker originalMarker, Rect endRect) {
    return originalMarker.copyWith(
        rect: originalMarker.rect.expandToInclude(endRect));
  }

  String pathAsString(int start, int end) {
    final isHorizontal =
        start ~/ widget.wordsPerLine == end ~/ widget.wordsPerLine;
    final isVertical = start % widget.wordsPerLine == end % widget.wordsPerLine;

    String result = '';

    if (isHorizontal) {
      result = widget.alphabet.sublist(start, end + 1).join();
    } else if (isVertical) {
      for (int i = start;
          i < widget.alphabet.length;
          i += widget.wordsPerLine) {
        result += widget.alphabet[i];
      }
    }

    return result;
  }
}