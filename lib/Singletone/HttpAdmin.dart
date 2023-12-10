import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

class HttpAdmin{

  HttpAdmin();

  Future<List<String>> obtenerPersonajesMarvel() async {
    final llm = OpenAI(apiKey: "", defaultOptions: const OpenAIOptions(temperature: 0.6, maxTokens: 250, model: 'gpt-3.5-turbo-instruct'));

    try {
      // Set prompt for generating Marvel characters
      final prompt = """Generate a list of 10 Marvel characters, please return the output as a valid JSON list.
Use this schema definition:
{
  "characters": [
    {
      "name": "Tony Stark"
    },
    {
      "name": "Steve Rogers"
    },
    {
      "name": "Loki Odinson"
    }
  ]
}
""";
      final llmRes = await llm(prompt);
      print(llmRes);
      // Parse the JSON string and extract the names
      final List<dynamic> characters = json.decode(llmRes.trim())['characters'];
      print(characters);
      final List<String> names = characters.map((character) => character['name'].toString()).toList();

      print(names);
      names.add('Ninguno');
      return names;
    } catch (e) {
      // Handle any errors that may occur during the generation process
      print('Error generating Marvel characters: $e');
      return [];
    }
  }

  Future<List<String>> obtenerTiposDePokemons() async{
    var url = Uri.https('pokeapi.co', '/api/v2/pokemon/');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var results = jsonResponse['results'] as List<dynamic>;

      List<String> nombres = results.map<String>((result) => result['name'] as String).toList();
      nombres.add('Ninguno');
      return nombres;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }

}