import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DropZone web',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Dropzone web '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final List<XFile> _leftFiles = [];
  final List<XFile> _rightFiles = [];

  bool _leftDragging = false;
  bool _rightDragging = false;
  void _clearFiles() {
    setState(() {
      _leftFiles.clear();
      _rightFiles.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints){
          return Scaffold(
            key: scaffoldKey,
            endDrawer: EndDrawer(constraints: constraints,),
            appBar: AppBar(
              title: Text(widget.title),
              actions: [
                TextButton(onPressed: ()=> _clearFiles(), child: Text('Clear'))
              ],
            ),
            body: SizedBox.expand(
              child: Row(
                children: [
                  SizedBox(
                    width: constraints.maxWidth/2,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: DropTarget(
                            onDragDone: (detail) {
                              setState(() {
                                _leftFiles.addAll(detail.files);
                              });
                            },
                            onDragEntered: (detail) {
                              setState(() {
                                _leftDragging = true;
                              });
                            },
                            onDragExited: (detail) {
                              setState(() {
                                _leftDragging = false;
                              });
                            },
                            child: Container(
                              height: 200,
                              width: 200,
                              color:
                              _leftDragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
                              child: _leftFiles.isEmpty
                                  ? const Center(child: Text("Drop here"))
                                  : Text(_leftFiles.join("\n")),
                            ),
                          ),
                        ),
                        if (_leftFiles.isNotEmpty)
                          Align(
                              alignment: Alignment.topCenter,
                              child: DropFilesView(
                                fList: _leftFiles,
                              )),
                      ],
                    ),
                  ),
                  /// Right
                  Expanded(
                    child: DropTarget(
                      onDragDone: (detail) {
                        setState(() {
                          _rightFiles.addAll(detail.files);
                        });
                      },
                      onDragEntered: (detail) {
                        setState(() {
                          _rightDragging = true;
                        });
                      },
                      onDragExited: (detail) {
                        setState(() {
                          _rightDragging = false;
                        });
                      },
                      child: Container(
                        height: constraints.maxHeight,
                        width: 200,
                        color:
                        _rightDragging ? Colors.red.withOpacity(0.4) : Colors.black26,
                        child: _rightFiles.isEmpty
                            ? const Center(child: Text("Drop here"))
                            : DropFilesView(fList: _rightFiles),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                scaffoldKey.currentState?.openEndDrawer();
              },
              child: const Icon(Icons.clear),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        }

    );
  }
}

class DropFilesView extends StatelessWidget {
  const DropFilesView({Key? key, required this.fList}) : super(key: key);
  final List<XFile> fList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: fList.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 60.0,
          width: 300.0,
          child: Card(
            child: ListTile(
              title: Text(fList[index].name),
            ),
          ),
        );
      },
    );
  }
}

class EndDrawer extends StatefulWidget {
  const EndDrawer({Key? key, required this.constraints}) : super(key: key);
  final BoxConstraints constraints;

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {

  final List<XFile> _leftFiles = [];
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.constraints.maxWidth * 0.4,
      height: widget.constraints.maxHeight,
      child: Container(

        child: DropTarget(
          onDragDone: (detail) {
            setState(() {
              _leftFiles.addAll(detail.files);
            });
          },
          onDragEntered: (detail) {
            setState(() {
              _dragging = true;
            });
          },
          onDragExited: (detail) {
            setState(() {
              _dragging = false;
            });
          },
          child: Container(
              height: 200,
              width: 200,
              color:
              _dragging ? Colors.yellow.withOpacity(0.4) : Colors.black26,
              child: _leftFiles.isEmpty
                  ? const Center(child: Text("EndDrawer Drop here"))
                  : DropFilesView(fList: _leftFiles)),
        ),
      ),
    );

  }
}
