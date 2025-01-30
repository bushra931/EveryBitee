import 'package:openfoodfacts/openfoodfacts.dart';

Future<String?> getProductDetails(String barcode) async {
  try {
    // Make the API request
    ProductQueryConfiguration config = ProductQueryConfiguration(
      barcode,
      version: ProductQueryVersion.v3,
    );
    ProductResultV3 product = await OpenFoodAPIClient.getProductV3(config);

    // Check if the product is available
    if (product.product != null) {
      // Generate the formatted prompt using the product data
      final formattedPrompt = generatePrompt(product.product!);
      print(formattedPrompt); // Print the formatted prompt
      return formattedPrompt;
    } else {
      print("Product not found");
      return null;
    }
  } catch (e) {
    print("Failed to fetch product details: $e");
    return null;
  }
}

Future<String?> getProductDetailsByName(String barcode) async {
  try {
    ProductSearchQueryConfiguration configuration =
        ProductSearchQueryConfiguration(
      version: ProductQueryVersion.v3,
      parametersList: <Parameter>[
        SearchTerms(terms: [barcode]),
      ],
    );

    SearchResult result = await OpenFoodAPIClient.searchProducts(
      User(userId: '', password: ''),
      configuration,
    );
    print('here');
    print(result);

    // print(result.products?[0].productName);
    // ProductResultV3 product = await OpenFoodAPIClient.getProductV3(config);

    // Check if the product is available
    // if (product.product != null) {
    //   // Generate the formatted prompt using the product data
    //   final formattedPrompt = generatePrompt(product.product!);
    //   print(formattedPrompt); // Print the formatted prompt
    //   return formattedPrompt;
    // } else {
    //   print("Product not found");
    //   return null;
    // }
  } catch (e) {
    print("Failed to fetch product details: $e");
    return null;
  }
}

String generatePrompt(Product productData) {
  // Format the product details into a human-readable prompt
  return '''
  A packed food product contains the following ingredients and information:

  Ecoscore Score: ${productData.ecoscoreScore ?? 'N/A'}
  Allergens: Contains ${productData.allergens?.names?.join(', ') ?? 'N/A'}
  Allergens From Ingredients: Contains ${productData.ingredients?.toList ?? 'N/A'}
  Nova Group: ${productData.novaGroup ?? 'N/A'}
  Nutriscore Score: ${productData.nutriscore ?? 'N/A'}
  Additives Tags: ${(productData.additives?.names)?.join(', ') ?? 'N/A'}
  Ingredients Tags: ${(productData.ingredientsTags)?.join(', ') ?? 'N/A'}
  Nutriments:
    Energy: ${productData.nutriments?.getValue(Nutrient.energyKJ, PerSize.oneHundredGrams) ?? 'N/A'} kcal per 100g
    Fat: ${productData.nutriments?.getValue(Nutrient.fat, PerSize.oneHundredGrams) ?? 'N/A'}g per 100g
    Saturated Fat: ${productData.nutriments?.getValue(Nutrient.saturatedFat, PerSize.oneHundredGrams) ?? 'N/A'}g per 100g
    Carbohydrates: ${productData.nutriments?.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams) ?? 'N/A'}g per 100g
    Sugars: ${productData.nutriments?.getValue(Nutrient.sugars, PerSize.oneHundredGrams) ?? 'N/A'}g per 100g
    Proteins: ${productData.nutriments?.getValue(Nutrient.proteins, PerSize.oneHundredGrams) ?? 'N/A'}g per 100g
    Salt: ${productData.nutriments?.getValue(Nutrient.salt, PerSize.oneHundredGrams) ?? 'N/A'}g per 100g
    Sodium: ${productData.nutriments?.getValue(Nutrient.sodium, PerSize.oneHundredGrams) ?? 'N/A'}g per 100g
  Packaging: ${productData.packaging ?? 'N/A'}
  ''';
}

String generatePromptByName(String name) {
  // Format the product details into a human-readable prompt
  return '''
  A food products that name is ${name} .we dont have enough information
  ''';
}
