import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:make_rank/next_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  XFile? _image;
  Image? _image0;
  Image? _image1;
  Image? _image2;
  Image? _image3;

  final picker = ImagePicker();

  final controller0 = TextEditingController();
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();

  var textFieldList = ["", "", "", ""];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              ListTile(
                leading: GestureDetector(
                  child: _image0 == null ? const Icon(Icons.image) : _image0,
                  onTap: () {
                    _getImage(0);
                  },              
                ),
                title: TextField(
                  controller: controller0,
                  decoration: InputDecoration(
                    hintText: "1位のタイトルを入力"
                  ),
                )
              ),
              ListTile(
                leading: GestureDetector(
                  child: _image1 == null ? const Icon(Icons.image) : _image1,
                  onTap: () {
                    _getImage(1);
                  },              
                ),
                title: TextField(
                  controller: controller1,
                  decoration: const InputDecoration(
                    hintText: "2位のタイトルを入力"
                  ),
                )
              ),
              ListTile(
                leading: GestureDetector(
                  child: _image2 == null ? const Icon(Icons.image) : _image2,
                  onTap: () {
                    _getImage(2);
                  },              
                ),
                title: TextField(
                  controller: controller2,
                  decoration: const InputDecoration(
                    hintText: "3位のタイトルを入力"
                  ),
                )
              ),
              ListTile(
                leading: GestureDetector(
                  child: _image3 == null ? const Icon(Icons.image) : _image3,
                  onTap: () {
                    _getImage(3);
                  },              
                ),
                title: TextField(
                  controller: controller3,
                  decoration: const InputDecoration(
                    hintText: "4位のタイトルを入力"
                  ),
                )
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              child: FloatingActionButton(
                child: const Text("ランキングを作成する"),
                onPressed: () {
                  textFieldList[0] = controller0.text;
                  textFieldList[1] = controller1.text;
                  textFieldList[2] = controller2.text;
                  textFieldList[3] = controller3.text;
                  print(textFieldList);
                  print(_image0);
                  print(_image1);
                  print(_image2);
                  print(_image3);
                  var imageList = [_image0, _image1, _image2, _image3];

                  Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage(textFieldList, imageList)));

                },
              ),
            ),
          )
        ]
      ) , // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future _getImage(int i) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
        final imageForFile = File(_image!.path);
        final imageForImage = Image.file(imageForFile);
        if (i == 0) {
          _image0 = imageForImage;
        } else if (i == 1) {
          _image1 = imageForImage;
        } else if (i == 2) {
          _image2 = imageForImage;
        } else if (i == 3) {
          _image3 = imageForImage;
        }
      } else {
        print('No image selected.');
      }
    });
  }
}
