import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveData() async {
    if (!_validateFields()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Semua field harus diisi'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

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

  bool _validateFields() {
    return _nikController.text.isNotEmpty &&
        _namaController.text.isNotEmpty &&
        _tanggalLahirController.text.isNotEmpty &&
        _jenisKelaminController.text.isNotEmpty &&
        _golonganDarahController.text.isNotEmpty &&
        _alamatController.text.isNotEmpty &&
        _agamaController.text.isNotEmpty &&
        _statusPerkawinanController.text.isNotEmpty &&
        _pekerjaanController.text.isNotEmpty &&
        _kewarganegaraanController.text.isNotEmpty &&
        _berlakuHinggaController.text.isNotEmpty;
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
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildTextField(_nikController, 'NIK', TextInputType.number, [FilteringTextInputFormatter.digitsOnly]),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildTextField(_namaController, 'Nama'),
            ),
            GestureDetector(
              onTap: () => _selectDate(context, _tanggalLahirController),
              child: AbsorbPointer(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: _buildTextField(_tanggalLahirController, 'Tanggal Lahir'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildDropdownButtonFormField(
                _jenisKelaminController,
                'Jenis Kelamin',
                ['Laki-laki', 'Perempuan'],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildTextField(_golonganDarahController, 'Golongan Darah'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildTextField(_alamatController, 'Alamat'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildTextField(_agamaController, 'Agama'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildDropdownButtonFormField(
                _statusPerkawinanController,
                'Status Perkawinan',
                ['Kawin', 'Belum Kawin'],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildTextField(_pekerjaanController, 'Pekerjaan'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildTextField(_kewarganegaraanController, 'Kewarganegaraan'),
            ),
            GestureDetector(
              onTap: () => _selectDate(context, _berlakuHinggaController),
              child: AbsorbPointer(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: _buildTextField(_berlakuHinggaController, 'Berlaku Hingga'),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Simpan'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, [TextInputType? keyboardType, List<TextInputFormatter>? inputFormatters]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
    );
  }

  Widget _buildDropdownButtonFormField(TextEditingController controller, String labelText, List<String> items) {
    return DropdownButtonFormField<String>(
      value: controller.text,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          controller.text = value!;
        });
      },
    );
  }
}
