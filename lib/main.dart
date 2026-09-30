import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manajemen Data Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const StudentListScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. MODEL DATA MAHASISWA
// -----------------------------------------------------------------------------
class Student {
  String id;
  String nim;
  String name;
  String studyProgram;
  String studentClass;

  Student({
    required this.id,
    required this.nim,
    required this.name,
    required this.studyProgram,
    required this.studentClass,
  });
}

// -----------------------------------------------------------------------------
// 2. HALAMAN DAFTAR MAHASISWA (TAHAP 1-7 + TANTANGAN TAMBAHAN)
// -----------------------------------------------------------------------------
class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  // Data Master Mahasiswa
  final List<Student> _students = [
    Student(
      id: '1',
      nim: '231001',
      name: 'Andi Saputra Sijabat',
      studyProgram: 'Informatika',
      studentClass: 'IF-3A',
    ),
    Student(
      id: '2',
      nim: '231002',
      name: 'Kadek Wijaya Bencong',
      studyProgram: 'Sistem Informasi',
      studentClass: 'SI-3A',
    ),
    Student(
      id: '3',
      nim: '231003',
      name: 'Satria Fu',
      studyProgram: 'Teknik Komputer',
      studentClass: 'TK-3B',
    ),
    Student(
      id: '4',
      nim: '231004',
      name: 'Haikal Akek',
      studyProgram: 'Informatika',
      studentClass: 'IF-3B',
    ),
    Student(
      id: '5',
      nim: '231005',
      name: 'Ikhsan Korul',
      studyProgram: 'Sistem Informasi',
      studentClass: 'SI-3B',
    ),
  ];

  // Controller & Variable Pencarian (Tahap 6)
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // TANTANGAN TAMBAHAN 1: Pilihan Filter Program Studi
  final List<String> _filterProdiList = [
    'Semua',
    'Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
  ];
  String _selectedFilterProdi = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter List Mahasiswa
  List<Student> get _filteredStudents {
    return _students.where((student) {
      // Filter Prodi
      final matchesProdi = (_selectedFilterProdi == 'Semua') ||
          (student.studyProgram.toLowerCase() == _selectedFilterProdi.toLowerCase());

      // Filter Search Keyword
      final query = _searchQuery.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          student.name.toLowerCase().contains(query) ||
          student.nim.toLowerCase().contains(query) ||
          student.studyProgram.toLowerCase().contains(query) ||
          student.studentClass.toLowerCase().contains(query);

      return matchesProdi && matchesQuery;
    }).toList();
  }

  // Tambah Mahasiswa (Tahap 2 & 7)
  void _addStudent(Student student) {
    setState(() {
      _students.add(student);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data "${student.name}" berhasil ditambahkan'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Edit Mahasiswa (Tahap 5 & 7)
  void _editStudent(Student updatedStudent) {
    setState(() {
      final index = _students.indexWhere((s) => s.id == updatedStudent.id);
      if (index != -1) {
        _students[index] = updatedStudent;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data "${updatedStudent.name}" berhasil diperbarui'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Hapus Mahasiswa (Tahap 5 & 7)
  void _deleteStudent(String id, String name) {
    setState(() {
      _students.removeWhere((student) => student.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data "$name" berhasil dihapus'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Dialog Konfirmasi Hapus
  void _confirmDelete(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus "${student.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteStudent(student.id, student.name);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _filteredStudents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // TANTANGAN TAMBAHAN 2: Tampilan Jumlah Mahasiswa
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.indigo.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Mahasiswa: ${_students.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                if (_selectedFilterProdi != 'Semua' || _searchQuery.isNotEmpty)
                  Text(
                    'Terganti/Filter: ${displayList.length}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
              ],
            ),
          ),

          // TAHAP 6: Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari Nama, NIM, Prodi, atau Kelas...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          // TANTANGAN TAMBAHAN 1: Filter ChoiceChip Program Studi
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filterProdiList.length,
              itemBuilder: (context, index) {
                final prodi = _filterProdiList[index];
                final isSelected = _selectedFilterProdi == prodi;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(prodi),
                    selected: isSelected,
                    selectedColor: Colors.indigo,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFilterProdi = prodi;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // TANTANGAN TAMBAHAN 3: Empty State vs ListView
          Expanded(
            child: displayList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _students.isEmpty
                              ? 'Belum ada data mahasiswa'
                              : 'Data mahasiswa tidak ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final student = displayList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentDetailScreen(
                                  student: student,
                                  onDelete: () => _deleteStudent(student.id, student.name),
                                  onEdit: (updatedStudent) => _editStudent(updatedStudent),
                                ),
                              ),
                            );
                            if (result == true) {
                              setState(() {});
                            }
                          },
                          title: Row(
                            children: [
                              Text(
                                student.nim,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  student.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(student.studyProgram),
                                Text(
                                  student.studentClass,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.indigo),
                                onPressed: () async {
                                  final updatedStudent = await Navigator.push<Student>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentFormScreen(student: student),
                                    ),
                                  );
                                  if (updatedStudent != null) {
                                    _editStudent(updatedStudent);
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDelete(context, student),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newStudent = await Navigator.push<Student>(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentFormScreen(),
            ),
          );

          if (newStudent != null) {
            _addStudent(newStudent);
          }
        },
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          '+ Tambah Mahasiswa',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. FORM MAHASISWA (TAMBAH & EDIT DENGAN DROPDOWN)
// -----------------------------------------------------------------------------
class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nimController;
  late TextEditingController _nameController;

  final List<String> _prodiOptions = [
    'Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
  ];

  final List<String> _classOptions = [
    'IF-3A',
    'IF-3B',
    'SI-3A',
    'SI-3B',
    'TK-3A',
    'TK-3B',
  ];

  String? _selectedProdi;
  String? _selectedClass;

  @override
  void initState() {
    super.initState();
    _nimController = TextEditingController(text: widget.student?.nim ?? '');
    _nameController = TextEditingController(text: widget.student?.name ?? '');

    if (widget.student != null) {
      if (_prodiOptions.contains(widget.student!.studyProgram)) {
        _selectedProdi = widget.student!.studyProgram;
      }
      if (_classOptions.contains(widget.student!.studentClass)) {
        _selectedClass = widget.student!.studentClass;
      }
    }
  }

  @override
  void dispose() {
    _nimController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        id: widget.student?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nim: _nimController.text.trim(),
        name: _nameController.text.trim(),
        studyProgram: _selectedProdi ?? '',
        studentClass: _selectedClass ?? '',
      );

      Navigator.of(context).pop(student);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.student != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Data Mahasiswa' : 'Form Tambah Mahasiswa'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NIM wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedProdi,
                decoration: const InputDecoration(
                  labelText: 'Program Studi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                items: _prodiOptions.map((String prodi) {
                  return DropdownMenuItem<String>(
                    value: prodi,
                    child: Text(prodi),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedProdi = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih Program Studi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedClass,
                decoration: const InputDecoration(
                  labelText: 'Kelas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.class_),
                ),
                items: _classOptions.map((String kelas) {
                  return DropdownMenuItem<String>(
                    value: kelas,
                    child: Text(kelas),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedClass = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih Kelas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isEditing ? 'Perbarui' : 'Simpan',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. HALAMAN DETAIL MAHASISWA
// -----------------------------------------------------------------------------
class StudentDetailScreen extends StatefulWidget {
  final Student student;
  final Function() onDelete;
  final Function(Student) onEdit;

  const StudentDetailScreen({
    super.key,
    required this.student,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  late Student _currentStudent;

  @override
  void initState() {
    super.initState();
    _currentStudent = widget.student;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus "${_currentStudent.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onDelete();
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mahasiswa'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedStudent = await Navigator.push<Student>(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentFormScreen(student: _currentStudent),
                ),
              );
              if (updatedStudent != null) {
                setState(() {
                  _currentStudent = updatedStudent;
                });
                widget.onEdit(updatedStudent);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.indigo.shade100,
                child: Text(
                  _currentStudent.name.isNotEmpty
                      ? _currentStudent.name[0].toUpperCase()
                      : 'M',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _currentStudent.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _currentStudent.nim,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailItem(
                      icon: Icons.school,
                      title: 'Program Studi',
                      value: _currentStudent.studyProgram,
                    ),
                    const Divider(height: 24),
                    _buildDetailItem(
                      icon: Icons.class_,
                      title: 'Kelas',
                      value: _currentStudent.studentClass,
                    ),
                    const Divider(height: 24),
                    _buildDetailItem(
                      icon: Icons.badge,
                      title: 'NIM',
                      value: _currentStudent.nim,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}