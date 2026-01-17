import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/note_form_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'NoteFormPage shows validation errors when fields are empty',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NoteFormPage(),
        ),
      );

      // Tap tombol "Simpan" tanpa isi apapun
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      // Validasi dari kode
      expect(find.text('Judul wajib'), findsOneWidget);
      expect(find.text('Isi wajib'), findsOneWidget);
    },
  );
}
