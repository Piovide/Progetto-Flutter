import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:wiki_appunti/utilz/Utilz.dart';
import 'package:wiki_appunti/utilz/WebUtilz.dart';

class Notespage extends StatefulWidget {
  final Map<String, dynamic> data;
  const Notespage({super.key, this.data = const {}});
  @override
  State<Notespage> createState() => _NotesState();
}

class _NotesState extends State<Notespage> with SingleTickerProviderStateMixin {
  late final TextEditingController _contentController;
  late final TextEditingController _titleController;
  late TabController _tabController;
  final ScrollController _editorScrollController = ScrollController();
  final ScrollController _previewScrollController = ScrollController();
  bool _isEditingTitle = false;

  bool showEditor = false;

  Future<void> checkEditorPermission() async {
    final autoreUuid = widget.data['autore_uuid'];
    final loginUuid = await getUUID();
    setState(() {
      showEditor = autoreUuid != null && autoreUuid == loginUuid;
    });
  }

  @override
  void initState() {
    super.initState();
    checkEditorPermission();
    final titolo =
        widget.data.containsKey('titolo') && widget.data['titolo'] != null
            ? widget.data['titolo']
            : 'Nuovo Appunto';
    _titleController = TextEditingController(text: titolo);
    _titleController.addListener(() {
      setState(() {});
    });
    final contenuto =
        widget.data.containsKey('contenuto') && widget.data['contenuto'] != null
            ? widget.data['contenuto']
            : '';
    _contentController = TextEditingController(text: contenuto);
    _contentController.addListener(() {
      setState(() {});
    });
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    _tabController.dispose();
    _editorScrollController.dispose();
    _previewScrollController.dispose();
    super.dispose();
  }

