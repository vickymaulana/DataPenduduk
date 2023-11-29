import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataViewScreen extends StatefulWidget {
  @override
  _DataViewScreenState createState() => _DataViewScreenState();
}

class _DataViewScreenState extends State<DataViewScreen> {
  Future<List<List<String>>> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? dataList = prefs.getStringList('dataList');
    return dataList?.map((data) => data.split(','))?.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Data'),
      ),
      body: FutureBuilder<List<List<String>>>(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot<List<List<String>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                List<String> data = snapshot.data![index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Data Lengkap'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int i = 0; i < data.length; i++)
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    margin: EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(
                                      '${_getFieldName(i)}: ${data[i]}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    title: Text('NIK: ${data[0]}'),
                    subtitle: Text('Nama: ${data[1]}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  String _getFieldName(int index) {
    switch (index) {
      case 0:
        return 'NIK';
      case 1:
        return 'Nama';
      case 2:
        return 'Tanggal Lahir';
      case 3:
        return 'Jenis Kelamin';
      case 4:
        return 'Golongan Darah';
      case 5:
        return 'Alamat';
      case 6:
        return 'Agama';
      case 7:
        return 'Status Perkawinan';
      case 8:
        return 'Pekerjaan';
      case 9:
        return 'Kewarganegaraan';
      case 10:
        return 'Berlaku Hingga';
      default:
        return '';
    }
  }
}