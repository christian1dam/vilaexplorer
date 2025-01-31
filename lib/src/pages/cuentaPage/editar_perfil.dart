import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/service/usuario_service.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/src/widgets/footer.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  _EditarPerfilPageState createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _passwordActual = '';
  String _nuevoPassword = '';
  String _confirmarPassword = '';
  String _password = '';
  bool _isEditingName = true;

  @override
  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioService>(context);
    _nombre = usuarioService.allUserData.nombre!;
    _password = usuarioService.allUserData.password!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 29, 29, 1),
        title: Text(
          AppLocalizations.of(context)!.translate('edit_profile'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(32, 29, 29, 1),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () => setState(() => _isEditingName = true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isEditingName ? Colors.green : Colors.grey,
                            ),
                            child: Text(AppLocalizations.of(context)!.translate('change_name')),
                          ),
                          ElevatedButton(
                            onPressed: () => setState(() => _isEditingName = false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !_isEditingName ? Colors.green : Colors.grey,
                            ),
                            child: Text(AppLocalizations.of(context)!.translate('change_password')),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      if (_isEditingName) ...[
                        Text(
                          '${AppLocalizations.of(context)!.translate('name')}:',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          initialValue: _nombre,
                          decoration: const InputDecoration(
                            hintText: 'Introduce tu nombre',
                            hintStyle: TextStyle(color: Colors.white54),
                            fillColor: Color.fromARGB(255, 47, 42, 42),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa un nombre';
                            }
                            return null;
                          },
                          onChanged: (value) => _nombre = value,
                        ),
                        const SizedBox(height: 20),

                        Text(
                          '${AppLocalizations.of(context)!.translate('current_password')}:',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Introduce tu contraseña actual',
                            hintStyle: TextStyle(color: Colors.white54),
                            fillColor: Color.fromARGB(255, 47, 42, 42),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa la contraseña actual';
                            }
                            return null;
                          },
                          onChanged: (value) => _passwordActual = value,
                        ),
                      ] else ...[
                        Text(
                          '${AppLocalizations.of(context)!.translate('current_password')}:',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Introduce tu contraseña actual',
                            hintStyle: TextStyle(color: Colors.white54),
                            fillColor: Color.fromARGB(255, 47, 42, 42),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa la contraseña actual';
                            }
                            return null;
                          },
                          onChanged: (value) => _passwordActual = value,
                        ),
                        const SizedBox(height: 20),

                        Text(
                          '${AppLocalizations.of(context)!.translate('new_password')}:',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Introduce nueva contraseña',
                            hintStyle: TextStyle(color: Colors.white54),
                            fillColor: Color.fromARGB(255, 47, 42, 42),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) => _nuevoPassword = value,
                        ),
                        const SizedBox(height: 20),

                        Text(
                          '${AppLocalizations.of(context)!.translate('confirm_password')}:',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Confirma nueva contraseña',
                            hintStyle: TextStyle(color: Colors.white54),
                            fillColor: Color.fromARGB(255, 47, 42, 42),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (_nuevoPassword.isNotEmpty && value != _nuevoPassword) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                          onChanged: (value) => _confirmarPassword = value,
                        ),
                      ],

                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              bool actualizado = false;
                              if (_isEditingName) {
                                actualizado = await usuarioService.editarNombreUsuario(_nombre);
                              } else {
                                actualizado = await usuarioService.editarContrasenyaUsuario(_nuevoPassword, _passwordActual);
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(actualizado
                                      ? AppLocalizations.of(context)!.translate('profile_updated')
                                      : AppLocalizations.of(context)!.translate('profile_update_failed')),
                                ),
                              );
                              if (actualizado) Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.translate('save_changes'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
