import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guardian_app/data/models/bill.dart';
import 'package:guardian_app/data/models/mode_of_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillProvider with ChangeNotifier {
  List<Bill> _bills = [];
  List<Bill> get bills => _bills;
  List<Bill> _selectedBills = [];
  List<Bill> get selectedBills => _selectedBills;

  List<ModeOfPayment> _modeOfPayments = [];
  List<ModeOfPayment> get modeOfPayments => _modeOfPayments;

  ModeOfPayment? _selectedModeOfPayment;
  ModeOfPayment? get selectedModeOfPayment => _selectedModeOfPayment;

  BillProvider() {
    loadBill();
    loadSelectedBill();
  }

  Future<void> saveBill(List<Bill> bills) async {
    _bills = bills;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_bills.map((e) => e.toJson()).toList());
    await prefs.setString('bills', jsonString);

    notifyListeners();
  }

  Future<void> loadBill() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('bills');

    if (jsonString != null) {
      final List<dynamic> jsonData = jsonDecode(jsonString);
      _bills = jsonData.map((e) => Bill.fromJson(e)).toList();
    }

    notifyListeners();
  }

  Future<void> saveSelectedBill(List<Bill> selected) async {
    _selectedBills = selected;

    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(_selectedBills.map((e) => e.toJson()).toList());
    await prefs.setString('selected_bills', jsonString);

    notifyListeners();
  }

  Future<void> loadSelectedBill() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('selected_bills');

    if (jsonString != null) {
      final List<dynamic> jsonData = jsonDecode(jsonString);
      _selectedBills = jsonData.map((e) => Bill.fromJson(e)).toList();
    }

    notifyListeners();
  }

  Future<void> resetSelectedBills() async {
    _selectedBills = [];

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_bills'); // hapus dari storage

    notifyListeners();
  }

  Future<void> saveModeOfPayment(List<ModeOfPayment> method) async {
    _modeOfPayments = method;

    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(_modeOfPayments.map((e) => e.toJson()).toList());
    await prefs.setString('mode_of_payment', jsonString);

    notifyListeners();
  }

  Future<void> loadModeOfPayment() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('mode_of_payment');

    if (jsonString != null) {
      final List<dynamic> jsonData = jsonDecode(jsonString);
      _modeOfPayments = jsonData.map((e) => ModeOfPayment.fromJson(e)).toList();
    }

    notifyListeners();
  }

  void setSelectedModeOfPayment(ModeOfPayment modePayment) async {
    _selectedModeOfPayment = modePayment;
    notifyListeners();
  }
}
