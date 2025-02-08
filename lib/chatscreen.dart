import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

List<Map<String, dynamic>> parseIngredients(String response) {
  List<Map<String, dynamic>> ingredients = [];
  List<String> lines = response.split("\n");

  for (String line in lines) {
    if (line.startsWith("- ")) {
      String ingredient = line.substring(2); // Remove "- " from the start
      ingredients.add({"name": ingredient, "selected": false});
    }
  }
  return ingredients;
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> messages = ["What are you planning to cook?"];
  List<Map<String, dynamic>> ingredientList = [];
  List<String> selectedIngredients = []; // ✅ Stores selected ingredients

  bool _isLoading = false;

  void sendMessage() {
  if (_controller.text.isNotEmpty) {
    String userMessage = _controller.text;
    
    setState(() {
      messages.add(userMessage); // Add user's message to chat
      _isLoading = true; // Show loading indicator
    });

    _controller.clear(); // Clear text field

    // ✅ If the user asks for nutritional values, use selected ingredients
    if (userMessage.toLowerCase().contains("nutrition") && selectedIngredients.isNotEmpty) {
      getNutritionalValue(selectedIngredients);
    } else {
      getDishIngredients(userMessage); // Call API to fetch ingredients
    }
  }
}

Future<void> getNutritionalValue(List<String> ingredients) async {
  const apiKey = ""; // Add your Gemini API key here
  final model = GenerativeModel(apiKey: apiKey, model: "gemini-pro");

  final prompt = """
I have the following ingredients:  
${ingredients.join(", ")}  

Please provide the detailed **nutritional values** for each ingredient, including:  
- Calories  
- Proteins  
- Fats  
- Carbohydrates  
- Any additional health benefits  

Make sure to format the response in a **clear and structured manner**.
""";
print(prompt);
  try {
    final response = await model.generateContent([Content.text(prompt)]);

    if (response.text != null) {
      setState(() {
        messages.add("Here is the nutritional breakdown:\n" + response.text!);
        _isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      messages.add("Error fetching nutritional values. Please try again.");
      _isLoading = false;
    });
    print("Error fetching nutritional values: $e");
  }
}


  Future<void> getDishIngredients(String dishName) async {
    const apiKey =
        ""; // Add your Gemini API key here
    final model = GenerativeModel(apiKey: apiKey, model: "gemini-pro");

    final prompt = """
I want to cook a dish named "$dishName".  
Please provide a detailed list of ingredients required to make it.  
Mention their quantities and any important preparation details.  

Format the response as follows:
- Ingredient Name: Quantity (if applicable)  
- Special instructions if needed  

Example:
- Chicken Breast: 200g, boneless and skinless
- Garlic: 2 cloves, minced
- Olive Oil: 2 tablespoons
- Salt: To taste  

Give me a complete and accurate ingredient list in a structured, easy-to-read format.
""";

    try {
      final response = await model.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        List<Map<String, dynamic>> extractedIngredients =
            parseIngredients(response.text!);

        setState(() {
          messages.add("Here is the list of ingredients:\n" +
              extractedIngredients
                  .map((e) => "- ${e['name']}")
                  .join("\n")); // Format ingredients as a message
          ingredientList = extractedIngredients; // Store for checkboxes
          _isLoading = false; // Hide loading indicator
        });
      }
    } catch (e) {
      setState(() {
        messages.add("Error fetching ingredients. Please try again.");
        _isLoading = false;
      });
      print("Error fetching ingredients: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'You Calorie Friend',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueAccent,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Text(
                            "Thinking...",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Align(
                    alignment: index == 0 || index.isEven
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: index == 0 || index.isEven
                          ? Colors.blueAccent
                          : Colors.purple,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Text(
                          messages[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ✅ Checkboxes for ingredients
          if (ingredientList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: ingredientList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title:
                        Text(ingredientList[index]['name']), // Ingredient name
                    value: ingredientList[index]['selected'], // Checkbox state
                    onChanged: (bool? value) {
                      setState(() {
                        ingredientList[index]['selected'] = value!;
                        if (value) {
                          selectedIngredients.add(ingredientList[index]
                              ['name']); // ✅ Add selected ingredient
                        } else {
                          selectedIngredients.remove(ingredientList[index]
                              ['name']); // ✅ Remove if unchecked
                        }
                      });
                    },
                  );
                },
              ),
            ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Type a dish name...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
