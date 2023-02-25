// ignore_for_file: constant_identifier_names

enum MessageEnum {
  TEXT('text'),
  IMAGE('image'),
  AUDIO('audio'),
  VIDEO('video'),
  GIF('gif');

  const MessageEnum(this.type);
  final String type;
}

extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch(this) {
      case 'text':
      return MessageEnum.TEXT;
      case 'image':
      return MessageEnum.IMAGE;
      case 'audio':
      return MessageEnum.AUDIO;
      case 'video':
      return MessageEnum.VIDEO;
      case 'gif':
      return MessageEnum.GIF;
      default:
      return MessageEnum.TEXT;
    }
  }
}
