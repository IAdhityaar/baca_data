import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Mhs>> fetchMhss(http.Client client) async {
  final response =
      await client.get('https://iadhityaranius.000webhostapp.com/readDatajson.php');

  // Use the compute function to run parseMhss in a separate isolate.
  return compute(parseMhss, response.body);
}

// A function that converts a response body into a List<Mhs>.
List<Mhs> parseMhss(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Mhs>((json) => Mhs.fromJson(json)).toList();
}

class Mhs {
  final String nim;
  final String nama;
  final String kelas;
  final String kdmatkul;
  final String email;

  Mhs({this.nim, this.nama, this.kelas, this.kdmatkul, this.email});

  factory Mhs.fromJson(Map<String, dynamic> json) {
    return Mhs(
      nim: json['nim'] as String,
      nama: json['nama'] as String,
      kelas: json['kelas'] as String,
      kdmatkul: json['kdmatkul'] as String,
      email: json['email'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Sistem Absensi MHS';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Mhs>>(
        future: fetchMhss(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? MhssList(MhsData: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MhssList extends StatelessWidget {
  final List<Mhs> MhsData;

  MhssList({Key key, this.MhsData}) : super(key: key);



Widget viewData(var data,int index)
{
return Container(
    width: 200,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.green,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            //ClipRRect(
              //      borderRadius: BorderRadius.only(
                //      topLeft: Radius.circular(8.0),
                  //    topRight: Radius.circular(8.0),
                   // ),
                   // child: Image.network(
                    //    "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png"
                    //    width: 100,
                     //   height: 50,
                        //fit:BoxFit.fill

                   // ),
                 // ),
            
          ListTile(
           //leading: Image.network(
             //   "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png",
             // ),
            title: Text(data[index].nim, style: TextStyle(color: Colors.white)),
            subtitle: Text(data[index].nama, style: TextStyle(color: Colors.white)),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                      //util.showLoading(context, true);
                            _showEditDialog(_r);
                  },
                ),
               ),
              ),
                ),
                  SizedBox(
                    width: 5,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Center(
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.red,
                          shape: CircleBorder(),
                        ),
                FlatButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                      String nim = Mhs["nim"].toString();
                            Map<String, String> mRequest = {
                              "nama": "",
                              "kelas": "",
                              "cmd": "delete_data_by_nim",
                              "nim": nim
                            };
                            util.showAlert(context, "Are you sure ?", "Delete Data, nim = ($nim)").then((b){
                              if (b == true){
                                util.showLoading(context, true);
                                util.httpPost(util.url_api, mRequest).then((data){
                                  //print(data);
                                  var jObject = json.decode(data);
                                  if (jObject != null){
                                    String v_desc = jObject["desc"];
                                    _statusText = v_desc;
                  },
                  _loadData(_txtSearch.text).then((d){
                                    util.showLoading(context, false);
                                    setState(() {

                                    });
                                  });

                                });
                              }
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ));
    }
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: MhsData.length,
      itemBuilder: (context, index) {
        return viewData(MhsData,index);
      },
    );
  }
}