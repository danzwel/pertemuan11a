import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'note.dart';
import 'note_db.dart';
import 'note_form_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final rows = await NoteDb.instance.queryAll();
    _notes = rows.map((e) => Note.fromMap(e)).toList();
    setState(() => _loading = false);
  }

  Future<void> _openCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NoteFormPage()),
    );
    await _load();
  }

  Future<void> _openEdit(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteFormPage(note: note)),
    );
    await _load();
  }

  Future<void> _delete(int id) async {
    await NoteDb.instance.delete(id);
    await _load();
  }

  Color noteColorByDeadline(DateTime? deadline) {
    if (deadline == null) return Colors.grey[200]!;
    final now = DateTime.now();
    final difference = deadline.difference(now);
    
    if (difference.inDays < 0) return Colors.red[100]!; // Overdue
    if (difference.inDays == 0) return Colors.orange[100]!; // Today
    if (difference.inDays <= 2) return Colors.yellow[100]!; // Within 2 days
    return Colors.green[100]!; // More than 2 days
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreate,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: _notes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  final color = noteColorByDeadline(note.deadline);
                  final deadlineText = note.deadline == null
                      ? 'Non-priority'
                      : DateFormat('dd MMM yyyy').format(note.deadline!);
                  
                  return Dismissible(
                    key: ValueKey(note.id),
                    direction: DismissDirection.up,
                    onDismissed: (_) {
                      if (note.id != null) _delete(note.id!);
                    },
                    child: InkWell(
                      onTap: () => _openEdit(note),
                      borderRadius: BorderRadius.circular(16),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: color,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Text(
                                  note.content,
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                deadlineText,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}