class MemoryService {
  static final Map<String, String> _memory = {}; // Store preferences

  // Remember a key-value pair (e.g., name: Sam)
  static void remember(String key, String value) {
    _memory[key] = value;
  }

  // Recall a stored value by key (e.g., get name)
  static String? recall(String key) {
    return _memory[key];
  }

  // Get all memories (optional, for debugging)
  static Map<String, String> get allMemories => _memory;

  // Clear all memories (optional, for logout or reset)
  static void clear() {
    _memory.clear();
  }
}
