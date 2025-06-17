# 📚 Book Reader App – Flutter

Aplicativo mobile desenvolvido com **Flutter** para leitura de livros digitais.  
Este projeto foi criado como parte da disciplina **Programação Mobile I** do curso de Engenharia de Software no Centro Universitário Católica do Tocantins.

---

## Funcionalidades

- 📖 Leitura de livros com interface amigável
- 🔍 Busca por título
- ❤️ Adicionar livros aos favoritos
- 🧾 Tela de detalhes com título, autor e descrição
- 🔁 Navegação entre múltiplas telas com rotas nomeadas

---

## Tecnologias Utilizadas

- **Flutter** (Dart)
- Navegação com **Named Routes**
- Widgets personalizados (`BookCard`)
- Estado controlado com `setState`
- Estrutura modular com boas práticas de código

---

## 📁 Estrutura de Pastas

```bash
/lib
 ├── main.dart                   # Ponto de entrada da aplicação
 ├── models/
 │   └── book.dart               # Modelo da entidade Livro
 ├── services/
 │   ├── book_service.dart       # Simula listagem de livros
 │   └── favorite_service.dart   # Controle de favoritos
 ├── screens/
 │   ├── home_screen.dart
 │   ├── search_screen.dart
 │   ├── book_details_screen.dart
 │   ├── book_reader_screen.dart
 │   └── favorites_screen.dart
 └── widgets/
     └── book_card.dart        
````
##  Como Executar o Projeto

1. Clone este repositório:

   ```bash
   git clone https://github.com/seu-usuario/book-reader-app.git
   ```

2. Navegue até o diretório do projeto:

   ```bash
   cd book-reader-app
   ```

3. Instale as dependências:

   ```bash
   flutter pub get
   ```

4. Execute o app em um emulador ou dispositivo:

   ```bash
   flutter run
   ```
