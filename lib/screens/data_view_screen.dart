import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataViewScreen extends StatefulWidget {
  @override
  _DataViewScreenState createState() => _DataViewScreenState();
}

class _DataViewScreenState extends State<DataViewScreen> {
  List<List<String>> _dataList = [];
  List<List<String>> _filteredDataList = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? dataList = prefs.getStringList('dataList');
    _dataList = dataList?.map((data) => data.split(','))?.toList() ?? [];
    setState(() {
      _filteredDataList = _dataList;
    });
  }

  void _filterData(String query) {
    setState(() {
      _filteredDataList = _dataList.where((data) => data[0].contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Data'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                _filterData(value);
              },
              decoration: InputDecoration(
                labelText: 'Cari Sesuai NIK',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _filteredDataList.isEmpty
                ? Center(child: Text('No data'))
                : ListView.separated(
                    itemCount: _filteredDataList.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      List<String> data = _filteredDataList[index];
                      return _buildDataCard(data, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(List<String> data, int index) {
    return Card(
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _buildDataDialog(data);
            },
          );
        },
        title: Text('NIK: ${data[0]}'),
        subtitle: Text('Nama: ${data[1]}'),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            _showDeleteConfirmationDialog(index);
          },
        ),
      ),
    );
  }

  Widget _buildDataDialog(List<String> data) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Lengkap',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            for (int i = 0; i < data.length; i++)
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${_getFieldName(i)}:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      flex: 2,
                      child: Text(
                        data[i],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Data'),
          content: Text('anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteData(index);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteData(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dataList.removeAt(index);
    List<String> newDataList = _dataList.map((data) => data.join(',')).toList();
    await prefs.setStringList('dataList', newDataList);
    setState(() {
      _filteredDataList = _dataList;
    });
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