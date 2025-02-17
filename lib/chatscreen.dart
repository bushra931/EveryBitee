import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> messages = ["What are you planning to cook?"];
  List<Map<String, dynamic>> ingredientList = [];
  List<String> selectedIngredients = [];
  bool _isLoading = false;
  bool _showCheckboxes = false;
  bool _showCalorieOptions = false;

  void sendMessage() {
    if (_controller.text.isNotEmpty) {
      String userMessage = _controller.text;
      setState(() {
        messages.add(userMessage);
        _isLoading = true;
      });
      _controller.clear();

      if (_showCalorieOptions) {
        adjustCalories(userMessage);
      } else if (userMessage.toLowerCase().contains("nutrition") &&
          selectedIngredients.isNotEmpty) {
        getNutritionalValue(selectedIngredients);
      } else {
        getDishIngredients(userMessage);
      }
    }
  }

  Future<void> getNutritionalValue(List<String> ingredients) async {
    const apiKey = "AIzaSyBFfJrN7Bq6ilr7ep_NTtFSI6s_cJMvBWg";
    final model = GenerativeModel(apiKey: apiKey, model: "gemini-pro");
    final prompt = """
I have the following ingredients: ${ingredients.join(", ")}
Provide the **total calorie count first in bold** and then give a detailed breakdown:
- **Total Calories: XX kcal**
- Ingredient-wise breakdown:
  - Calories
  - Proteins
  - Fats
  - Carbohydrates
  - Additional health benefits
""";
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      if (response.text != null) {
        setState(() {
          messages.add(response.text!);
          _isLoading = false;
          _showCheckboxes = false;
          ingredientList.clear();
          selectedIngredients.clear();
          _showCalorieOptions = true;

          messages.add(
              "Do you want to **increase or decrease** calorie intake?\nChoose an option:");
        });
      }
    } catch (e) {
      setState(() {
        messages.add("Error fetching nutritional values. Please try again.");
        _isLoading = false;
      });
    }
  }

  void adjustCalories(String userResponse) async {
    bool increase = userResponse.toLowerCase().contains("increase");
    bool decrease = userResponse.toLowerCase().contains("decrease");

    if (!increase && !decrease) {
      messages.add("Please choose a valid option: 'Increase' or 'Decrease'.");
      return;
    }

    const apiKey = "AIzaSyBFfJrN7Bq6ilr7ep_NTtFSI6s_cJMvBWg";
    final model = GenerativeModel(apiKey: apiKey, model: "gemini-pro");

    final prompt = """
I have the following ingredients: ${selectedIngredients.join(", ")}
I want to ${increase ? "increase" : "decrease"} the total calorie intake.
Suggest alternative ingredients or modifications while maintaining taste and balance.
""";

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      if (response.text != null) {
        setState(() {
          messages.add(response.text!);
          _showCalorieOptions = false;
        });
      }
    } catch (e) {
      setState(() {
        messages.add("Error adjusting calorie intake. Please try again.");
      });
    }
  }

  Future<void> getDishIngredients(String dishName) async {
    const apiKey = "AIzaSyBFfJrN7Bq6ilr7ep_NTtFSI6s_cJMvBWg";
    final model = GenerativeModel(apiKey: apiKey, model: "gemini-pro");
    final prompt = """
I want to cook a dish named "$dishName". Provide a structured list of ingredients:
- Ingredient Name: Quantity
- Special instructions if needed
""";
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      if (response.text != null) {
        List<Map<String, dynamic>> extractedIngredients = response.text!
            .split("\n")
            .where((line) => line.startsWith("- "))
            .map((line) => {"name": line.substring(2), "selected": false})
            .toList();
        setState(() {
          messages.add("Here is the list of ingredients:\n" +
              extractedIngredients.map((e) => "- ${e['name']}").join("\n"));
          ingredientList = extractedIngredients;
          _isLoading = false;
          _showCheckboxes = true;
        });
      }
    } catch (e) {
      setState(() {
        messages.add("Error fetching ingredients. Please try again.");
        _isLoading = false;
      });
    }
  }

  void startNewChat() {
    setState(() {
      messages.clear();
      messages.add("What are you planning to cook?");
      ingredientList.clear();
      selectedIngredients.clear();
      _showCheckboxes = false;
      _showCalorieOptions = false;
    });
  }

  Widget _buildMessage(String message, bool isUser) {
    final regex = RegExp(r'\*\*(.*?)\*\*');
    List<TextSpan> textSpans = [];
    int lastEnd = 0;

    // Use regex to find all matches of **text**
    regex.allMatches(message).forEach((match) {
      // Add the text before the match
      if (match.start > lastEnd) {
        textSpans.add(TextSpan(
          text: message.substring(lastEnd, match.start),
          style: TextStyle(color: Colors.white, fontSize: 16),
        ));
      }

      // Add the matched text (inside **) with bold styling
      textSpans.add(TextSpan(
        text: match.group(1), // Extract the text inside **
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold, // Apply bold style
        ),
      ));

      lastEnd = match.end;
    });

    // Add any remaining text after the last match
    if (lastEnd < message.length) {
      textSpans.add(TextSpan(
        text: message.substring(lastEnd),
        style: TextStyle(color: Colors.white, fontSize: 16),
      ));
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: isUser ? Colors.purple : Colors.blueAccent,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: RichText(
              text: TextSpan(children: textSpans),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Your Calorie Friend',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: startNewChat)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == messages.length) {
                  return Center(child: CircularProgressIndicator());
                }
                return _buildMessage(messages[index], index.isOdd);
              },
            ),
          ),
          if (_showCheckboxes)
            Expanded(
              child: ListView.builder(
                itemCount: ingredientList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(ingredientList[index]['name']),
                    value: ingredientList[index]['selected'],
                    onChanged: (bool? value) {
                      setState(() {
                        ingredientList[index]['selected'] = value!;
                        if (value) {
                          selectedIngredients
                              .add(ingredientList[index]['name']);
                        } else {
                          selectedIngredients
                              .remove(ingredientList[index]['name']);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          if (_showCalorieOptions)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        adjustCalories('increase');
                      },
                      child: Text('Increase Calories'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        adjustCalories('decrease');
                      },
                      child: Text('Decrease Calories'),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ),
                ],
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
                      hintText: 'Type a dish name...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: sendMessage,
                    color: Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
