class HtmlHelper {
  /// Converts HTML text to plain text with proper formatting
  static String parseHtml(String htmlText) {
    if (htmlText.isEmpty) return '';
    
    String text = htmlText;
    
    // Remove <p> and </p> tags
    text = text.replaceAll(RegExp(r'<p[^>]*>'), '');
    text = text.replaceAll('</p>', '\n\n');
    
    // Replace <br> tags with newlines
    text = text.replaceAll(RegExp(r'<br\s*/?>'), '\n');
    
    // Remove other HTML tags
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');
    
    // Decode HTML entities
    text = text.replaceAll('&amp;', '&');
    text = text.replaceAll('&lt;', '<');
    text = text.replaceAll('&gt;', '>');
    text = text.replaceAll('&quot;', '"');
    text = text.replaceAll('&#39;', "'");
    text = text.replaceAll('&nbsp;', ' ');
    
    // Remove extra whitespace and trim
    text = text.replaceAll(RegExp(r'\n\s*\n\s*\n'), '\n\n'); // Max 2 newlines
    text = text.trim();
    
    return text;
  }
}

