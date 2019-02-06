part of dslink.common;

class Permission {
  /// now allowed to do anything
  static const int NONE = 0;

  /// list node
  static const int LIST = 1;

  /// read node
  static const int READ = 2;

  /// write attribute and value
  static const int WRITE = 3;

  /// config the node
  static const int CONFIG = 4;

  /// something that can never happen
  static const int NEVER = 5;

  static const List<String> names = const [
    'none',
    'list',
    'read',
    'write',
    'config',
    'never'
  ];

  static const Map<String, int> nameParser = const {
    'none': NONE,
    'list': LIST,
    'read': READ,
    'write': WRITE,
    'config': CONFIG,
    'never': NEVER
  };

  static int parse(Object obj, [int defaultVal = NEVER]) {
    if (obj is String && nameParser.containsKey(obj)) {
      return nameParser[obj];
    }
    return defaultVal;
  }
}
