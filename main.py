from fastapi import FastAPI
from datasets import load_dataset
from pydantic import BaseModel

# Load OpenFoodFacts dataset
dataset = load_dataset("openfoodfacts/product-database", split="train")

# Create a FastAPI app
app = FastAPI()

class BarcodeRequest(BaseModel):
    barcode: str

class Product(BaseModel):
    name: str
    barcode: str
    nutriscore: str
    ecoscore: str
    ingredients_text: str

@app.get("/")
def read_root():
    return {"message": "Welcome to the OpenFoodFacts API"}

@app.post("/get_product/")
def get_product_by_barcode(request: BarcodeRequest):
    barcode = request.barcode
    # Search the dataset for the given barcode
    product = next((p for p in dataset if p['code'] == barcode), None)

    if product:
        return Product(
            name=product['product_name'],
            barcode=product['code'],
            nutriscore=product.get('nutriscore_grade', 'N/A'),
            ecoscore=product.get('ecoscore_grade', 'N/A'),
            ingredients_text=product.get('ingredients_text', 'N/A')
        )
    else:
        return {"error": "Product not found"}