  void insertText(String left, [String right = '']) {
    final title = _titleController.text;
    final text = _contentController.text;
    final selection = _contentController.selection;
    final newText = text.replaceRange(selection.start, selection.end,
        '$left${text.substring(selection.start, selection.end)}$right');
    final cursorPosition = selection.start + left.length;

    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
          offset: cursorPosition + (selection.end - selection.start)),
    );
  }

  Widget buildGroupedButton({
    required Icon mainIcon,
    required VoidCallback onMainPressed,
    required List<Map<String, dynamic>> options,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: mainIcon,
          onPressed: onMainPressed,
          tooltip: options.first['label'],
        ),
        PopupMenuButton<Map<String, dynamic>>(
          icon: const Icon(Icons.arrow_drop_down),
          tooltip: 'More Options',
          onSelected: (option) =>
              insertText(option['left'], option['right'] ?? ''),
          itemBuilder: (context) => options
              .sublist(1) // Esclude la prima che è già il bottone principale
              .map((option) => PopupMenuItem<Map<String, dynamic>>(
                    value: option,
                    child: Row(
                      children: [
                        if (option['icon'] != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              option['icon'] is IconData
                                  ? option['icon']
                                  : Icons.code, // fallback
                              size: 20,
                            ),
                          ),
                        Text(option['label']),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget buildMarkdownToolbar() {
    return Wrap(
      spacing: 8,
      children: [
        IconButton(
          icon: const Icon(Icons.format_bold),
          onPressed: () => insertText('**', '**'),
          tooltip: 'Bold',
        ),
        IconButton(
          icon: const Icon(Icons.format_italic),
          onPressed: () => insertText('_', '_'),
          tooltip: 'Italic',
        ),
        IconButton(
          icon: const Icon(Icons.link),
          onPressed: () => insertText('[', '](url)'),
          tooltip: 'Link',
        ),
        IconButton(
          icon: const Icon(Icons.title),
          onPressed: () => insertText('# '),
          tooltip: 'Header',
        ),
        buildGroupedButton(
          mainIcon: const Icon(Icons.format_list_bulleted),
          onMainPressed: () => insertText('* '),
          options: [
            {
              'label': 'Bullet List',
              'icon': Icons.format_list_bulleted,
              'left': '* '
            },
            {
              'label': 'Numbered List',
              'icon': Icons.format_list_numbered,
              'left': '1. '
            },
            {
              'label': 'Task List',
              'icon': Icons.check_box_outline_blank,
              'left': '- [ ] '
            },
          ],
        ),
        buildGroupedButton(
          mainIcon: const Icon(Icons.code),
          onMainPressed: () => insertText('```\n', '\n```'),
          options: [
            {
              'label': 'Code Block',
              'icon': Icons.code,
              'left': '```\n',
              'right': '\n```'
            },
            {
              'label': 'Inline Code',
              'icon': Icons.code_off,
              'left': '`',
              'right': '`'
            },
          ],
        ),
        buildGroupedButton(
          mainIcon: const Icon(Icons.format_quote),
          onMainPressed: () => insertText('> '),
          options: [
            {'label': 'Blockquote', 'icon': Icons.format_quote, 'left': '> '},
            {
              'label': 'Horizontal Line',
              'icon': Icons.horizontal_rule,
              'left': '\n---\n'
            },
            {
              'label': 'Image (coming soon)',
              'icon': Icons.image,
              'left': '![Alt text](url)'
            },
          ],
        ),
      ],
    );
  }

  Widget buildEditor() {
    return Card(
      margin: EdgeInsets.zero,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMarkdownToolbar(),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                scrollController: _editorScrollController,
                keyboardType: TextInputType.multiline,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: const OutlineInputBorder(),
                  hintText: 'Write your markdown here...',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).hintColor),
                  contentPadding: const EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPreview() {
    return Card(
      margin: EdgeInsets.zero,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Markdown(
          data: _contentController.text,
          controller: _previewScrollController,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            p: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPhone = MediaQuery.of(context).size.width < 600;
    void onSave() async {
      final api = WebUtilz();
      final result = await api.request(
        endpoint: 'NOTE',
        action: 'UPDATE',
        method: 'POST',
        body: {
          'id': widget.data['uuid'],
          'titolo': _titleController.text,
          'contenuto': _contentController.text,
        },
      );
      if (result['status'] == 200) {
        showSnackBar(context, 'Nota salvata!', 2);
      } else {
        showSnackBar(context, 'Errore durante il salvataggio!', 2);
      }
    }

    if (isPhone) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isEditingTitle
                  ? SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _titleController,
                        autofocus: true,
                        onSubmitted: (_) {
                          setState(() {
                            _isEditingTitle = false;
                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            _isEditingTitle = false;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        ),
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      ),
                    )
                  : Text(
                      _titleController.text.isNotEmpty
                          ? _titleController.text
                          : 'Nuovo Appunto',
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                    ),
              if (showEditor) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditingTitle = !_isEditingTitle;
                    });
                  },
                  tooltip: 'Modifica Titolo',
                ),
              ],
            ],
          ),
          actions: showEditor
              ? [
                  IconButton(
                    icon: const Icon(Icons.save),
                    tooltip: 'Salva',
                    onPressed: onSave,
                  ),
                ]
              : [],
          bottom: showEditor
              ? TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Editor'),
                    Tab(text: 'Preview'),
                  ],
                )
              : null,
        ),
        body: showEditor
            ? TabBarView(
                controller: _tabController,
                children: [
                  buildEditor(),
                  buildPreview(),
                ],
              )
            : buildPreview(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isEditingTitle
                  ? SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _titleController,
                        autofocus: true,
                        onSubmitted: (_) {
                          setState(() {
                            _isEditingTitle = false;
                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            _isEditingTitle = false;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        ),
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      ),
                    )
                  : Text(
                      _titleController.text.isNotEmpty
                          ? _titleController.text
                          : 'Nuovo Appunto',
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                    ),
              if (showEditor) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditingTitle = !_isEditingTitle;
                    });
                  },
                  tooltip: 'Modifica Titolo',
                ),
              ],
            ],
          ),
          actions: showEditor
              ? [
                  IconButton(
                    icon: const Icon(Icons.save),
                    tooltip: 'Salva',
                    onPressed: onSave,
                  ),
                ]
              : [],
        ),
        body: showEditor
            ? Row(
                children: [
                  Expanded(child: buildEditor()),
                  const VerticalDivider(width: 1),
                  Expanded(child: buildPreview()),
                ],
              )
            : buildPreview(),
      );
    }
  }
}
