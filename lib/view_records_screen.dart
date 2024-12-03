import 'package:flutter/material.dart';
import 'database/database_helper.dart';

class ViewRecordsScreen extends StatefulWidget {
  @override
  _ViewRecordsScreenState createState() => _ViewRecordsScreenState();
}

class _ViewRecordsScreenState extends State<ViewRecordsScreen> {
  late Future<List<Map<String, dynamic>>> records;

  @override
  void initState() {
    super.initState();
    records = DatabaseHelper().getAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Таблица Одногруппников')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: records,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Нет записей в базе данных.'));
          }

          var students = snapshot.data!;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              var student = students[index];
              return ListTile(
                title: Text(student['fio']),
                subtitle: Text('ID: ${student['id']} - Время: ${student['time_added']}'),
              );
            },
          );
        },
      ),
    );
  }
}
