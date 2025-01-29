from flask import Flask, jsonify
from datasets import load_dataset

app = Flask(__name__)

# Load the OpenFoodFacts dataset (this can be optimized)
dataset = load_dataset("openfoodfacts/product-database")

@app.route('/barcode/<string:barcode>', methods=['GET'])
def get_product_info(barcode):
    # Search for the product in the dataset by barcode
    product_data = dataset['train'].filter(lambda x: x['barcode'] == barcode)

    if len(product_data) > 0:
        product = product_data[0]
        return jsonify({
            'product_name': product.get('product_name', 'N/A'),
            'nutriscore': product.get('nutriscore_grade', 'N/A'),
            'ecoscore': product.get('ecoscore_score', 'N/A'),
            # Add more fields if required
        })
    else:
        return jsonify({'error': 'Product not found'}), 404

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5000)
