import json
import os

import joblib
from fastapi import FastAPI
from schema import HouseInfo, HousePrediction
from utils.data_processing import format_input_data
from utils.logging import logger
from prometheus_fastapi_instrumentator import Instrumentator

# Creating FastAPI instance
app = FastAPI()

# Loading model with default path models/model.pkl
logger.info("Model loading model...")
clf = joblib.load("models/model.pkl")
logger.info("Model loaded successfully.")

# Setup Prometheus metrics
instrumentator = Instrumentator().instrument(app).expose(app, endpoint="/metrics")

# Creating an endpoint to receive the data
# to make prediction on
@app.post("/predict", response_model=HousePrediction)
def predict(data: HouseInfo):
    logger.info("Make predictions...")

    # Predicting the class
    # Convert data to pandas DataFrame and make predictions
    price = clf.predict(format_input_data(data))[0]

    # Return the result
    return HousePrediction(Price=price)
