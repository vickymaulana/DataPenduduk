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
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  List<String> data = snapshot.data![index];
                  return ListTile(
                    title: Text('NIK: ${data[0]}, Nama: ${data[1]}'), // Displaying NIK and Nama
                    subtitle: Text('Data Lengkap: ${data.join(', ')}'), // Displaying all data
                  );
                },
              );
          }
        },
      ),
    );
  }
}