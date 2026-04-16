import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    Stream<String> getLoadingMessages() {
      final messages = <String>['Cargando...', 'Buscando en la base de datos...', 'Preparando la información...', 'Casi listo...', 'Obteniendo los datos...'];

      return Stream.periodic(const Duration(milliseconds: 1200), (step) {
        return messages[step % messages.length];
      }).take(messages.length);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Espere por favor', style: textStyles.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 3),
          const SizedBox(height: 10),

          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();

              final message = snapshot.data!;
              return Text(message, style: textStyles.bodyLarge?.copyWith(fontStyle: FontStyle.italic));
            },
          ),
        ],
      ),
    );
  }
}
