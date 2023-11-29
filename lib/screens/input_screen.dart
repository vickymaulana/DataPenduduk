import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  TextEditingController _nikController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _tanggalLahirController = TextEditingController();
  TextEditingController _jenisKelaminController = TextEditingController();
  TextEditingController _golonganDarahController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _agamaController = TextEditingController();
  TextEditingController _statusPerkawinanController = TextEditingController();
  TextEditingController _pekerjaanController = TextEditingController();
  TextEditingController _kewarganegaraanController = TextEditingController();
  TextEditingController _berlakuHinggaController = TextEditingController();

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> data = [
      _nikController.text,
      _namaController.text,
      _tanggalLahirController.text,
      _jenisKelaminController.text,
      _golonganDarahController.text,
      _alamatController.text,
      _agamaController.text,
      _statusPerkawinanController.text,
      _pekerjaanController.text,
      _kewarganegaraanController.text,
      _berlakuHinggaController.text,
    ];
    List<String>? dataList = prefs.getStringList('dataList');
    if (dataList != null) {
      dataList.add(data.join(','));
    } else {
      dataList = [data.join(',')];
    }
    await prefs.setStringList('dataList', dataList);
    _clearFields();
  }

  void _clearFields() {
    _nikController.clear();
    _namaController.clear();
    _tanggalLahirController.clear();
    _jenisKelaminController.clear();
    _golonganDarahController.clear();
    _alamatController.clear();
    _agamaController.clear();
    _statusPerkawinanController.clear();
    _pekerjaanController.clear();
    _kewarganegaraanController.clear();
    _berlakuHinggaController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Data'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nikController,
              decoration: InputDecoration(labelText: 'NIK'),
            ),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _tanggalLahirController,
              decoration: InputDecoration(labelText: 'Tanggal Lahir'),
            ),
            TextField(
              controller: _jenisKelaminController,
              decoration: InputDecoration(labelText: 'Jenis Kelamin'),
            ),
            TextField(
              controller: _golonganDarahController,
              decoration: InputDecoration(labelText: 'Golongan Darah'),
            ),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              controller: _agamaController,
              decoration: InputDecoration(labelText: 'Agama'),
            ),
            TextField(
              controller: _statusPerkawinanController,
              decoration: InputDecoration(labelText: 'Status Perkawinan'),
            ),
            TextField(
              controller: _pekerjaanController,
              decoration: InputDecoration(labelText: 'Pekerjaan'),
            ),
            TextField(
              controller: _kewarganegaraanController,
              decoration: InputDecoration(labelText: 'Kewarganegaraan'),
            ),
            TextField(
              controller: _berlakuHinggaController,
              decoration: InputDecoration(labelText: 'Berlaku Hingga'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
