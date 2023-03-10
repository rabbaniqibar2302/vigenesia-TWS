import 'package:url_launcher/url_launcher.dart';
import 'package:vigenesia/Models/Motivasi_Model.dart';
import 'package:vigenesia/Screens/EditPage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'Login.dart';
import 'package:another_flushbar/flushbar.dart';

// final Uri _url = Uri.parse('google.com');

class MainScreens extends StatefulWidget {
  final String? nama;
  final String? idUser;
  const MainScreens({Key? key, this.nama, this.idUser}) : super(key: key);

  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  String baseurl =
      "http://192.168.18.23"; // ganti dengan ip address kamu / tempat kamu menyimpan backend
  String? id;
  var dio = Dio();
  TextEditingController titleController = TextEditingController();

  Future<dynamic> sendMotivasi(String isi) async {
    Map<String, dynamic> body = {"isi_motivasi": isi, "iduser": widget.idUser};

    try {
      Response response =
          await dio.post("$baseurl/vigenesia/api/dev/POSTmotivasi",
              data: body,
              options: Options(headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                "Accept": "application/json"
              }));

      return response;
    } catch (e) {
      print("Error di -> $e");
    }
  }

  List<MotivasiModel> listproduk = [];

  Future<List<MotivasiModel>> getData() async {
    var response = await dio.get('$baseurl/vigenesia/api/Get_motivasi');

    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      setState(() {
        listproduk = listUsers;
      });
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> deletePost(String id) async {
    Map<String, dynamic> data = {
      "id": id,
    };
    var response = await dio.delete('$baseurl/vigenesia/api/dev/DELETEmotivasi',
        data: data,
        options: Options(
            headers: {"Content-Type": "application/x-www-form-urlencoded"}));

    return response.data;
  }

  TextEditingController isiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData().then((value) => {
          setState(() {
            listproduk = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // <-- Berfungsi Untuk  Bisa Scroll
        child: SafeArea(
          // < -- Biar Gak Keluar Area Screen HP
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .center, // <-- Berfungsi untuk  atur nilai X jadi tengah
                children: [
                  const SizedBox(
                    height: 40,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hallo  ${widget.nama}",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                          child: const Icon(Icons.logout),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Login()));
                          })
                    ],
                  ),

                  const SizedBox(height: 20), // <-- Kasih Jarak Tinggi : 50px
                  FormBuilderTextField(
                    controller: isiController,
                    name: "isi_motivasi",
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (isiController.text.isNotEmpty) {
                            await sendMotivasi(isiController.text.toString())
                                .then((value) => {
                                      if (value != null)
                                        {
                                          Flushbar(
                                            message: "Berhasil Submit",
                                            duration:
                                                const Duration(seconds: 2),
                                            backgroundColor: Colors.greenAccent,
                                            flushbarPosition:
                                                FlushbarPosition.TOP,
                                          ).show(context),
                                          getData()
                                        }
                                    });
                          } else {
                            Flushbar(
                              message: "Isi Motivasi Tidak Boleh Kosong",
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.redAccent,
                              flushbarPosition: FlushbarPosition.TOP,
                            ).show(context);
                          }
                        },
                        child: const Text("Submit")),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const ElevatedButton(
                      onPressed: _launchUrl,
                      child: Text('Home'),
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),
                  TextButton(
                    child: const Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                        getData();
                      });
                    },
                  ),

                  ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: listproduk.length,
                      itemBuilder: (context, i) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    listproduk[i].isiMotivasi.toString(),
                                    overflow: TextOverflow.clip,
                                  )),
                              Row(
                                children: [
                                  TextButton(
                                    child: const Icon(Icons.settings),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                EditPage(
                                                    id: listproduk[i].id,
                                                    isi_motivasi: listproduk[i]
                                                        .isiMotivasi),
                                          ));
                                    },
                                  ),
                                  TextButton(
                                    child: const Icon(Icons.delete),
                                    onPressed: () {
                                      deletePost(listproduk[i].id!)
                                          .then((value) => {
                                                if (value != null)
                                                  {
                                                    Flushbar(
                                                      message:
                                                          "Berhasil Delete",
                                                      duration: const Duration(
                                                          seconds: 2),
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      flushbarPosition:
                                                          FlushbarPosition.TOP,
                                                    ).show(context),
                                                    getData()
                                                  }
                                              });
                                    },
                                  )
                                ],
                              )
                            ]);
                      })
                ]),
          ),
        ),
      ),
    );
  }
}

_launchUrl() async {
  const url = 'https://google.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}