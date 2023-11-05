import numpy as np
from tensorflow import keras

loaded_model = keras.models.load_model("my_model.h5")

x_test = np.array([[14, 26, 0, 5000]])

predictions = loaded_model.predict(x_test)

print("Predicted fare:", predictions)
