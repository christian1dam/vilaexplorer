import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';
import 'package:vilaexplorer/providers/edit_profile_provider.dart';
import 'package:vilaexplorer/service/usuario_service.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/src/widgets/footer.dart';

class EditarPerfilPage extends StatelessWidget {
  const EditarPerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioService = UsuarioService();
    final formProvider = Provider.of<EditProfileFormProvider>(context, listen: true); // PARA REPINTAR EL WIDGET DEBE ESTAR CONFIGURADO COMO TRUE

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
        title: Text(
          AppLocalizations.of(context)!.translate('edit_profile'),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      
      body: Container(
        color: const Color.fromARGB(255, 24, 24, 24),
        padding: EdgeInsets.symmetric(horizontal:16.w, vertical:16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formProvider.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () => formProvider.isEditingName = true,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: formProvider.isEditingName ? Colors.green : Colors.grey,
                              foregroundColor: Colors.white
                            ),
                            child: Text(AppLocalizations.of(context)!.translate('change_name')),
                          ),
                          ElevatedButton(
                            onPressed: () => formProvider.isEditingName = false,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: formProvider.isEditingName ? Colors.grey : Colors.green,
                              foregroundColor: Colors.white
                            ),
                            child: Text(AppLocalizations.of(context)!.translate('change_password')),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      if (formProvider.isEditingName) ...[
                        Text(
                          AppLocalizations.of(context)!.translate('name'),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        TextFormField(
                          initialValue: formProvider.username,
                          decoration: InputDecoration(
                            hintText: 'Introduce tu nombre',
                            hintStyle: TextStyle(color: Colors.white54),
                            fillColor: Color.fromARGB(255, 47, 42, 42),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.r)),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa un nombre';
                            }
                            return null;
                          },
                          onChanged: (value) => formProvider.username = value,
                        ),

                        SizedBox(height: 20.h),

                        Text(
                          AppLocalizations.of(context)!.translate('current_password'),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 5.h),


                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Introduce tu contraseña',
                            hintStyle: TextStyle(color: Color.fromARGB(161, 255, 255, 255)),
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
                          onChanged: (value) => formProvider.currentPassword = value,
                        ),
                      ] 
                      
                      else ...[
                        Text(
                          AppLocalizations.of(context)!.translate('current_password'),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Introduce tu contraseña actual',
                            hintStyle: TextStyle(color: Color.fromARGB(161, 255, 255, 255)),
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
                          onChanged: (value) => formProvider.currentPassword = value,
                        ),

                        SizedBox(height: 20.h),

                        Text(
                          '${AppLocalizations.of(context)!.translate('new_password')}:',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 5.h),
                        
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
                          style: TextStyle(color: Colors.white),
                          onChanged: (value) => formProvider.newPassword = value,
                        ),
                        SizedBox(height: 20.h),

                        Text(
                          AppLocalizations.of(context)!.translate('confirm_password'),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 5.h),

                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirma nueva contraseña',
                            hintStyle: TextStyle(color: Colors.white54),
                            fillColor: Color.fromARGB(255, 47, 42, 42),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.r)),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (  formProvider.newPassword.isNotEmpty &&  value != formProvider.newPassword) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                          onChanged: (value) => formProvider.newPassword = value,
                        ),
                      ],

                      SizedBox(height: 20.h),

                      Center(
                        child: ElevatedButton(
                          onPressed: () async {

                            if (formProvider.isValidForm()) {
                              formProvider.didUpdate = false;
                              
                              if (formProvider.isEditingName && await usuarioService.validatePassword(formProvider.currentPassword)) {
                                debugPrint("SE HA ENTRADO A ACTUALIZAR NOMBRE PUT");
                                debugPrint("NOMBRE: ${formProvider.username}");
                                formProvider.didUpdate = await usuarioService.actualizarUsuario(Usuario(nombre: formProvider.username));
                              } 
                              else if(await usuarioService.validatePassword(formProvider.currentPassword)){
                                debugPrint("ENTRA EN EL SEGUNDO IF !!!!!!!");
                                formProvider.didUpdate = await usuarioService.actualizarUsuario(Usuario(password: formProvider.newPassword));
                              }
                              


                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text( formProvider.didUpdate
                                      ? AppLocalizations.of(context)!.translate('profile_updated')
                                      : AppLocalizations.of(context)!.translate('profile_update_failed'),),
                                ),
                              );
                              if (formProvider.didUpdate) Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 40.w),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
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
