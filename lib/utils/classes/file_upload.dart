import 'dart:io';

class FileUpload {
  String? type;
  String? path;
  String? filename;
  File? file;

  FileUpload({ this.type, this.path, this.filename, this.file });
}