import 'package:http/http.dart' as http;
import 'dart:convert';

class Message {
  final String role;
  final String content;

  Message({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
      };
}

class GroqService {
  final String apiKey;
  final String baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  final List<Message> conversationHistory = [];

  GroqService({required this.apiKey}) {
    // Add the initial system message
    conversationHistory.add(Message(
      role: 'system',
      content: 'Halo Groq. Sekarang, anda sedang berada di sebuah pos penanggulangan gempa sebagai asisten disana, kamu akan menemui banyak orang yang berkonsultasi tentang masalah gempa. Dan mulai sekarang, namamu adalah SiPandhu, kamu hanya akan menanggapi pertanyaan seputar gempa dan bencana alam. Dan untuk menjadi seorang asisten yang baik, kamu harus membalas dan menjawab pertanyaan klien dengan bahasa Indonesia yang baik dan benar'
    ));
  }

  Future<String> generateResponse(String prompt) async {
    try {
      // Add user message to history
      conversationHistory.add(Message(role: 'user', content: prompt));

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama3-8b-8192',
          'messages': conversationHistory.map((msg) => msg.toJson()).toList(),
          'temperature': 1,
          'max_tokens': 1024,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final assistantResponse = data['choices'][0]['message']['content'];
        
        // Add assistant's response to history
        conversationHistory.add(Message(
          role: 'assistant',
          content: assistantResponse
        ));

        return assistantResponse;
      } else {
        throw Exception('Failed to generate response: ${response.statusCode}');
      }
    } catch (e) {
      return 'Maaf, terjadi kesalahan: $e';
    }
  }

  // Optional: Method to clear conversation history if needed
  void clearHistory() {
    conversationHistory.clear();
    // Re-add the system message
    conversationHistory.add(Message(
      role: 'system',
      content: 'Halo Groq. Sekarang, anda sedang berada di sebuah pos penanggulangan gempa sebagai asisten disana, kamu akan menemui banyak orang yang berkonsultasi tentang masalah gempa. Dan mulai sekarang, namamu adalah SiPandhu, kamu hanya akan menanggapi pertanyaan seputar gempa dan bencana alam. Dan untuk menjadi seorang asisten yang baik, kamu harus membalas dan menjawab pertanyaan klien dengan bahasa Indonesia yang baik dan benar'
    ));
  }
}