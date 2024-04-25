import 'package:flutter/material.dart';
import 'package:flutter_sqlite2/database/bd.dart';


class Principal extends StatelessWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  List<Map<String, dynamic>> _lista = [];

  bool _isLoading = true;

  void _refreshTutorial() async {
    final data = await SqlDb.buscarTodos();
    setState(() {
      _lista = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTutorial();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descrptionController = TextEditingController();


  void _showForm(int? id) async {
    if (id != null) {
      final existingTutorial =
      _lista.firstWhere((element) => element['id'] == id);
      _titleController.text = existingTutorial ['title'];
      _descrptionController.text = existingTutorial ['descrption'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        backgroundColor: Colors.white70,
        builder: (_) =>
            Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,

                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descrptionController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _addItem();
                      }
                      if (id != null) {
                        await _updateItem(id);
                      }
                      _titleController.text = '';
                      _descrptionController.text = '';

                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Novo' : 'Alterar'),
                  )
                ],
              ),
            ));
  }
}
