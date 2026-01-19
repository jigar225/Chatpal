class McpContext {
  final String systemprompt;
  final List<String> chathistory;
  final String userprompt;
  final Map<String,String> memory;
  McpContext({required this.systemprompt, required this.chathistory, required this.userprompt, required this.memory});

  String buildPrompt(){
    String memoryBlock = memory.entries.map((e)=>"${e.key}: ${e.value}").join('\n');
    String historybloc = chathistory.join('\n');
    return '''
System:
$systemprompt
Memory::
$memoryBlock
Chat History:
$historybloc
User:
$userprompt
''';
  }
}
