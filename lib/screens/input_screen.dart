import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart'; 

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

  List<String> _countries = [];

  Future<void> _fetchCountries() async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _countries = data.map((country) => country['name']['common']).toList().cast<String>();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

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

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      controller.text = formattedDate;
    }
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
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            GestureDetector(
              onTap: () => _selectDate(context, _tanggalLahirController),
              child: AbsorbPointer(
                child: TextField(
                  controller: _tanggalLahirController,
                  decoration: InputDecoration(labelText: 'Tanggal Lahir'),
                ),
              ),
            ),
            DropdownButtonFormField<String>(
              value: _jenisKelaminController.text,
              decoration: InputDecoration(labelText: 'Jenis Kelamin'),
              items: [
                DropdownMenuItem(
                  value: 'Laki-laki',
                  child: Text('Laki-laki'),
                ),
                DropdownMenuItem(
                  value: 'Perempuan',
                  child: Text('Perempuan'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _jenisKelaminController.text = value!;
                });
              },
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
            DropdownButtonFormField<String>(
              value: _statusPerkawinanController.text,
              decoration: InputDecoration(labelText: 'Status Perkawinan'),
              items: [
                DropdownMenuItem(
                  value: 'Kawin',
                  child: Text('Kawin'),
                ),
                DropdownMenuItem(
                  value: 'Belum Kawin',
                  child: Text('Belum Kawin'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _statusPerkawinanController.text = value!;
                });
              },
            ),
            TextField(
              controller: _pekerjaanController,
              decoration: InputDecoration(labelText: 'Pekerjaan'),
            ),
            DropdownButtonFormField<String>(
              value: _kewarganegaraanController.text,
              decoration: InputDecoration(labelText: 'Kewarganegaraan'),
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _kewarganegaraanController.text = value!;
                });
              },
            ),
            GestureDetector(
              onTap: () => _selectDate(context, _berlakuHinggaController),
              child: AbsorbPointer(
                child: TextField(
                  controller: _berlakuHinggaController,
                  decoration: InputDecoration(labelText: 'Berlaku Hingga'),
                ),
              ),
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
