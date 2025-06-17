import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart'; 

class BookReaderScreen extends StatefulWidget {
  final String previewUrl;
  final String bookTitle;

  const BookReaderScreen({
    super.key,
    required this.previewUrl,
    required this.bookTitle,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  String _statusMessage = 'Abrindo prévia no navegador...';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _openInExternalBrowser(); 
  }

  
  Future<void> _openInExternalBrowser() async {
    setState(() {
      _statusMessage = 'Abrindo prévia no navegador...';
      _hasError = false;
    });

    final uri = Uri.parse(widget.previewUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        ); 
        if (mounted) {
          setState(() {
            _statusMessage = 'Prévia aberta no seu navegador.';
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _hasError = true;
            _statusMessage =
                'Não foi possível abrir a prévia no navegador. A URL pode estar inválida ou o navegador não responde.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _statusMessage =
              'Erro inesperado ao tentar abrir a prévia: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.bookTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed:
                _openInExternalBrowser,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _hasError
                  ? const Icon(Icons.error_outline, size: 64, color: Colors.red)
                  : const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: _hasError ? Colors.red : null,
                ),
              ),
              if (_hasError) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                  onPressed: _openInExternalBrowser,
                ),
              ],
              const SizedBox(height: 24),
              TextButton.icon(
                icon: const Icon(Icons.info_outline),
                label: const Text(
                  'As prévias do Google Books são otimizadas para abrir em navegadores. Se não abrir automaticamente, clique em mim',
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.previewUrl));
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Link copiado!'),
                      content: const Text(
                        'O link da prévia foi copiado para a área de transferência.\nCole no navegador caso não tenha aberto automaticamente.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
