import os

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

import numpy as np
from tensorflow.keras.layers import Dense, Flatten
from tensorflow import keras
from dotenv import load_dotenv
import psycopg2
import matplotlib.pyplot as plt


path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(path):
    load_dotenv(path)

dbname = os.getenv("DBNAME")
user = os.getenv("DBUSER")
password = os.getenv("PASSWORD")
host = os.getenv("HOST")
port = os.getenv("PORT")

conn = psycopg2.connect(dbname=dbname, user=user, password=password, host=host, port=port)
cursor = conn.cursor()


def get_data_for_model():
    cursor.callproc('get_data_for_model')
    conn.commit()
    data = cursor.fetchall()
    return data


data = get_data_for_model()

x_train = np.array([rec[0:4] for rec in data])
y_train = np.array([rec[4] for rec in data])

x_train = np.asarray(x_train).astype(np.float32)
y_train = np.asarray(y_train).astype(np.float32)
print(x_train.shape[1])

x_test = np.array([0, 4, 3, 3600]) # test
x_test = np.asarray(x_test).astype(np.float32).reshape(1, -1)  # Преобразовать в форму (1, количество_признаков)

# Определение обратных вызовов
checkpoint_callback = keras.callbacks.ModelCheckpoint(
    "best_model.h5",  # Путь для сохранения лучшей модели
    monitor="val_loss",  # Мониторим валидационную потерю
    save_best_only=True,  # Сохраняем только лучшую модель
    verbose=1  # Выводим информацию о сохранении модели
)

early_stopping_callback = keras.callbacks.EarlyStopping(
    monitor="val_loss",  # Мониторим валидационную потерю
    patience=50,  # Терпимость - сколько эпох ждать, прежде чем остановить обучение
    restore_best_weights=True,  # Восстанавливаем лучшие веса модели
    verbose=1  # Выводим информацию о прекращении обучения
)

model = keras.Sequential()
model.add(Dense(128, activation='relu', input_shape=(x_train.shape[1],)))
model.add(Dense(64, activation='relu'))
model.add(Dense(32, activation='relu'))
model.add(Dense(1, activation='linear'))
model.build()
print(model.summary())

model.compile(optimizer='rmsprop', loss='mse')
history = model.fit(x_train,
                    y_train,
                    epochs=200,
                    validation_split=0.2,
                    batch_size=32,
                    callbacks=[checkpoint_callback, early_stopping_callback]  # Добавляем обратные вызовы
                    )

plt.plot(history.history['loss'], label='Потери на обучении')
plt.plot(history.history['val_loss'], label='Потери на валидации')
plt.legend()
plt.xlabel('Эпохи')
plt.ylabel('Потери')
plt.show()

pred = model.predict(x_test, batch_size=32)
print(pred)

model.save("my_model.h5")
# print(y_train[1])
