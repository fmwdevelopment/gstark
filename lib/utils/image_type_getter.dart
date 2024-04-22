String getImageType(String filename) {
  // Get the last part of the filename after the last dot
  String extension = filename.split('.').last.toLowerCase();

  // Return the image type based on the extension
  switch (extension) {
    case 'png':
      return 'PNG';
    case 'jpg':
    case 'jpeg':
      return 'JPEG';
    case 'gif':
      return 'GIF';
    case 'bmp':
      return 'BMP';
  // Add more cases for other image types if needed
    default:
      return 'Unknown';
  }
}