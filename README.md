# BigDataTrino
Анализ больших данных - лабораторная работа №4 - ETL реализованный с помощью Trino

## Содержание 
1. Структура проекта
2. Схема dwh и витрины
3. Принцип работы
4. Запуск проекта

## Структура проекта 
```/data``` - исходные CSV-файлы  

```/init```  
- ```/clickhouse``` - папка с init-скриптом ClickHouse (создание таблиц, загрузка данных)
- ```/postgres``` - папка с init-скриптом PostgreSQL (создание таблиц, загрузка данных)
 
```/sql```  
-  ```01_create_dwh.sql``` - создание таблиц stg_mock_data, размерностей, фактов с помощью Trino  
- ```02_create_reports.sql``` - создание витрин в ClickHouse   
- ```03_check_datamarts.sql``` - проверочные запросы для всех отчётов  

```/trino/catalog```  
-  ```clickhouse.properties``` - конфигурация каталога ClickHouse для Trino
-   ```postgres.properties``` - конфигурация каталога PostgreSQL для Trino
  
```docker-compose.yml```  
  
## Схема dwh и витрины 
### Модель "звезда" (хранилище данных)
- _stg_mock_data_ - временная таблица-стык, объединяющая данные из ClickHouse и PostgreSQL
- _dim_customer_ - измерение "Покупатель"
- _dim_customer_pet_ - измерение "Питомец покупателя"
- _dim_seller_ - измерение "Продавец"
- _dim_supplier_ - измерение "Поставщик"
- _dim_store_ - измерение "Магазин"
- _dim_product_ - измерение "Товар"
- _fact_sales_ - таблица фактов "Продажи"

### Витрины данных (datamarts) 
Все витрины создаются в схеме ```clickhouse.datamarts``` и представляют собой готовые агрегаты для анализа.

- _report_sales_products_ - продажи по продуктам
- _report_sales_customers_ - продажи по клиентам
- _report_sales_time_ - временные тренды
- _report_sales_stores_ - продажи по магазинам
- _report_sales_suppliers_ - продажи по поставщикам
- _report_product_quality_ - качество продукции

## Принцип работы
ETL построен на Trino.
1. Контейнер ClickHouse загружает первые 5 CSV-файлов в таблицу ```default.mock_data``` через ```INFILE```. Контейнер PostgreSQL загружает следующие 5 CSV-файлов в таблицу ```public.mock_data``` через ```COPY```.
2. Скрипт ```01_create_dwh.sql``` через Trino объединяет данные из ClickHouse и PostgreSQL в ```stg_mock_data```, строит размерности и формирует таблицу фактов.
3. Скрипт ```02_create_reports.sql``` на основе размерностей и факта создаёт 6 витрин в ClickHouse.

## Запуск проекта
В корневой папке проекта откройте терминал.

### 1. Сборка образа
Выполните:  
```bash
docker compose up -d
```

Далее проверьте контейнеры через:
```
docker ps
```
Дождитесь, чтобы все контейнеры получили статус Up / Healthy.

### 2. Проверка Trino
Откройте Trino UI. Для этого перейдите в браузере по ссылке: 
```
http://localhost:18080
```
Вас попросят ввести имя. Введите ```trino```. Если интерфейс открылся, Trino работает.

### 3. Выполнение DWH-скрипта
В терминале выполните команду:
```bash
docker exec -it lab4_trino trino --server http://localhost:8080 --user trino --file /sql/01_create_dwh.sql
```

### 4. Выполнение скрипта витрин
В терминале выполните команду:
```bash
docker exec -it lab4_trino trino --server http://localhost:8080 --user trino --file /sql/02_create_reports.sql
```

### 5. Проверка результата
В файле ```03_check_datamarts.sql``` есть готовые SQL-запросы. Вы можете их выполнить различными способами.  

Например, в **DBeaver** создайте новое соединение с параметрами:  
**host:** ```localhost```  
**port:** ```18123```  
**user/password:** ```trino```  

После подключения откройте файл с SQL-запросами и выполняйте по очереди для проверки.

### 6. Остановка проекта
Выполните в терминале команду:  
```
docker compose down -v
```
