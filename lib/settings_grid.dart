import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:make_rank/main.dart';

class SettingsGrid extends StatefulWidget {
  @override
  State<SettingsGrid> createState() => _MyPageState();
}

class _MyPageState extends State<SettingsGrid> {
  var _radVal = gridSize;

/*
  void _onChanged(GridSize value) {
    setState(() {
      _radVal = value;
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_radVal);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        backgroundColor: Color(0xFFF2F2F7),
        body: Container(
          //        padding: EdgeInsets.all(10.0),
          padding: EdgeInsets.only(right: 10, left: 10, top: 20),
          //        height: 2000,
          child: Column(
            children: <Widget>[
              Container(
                //              height: 80,
                //              alignment: Alignment.centerLeft,
                //              padding: EdgeInsets.all(16.0),
                //              padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                //              color: Colors.white,
                child: RadioListTile(
                    title: Text(
                      '2×2',
                      style: TextStyle(fontSize: 20),
                    ),
                    //                subtitle: Text(""),
                    value: GridSize.grid2x2,
                    groupValue: _radVal,
                    tileColor: Colors.white,
                    //                  overlayColor: Color.fromARGB(0xFF, 0xDC, 0xDC, 0xDC),
                    //                  overlayColor: MaterialStatePropertyAll(
                    //                      Color.fromARGB(0xFF, 0xDC, 0xDC, 0xDC)),
                    //                  overlayColor: MaterialStateProperty.all(
                    //                      Color.fromARGB(0xFF, 0xFF, 0x00, 0x00)),
                    //                  selected: true,
                    //                  selectedTileColor:
                    //                      const Color.fromARGB(0xFF, 0xFF, 0x00, 0x00),
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (value) {
                      setState(() {
                        _radVal = value!;
                      });
                    }),
              ),
              //                onChanged: _onChanged),
              Container(
                //              height: 80,
                //              alignment: Alignment.centerLeft,
                //              padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                //              color: Colors.white,
                child: RadioListTile(
                    title: Text(
                      '3×3',
                      style: TextStyle(fontSize: 20),
                    ),
                    value: GridSize.grid3x3,
                    groupValue: _radVal,
                    tileColor: Colors.white,
                    //                  selectedTileColor: Color.fromARGB(0xFF, 0xDC, 0xDC, 0xDC),
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (value) {
                      setState(() {
                        _radVal = value!;
                      });
                    }),
              ),
              //                onChanged: _onChanged),
            ],
          ),
        ),
      ),
    );
  }
}
