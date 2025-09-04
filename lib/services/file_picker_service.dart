import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class FilePickerService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid();

  // Pick and upload image
  Future<Map<String, dynamic>?> pickAndUploadImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name;
        int fileSize = result.files.single.size;
        
        // Upload to Firebase Storage
        String downloadUrl = await _uploadFile(file, 'images', fileName);
        
        return {
          'fileUrl': downloadUrl,
          'fileName': fileName,
          'fileSize': _formatFileSize(fileSize),
          'fileExtension': path.extension(fileName).toLowerCase(),
          'messageType': 'image',
        };
      }
    } catch (e) {
      print('Error picking image: $e');
    }
    return null;
  }

  // Pick and upload video
  Future<Map<String, dynamic>?> pickAndUploadVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        allowedExtensions: ['mp4', 'avi', 'mov', 'wmv', 'flv', 'mkv'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name;
        int fileSize = result.files.single.size;
        
        // Upload to Firebase Storage
        String downloadUrl = await _uploadFile(file, 'videos', fileName);
        
        return {
          'fileUrl': downloadUrl,
          'fileName': fileName,
          'fileSize': _formatFileSize(fileSize),
          'fileExtension': path.extension(fileName).toLowerCase(),
          'messageType': 'video',
        };
      }
    } catch (e) {
      print('Error picking video: $e');
    }
    return null;
  }

  // Pick and upload audio
  Future<Map<String, dynamic>?> pickAndUploadAudio() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
        allowedExtensions: ['mp3', 'wav', 'aac', 'ogg', 'm4a'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name;
        int fileSize = result.files.single.size;
        
        // Upload to Firebase Storage
        String downloadUrl = await _uploadFile(file, 'audio', fileName);
        
        return {
          'fileUrl': downloadUrl,
          'fileName': fileName,
          'fileSize': _formatFileSize(fileSize),
          'fileExtension': path.extension(fileName).toLowerCase(),
          'messageType': 'audio',
        };
      }
    } catch (e) {
      print('Error picking audio: $e');
    }
    return null;
  }

  // Pick and upload document
  Future<Map<String, dynamic>?> pickAndUploadDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: [
          'pdf', 'doc', 'docx', 'txt', 'rtf',
          'xls', 'xlsx', 'ppt', 'pptx',
          'zip', 'rar', '7z'
        ],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name;
        int fileSize = result.files.single.size;
        
        // Upload to Firebase Storage
        String downloadUrl = await _uploadFile(file, 'documents', fileName);
        
        return {
          'fileUrl': downloadUrl,
          'fileName': fileName,
          'fileSize': _formatFileSize(fileSize),
          'fileExtension': path.extension(fileName).toLowerCase(),
          'messageType': 'document',
        };
      }
    } catch (e) {
      print('Error picking document: $e');
    }
    return null;
  }

  // Upload file to Firebase Storage
  Future<String> _uploadFile(File file, String folder, String fileName) async {
    String uniqueFileName = '${_uuid.v4()}_$fileName';
    Reference storageRef = _storage.ref().child('chat_files/$folder/$uniqueFileName');
    
    UploadTask uploadTask = storageRef.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    
    return await snapshot.ref.getDownloadURL();
  }

  // Format file size for display
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Get file icon based on extension
  String getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case '.pdf':
        return '📄';
      case '.doc':
      case '.docx':
        return '📝';
      case '.xls':
      case '.xlsx':
        return '📊';
      case '.ppt':
      case '.pptx':
        return '📈';
      case '.txt':
        return '📄';
      case '.zip':
      case '.rar':
      case '.7z':
        return '📦';
      case '.mp3':
      case '.wav':
      case '.aac':
        return '🎵';
      case '.mp4':
      case '.avi':
      case '.mov':
        return '🎬';
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return '🖼️';
      default:
        return '📎';
    }
  }
}
