# taxi_price_forecast Прогноз стоимость поездки на Яндекс такси
На данный момент собирает следующую информацию о поездках:
* Стоимость поездки
* Время поездки
* Дистанция
* Время ожидания такси

# В планах
* Учитывать еще доп параметры, которые влияют на стоимость поездки (погода, загруженность водителей, пробки)
* На основе собранных данных высчитать номинальную стоимоть одного км поездки
* Учет коэффициентов в завимости от внешних параметров, влияющих на стоимость такси

# Настройка

* pip install -r requirements.txt

PostgresSQl V14 или выше

## Создаем таблицы 
* psql \i 'taxi_price_forecast/db/ddl.sql'
## Создаем хранимые функции 
* psql \i 'taxi_price_forecast/db/add_empty_schedule.sql' 
* psql \i 'taxi_price_forecast/db/get_current_coordinate.sql' 
* psql \i 'taxi_price_forecast/db/set_info_taxi_roads_facts.sql'

## Настройка airflow

* Инициализация базы данных - airflow db init
* Запуск веб сервера airflow - airflow webserver -p 18273 -D
* Создание пользователя 
airflow users create \
          --username admin \
          --firstname admin \
          --lastname admin \
          --role Admin \
          --email admin@example.org \
          -p 12345
* По умолчанию файл с дагом должен находиться тут - /root/airflow/dags помещаем сюда файл dag.py
* Запуск шедулера - airflow scheduler -D
* http://localhost:18273/ Переходим, находим наш Dag

# Заполнение пустого расписания пример

## По названию объекта 

* CALL add_empty_schedule('2023-06-11 00:00:00'::timestamp,'2023-06-12 00:00:00'::timestamp,0,'улица Чернореченская','Международный Аэропорт Курумоч');


## По координатам

* CALL add_empty_schedule_from_coordinate('2023-06-12 00:00:00'::timestamp
					,'2023-06-20 00:00:00'::timestamp
					,'53.195606281012616'
					,'50.0937686444337'
					,'53.23373461460301'
					,'50.201073485931154');

Создается пустое расписание с интервалами по 15 минут, которое заполняется полезной информацие (цена, время и тд) джобом airflow