# Pandas: расширенная шпаргалка

## Подключение

```python
import pandas as pd
```

---

## Создание DataFrame

```python
data = {
    "name": ["Иван", "Петр", "Анна"],
    "age": [25, 30, 22],
    "salary": [100, 200, 150]
}

df = pd.DataFrame(data)
```

`DataFrame` — это таблица: строки + столбцы.

---

## Просмотр данных

```python
df.head()      # первые строки
df.tail()      # последние строки
df.shape       # размер: (строки, столбцы)
df.columns     # названия колонок
df.info()      # типы данных и пропуски
df.describe()  # статистика по числовым колонкам
df.dtypes      # посмотреть тип данных
```

---

## Выбор данных

```python
df["name"]           # один столбец
df[["name", "age"]]  # несколько столбцов
```

```python
df.loc[0]   # строка по названию индекса
df.iloc[0]  # строка по позиции
```

---

# 🗺️ pandas .map()

`.map()` — замена / преобразование значений в Series

```python
df['col'].map(...)
```

👉 работает только с одной колонкой (`Series`)

---

# 🔄 Замена значений через словарь

```python
df['sex'].map({
    'M': 'Male',
    'F': 'Female'
})
```

### Было:

```text
M
F
M
```

### Стало:

```text
Male
Female
Male
```

👉 самый частый сценарий использования

---

# 🔢 Преобразование чисел

```python
df['price'].map(lambda x: x * 100)
```

### Было:

```text
0.15
0.30
```

### Стало:

```text
15
30
```

👉 применяет функцию к каждому элементу

---

# 🔤 Изменение текста

```python
df['name'].map(lambda x: x.upper())
```

### Было:

```text
ivan
anna
```

### Стало:

```text
IVAN
ANNA
```

---

# 📏 Категоризация значений

```python
df['age'].map(
    lambda x: 'adult' if x >= 18 else 'child'
)
```

### Было:

```text
10
25
17
```

### Стало:

```text
child
adult
child
```

---

# ❓ Работа с NaN

```python
df['sex'].map({
    'M': 'Male',
    'F': 'Female'
})
```

⚠️ Если значения нет в словаре → будет `NaN`

### Пример:

```text
M → Male
X → NaN
```

---

# ✅ Как избежать NaN

## fillna()

```python
df['sex'].map({
    'M': 'Male',
    'F': 'Female'
}).fillna('Unknown')
```

---

# 🔄 map() vs replace()

| Метод | Особенность |
|---|---|
| map() | только Series |
| replace() | Series и DataFrame |
| map() | отсутствующие значения → NaN |
| replace() | не найденные значения остаются как есть |

---

# 📌 map() + lambda

```python
df['salary'].map(lambda x: x / 1000)
```

👉 удобно для быстрых преобразований

---

# ⚠️ map() работает только с Series

```python
df['col'].map(...)
```

❌ нельзя:

```python
df.map(...)
```

---

# 💡 Часто используется для:

- переименования категорий
- преобразования значений
- создания признаков
- бинаризации
- быстрых функций через lambda

---

# 🚀 Самые частые варианты

```python
.map({'A': 1, 'B': 2})

.map(lambda x: x.upper())

.map(lambda x: x * 100)

.map(str)
```

---

# 🔤 Строковые методы pandas (.str)

`.str` — доступ к строковым методам Series

```python
df['col'].str.method()
```

👉 работает только со строками (`object` / `string`)

---

# 🔠 Изменение регистра

## lower()

```python
df['name'].str.lower()
```

```text
IVAN → ivan
```

👉 нижний регистр

---

## upper()

```python
df['name'].str.upper()
```

```text
ivan → IVAN
```

👉 ВЕРХНИЙ РЕГИСТР

---

## title()

```python
df['name'].str.title()
```

```text
ivan petrov → Ivan Petrov
```

👉 Каждое Слово С Большой Буквы

---

# ✂️ Удаление символов

## strip()

```python
df['name'].str.strip()
```

```text
'  ivan  ' → 'ivan'
```

👉 убрать пробелы по краям

---

## lstrip()

```python
df['name'].str.lstrip()
```

```text
'   ivan' → 'ivan'
```

👉 убрать пробелы слева

---

## rstrip()

```python
df['name'].str.rstrip()
```

```text
'ivan   ' → 'ivan'
```

👉 убрать пробелы справа

---

# 🔍 Поиск

## contains()

```python
df['email'].str.contains('gmail')
```

```text
ivan@gmail.com → True
test@yandex.ru → False
```

👉 содержит ли строка текст

---

## startswith()

```python
df['email'].str.startswith('admin')
```

```text
admin@gmail.com → True
user@gmail.com → False
```

👉 начинается ли строка

---

## endswith()

```python
df['file'].str.endswith('.csv')
```

```text
data.csv → True
image.png → False
```

👉 заканчивается ли строка

---

# 🔄 Замена

## replace()

```python
df['phone'].str.replace('-', '')
```

```text
+7-999-123 → +7999123
```

👉 замена текста

---

# ✂️ Разделение строки

## split()

```python
df['email'].str.split('@')
```

```text
ivan@gmail.com → ['ivan', 'gmail.com']
```

👉 разбить строку

---

## split(..., expand=True)

```python
df['email'].str.split('@', expand=True)
```

```text
0       1
ivan   gmail.com
```

👉 сразу разбивает на колонки

---

# 📌 Извлечение

## extract()

```python
df['email'].str.extract(r'@([\w.]+)')
```

```text
ivan@gmail.com → gmail.com
```

👉 извлечь часть строки через regex

---

# 🔢 Длина строки

## len()

```python
df['name'].str.len()
```

```text
ivan → 4
```

👉 длина строки

---

# 🔤 Получение символов

## slice()

```python
df['name'].str.slice(0, 3)
```

```text
ivan → iva
```

👉 символы с 0 по 3

---

## [ ]

```python
df['name'].str[0]
```

```text
ivan → i
```

👉 первый символ

---

# ❓ Проверки

## isdigit()

```python
df['col'].str.isdigit()
```

```text
123 → True
12a → False
```

👉 только цифры

---

## isalpha()

```python
df['col'].str.isalpha()
```

```text
ivan → True
ivan123 → False
```

👉 только буквы

---

## isalnum()

```python
df['col'].str.isalnum()
```

```text
ivan123 → True
ivan_123 → False
```

👉 буквы + цифры

---

# 🧹 Работа с NaN

## contains(..., na=False)

```python
df['email'].str.contains('gmail', na=False)
```

👉 NaN не вызовет ошибку

---

# 💡 Часто используемые

```python
.str.lower()
.str.strip()
.str.contains()
.str.replace()
.str.split()
.str.extract()
.str.len()
```

👉 база для очистки текстовых данных

---

## Фильтрация

```python
df[df["age"] > 25]
# строки, где age больше 25
```

---

### Несколько условий

```python
df[(df["age"] > 20) & (df["salary"] > 120)]
```

Что важно:

- `&` — И
- `|` — ИЛИ
- каждое условие пишется в скобках

---

### query()

```python
min_age = 25
df.query("age > @min_age")
```

Что значит:

- `age` — название колонки
- `@min_age` — переменная из Python
- `@` нужен, чтобы pandas понял: переменная находится вне строки

Аналог без `query()`:

```python
df[df["age"] > min_age]
```

---

## Сортировка

```python
df.sort_values("age")
# сортировка по возрастанию
```

```python
df.sort_values("age", ascending=False)
# сортировка по убыванию
```

```python
df.sort_values(
    ["age", "salary"],
    ascending=[True, False]
)
# сначала age по возрастанию,
# потом salary по убыванию
```

---

## Добавление столбца

```python
df["bonus"] = df["salary"] * 0.1
```

Создаем новый столбец `bonus` на основе `salary`.

---

## Переименование колонок

### Переименовать один столбец

```python
df = df.rename(columns={"name": "user_name"})
```

---

### Переименовать несколько столбцов

```python
df = df.rename(columns={
    "name": "user_name",
    "age": "user_age"
})
```

---

### Полностью заменить все названия

```python
df.columns = ["user_name", "user_age", "salary"]
```

Важно: количество новых названий должно совпадать с количеством колонок.

---

## Очистка названий колонок

Часто в данных из Excel/CSV есть пробелы, большие буквы и неудобные названия.

```python
df.columns = (
    df.columns
    .str.strip()              # убрать пробелы по краям
    .str.lower()              # привести к нижнему регистру
    .str.replace(" ", "_")    # заменить пробелы на _
)
```

Пример:

```text
" User Name " → "user_name"
```

---

## apply() и lambda

`apply()` применяет функцию к каждому элементу.

`lambda` — короткая функция без имени.

```python
lambda x: x * 2
```

- `x` — входное значение
- `x * 2` — что с ним сделать

---

### Простой пример

```python
df["age"].apply(lambda x: x * 2)
```

Умножаем каждое значение.

---

### С условием

```python
df["status"] = df["age"].apply(
    lambda x: "adult" if x >= 18 else "child"
)
```

Создаем новый столбец с логикой.

---

### По строкам

```python
df.apply(lambda row: row["age"] * 2, axis=1)
```

- `axis=1` — работать по строкам
- `axis=0` — работать по колонкам

---

## Что запомнить

- `apply()` — для логики
- `lambda` — короткая функция
- `apply()` медленнее обычных операций
- если можно сделать через `+ - * /`, лучше делать без `apply()`


---

## Работа с NaN

`NaN` — это пропущенное значение.

```python
df.isna()
# показать пропуски True/False
```

```python
df.dropna()
# удалить строки с пропусками
```

```python
df.fillna(0)
# заменить пропуски на 0
```

```python
df.dropna(subset=["age"])
# удалить строки, где age = NaN
```

```python
df["age"] = df["age"].fillna(df["age"].mean())
# заполнить пропуски средним age
```

---

## Преобразование типов

```python
df["age"] = df["age"].astype(float)
# привести age к float
```

```python
df["num"] = pd.to_numeric(df["num"], errors="coerce")
# преобразовать в число
# ошибки превратить в NaN
```

```python
df["cat"] = df["name"].astype("category")
# категориальный тип
```

---

## Работа с датами

### pd.to_datetime()

Преобразует строку в дату

```python
df["date"] = pd.to_datetime(df["date"])
```

---

### Пример

```python
df["date"] = ["2024-01-01", "2024-02-01"]

df["date"] = pd.to_datetime(df["date"])
```

👉 теперь это datetime, а не строка

---

### Ошибки в данных

```python
df["date"] = pd.to_datetime(df["date"], errors="coerce")
```

👉 если дата невалидная → станет NaN

---

### Формат даты

```python
pd.to_datetime(df["date"], format="%Y-%m-%d")
```

👉 используем, если формат известен

---

## Работа с датой

```python
df["year"] = df["date"].dt.year
df["month"] = df["date"].dt.month
df["day"] = df["date"].dt.day
df["weekday"] = df["date"].dt.day_name()
```

---

## Что запомнить

- `to_datetime()` — превращает строку в дату  
- `.dt` — доступ к частям даты  
- `errors="coerce"` — защита от ошибок  

---

## Агрегации

Агрегации уменьшают данные: считают сумму, среднее, минимум, максимум и т.д.

```python
df["salary"].sum()     # сумма по столбцам
        .sum(axis=1)   # сумма по каждой строке
df["salary"].mean()    # среднее
df["salary"].median()  # медиана (устойчива к выбросам)
df["salary"].count()   # количество без NaN
df["salary"].size      # общее количество (включая NaN)
df["salary"].min()     # минимум
df["salary"].max()     # максимум
```

---

### size vs count

```python
df["salary"].count()
```
👉 считает только НЕ пустые значения

```python
df["salary"].size
```
👉 считает ВСЕ значения (включая NaN)

---

### size() в groupby

```python
df.groupby("name").size()
```

👉 считает количество строк в группе (включая NaN)

### round()

```python
df["salary"].mean().round(2)
```

Округление до 2 знаков после запятой.

Пример:

```python
round(3.14159, 2)
```

Результат:

```text
3.14
```

---

### value_counts()

```python
df["name"].value_counts()
```

Считает количество значений.

---

```python
df["name"].value_counts(normalize=True)
```

Считает доли.

---

#### Параметры

- `normalize=True` — доли вместо количества
- `sort=True` — сортировка
- `ascending=True` — по возрастанию
- `dropna=False` — учитывать NaN

---

#### Пример

```python
(df["name"].value_counts(normalize=True) * 100).round(2)
```

Проценты с округлением.

---

### nunique()

```python
df["name"].nunique()
```

Количество уникальных значений.

---

## Группировка groupby()

`groupby()` — как `GROUP BY` в SQL.

```python
df.groupby("name")["salary"].sum()
# сумма salary по каждому имени
```

```python
df.groupby("name")["salary"].mean()
# средняя salary по каждому имени
```

---

### Несколько агрегатов сразу

```python
df.groupby("name")["salary"].agg(["sum", "mean", "count"])
```

Результат:

```text
       sum   mean  count
name
Иван   250  125.0      2
Петр   200  200.0      1
```

---

## 📌 Новый синтаксис agg()

```python
df.groupby("name").agg(
    total_salary=("salary", "sum"),
    avg_salary=("salary", "mean"),
    count=("salary", "count")
)

       total_salary  avg_salary  count
name
Иван            250       125.0      2
Петр            200       200.0      1

---

### transform()

```python
df["salary_mean"] = df.groupby("name")["salary"].transform("mean")
```

Разница:

- `agg()` уменьшает таблицу
- `transform()` сохраняет размер таблицы

---

# Pivot и Melt в Pandas

`pivot()` и `melt()` нужны, чтобы менять форму таблицы.

- `pivot()` → делает таблицу **шире**
- `melt()` → делает таблицу **длиннее**

Проще:

```text
pivot: строки → колонки
melt:  колонки → строки
```

Они часто используются, когда нужно подготовить данные для анализа, сводных таблиц или графиков.

---

# 🔷 PIVOT — делает таблицу шире

## 📌 Базовая идея

`pivot()` берёт значения из одной колонки и превращает их в новые колонки.

---

## Было: long-format

```text
long-format = длинная таблица
```

| name | month | salary |
|------|-------|--------|
| Иван | Jan   | 100    |
| Иван | Feb   | 150    |
| Пётр | Jan   | 200    |

---

## Стало: wide-format

```text
wide-format = широкая таблица
```

| name | Jan | Feb |
|------|-----|-----|
| Иван | 100 | 150 |
| Пётр | 200 | NaN |

---

## 📌 Синтаксис pivot()

```python
df.pivot(index="name", columns="month", values="salary")
```
---

## 📌 Что означают параметры

### index — что идёт в строки
### columns — что становится колонками
### values — что лежит в ячейках

---

## 📌 Полный пример

```python
import pandas as pd

data = {
    "name": ["Иван", "Иван", "Пётр"],
    "month": ["Jan", "Feb", "Jan"],
    "salary": [100, 150, 200]
}

df = pd.DataFrame(data)

pivot_df = df.pivot(
    index="name",
    columns="month",
    values="salary"
)

print(pivot_df)
```

---

## 📌 Результат

```text
month    Feb    Jan
name
Иван   150.0  100.0
Пётр     NaN  200.0
```

Важно: Pandas может отсортировать колонки по-своему, поэтому `Feb` может оказаться перед `Jan`.

---

# ⚠️ Главная особенность pivot()

`pivot()` не умеет агрегировать данные.

Это значит: для одной пары `index + columns` должно быть только одно значение.

---

## ❌ Пример с ошибкой

| name | month | salary |
|------|-------|--------|
| Иван | Jan   | 100    |
| Иван | Jan   | 120    |
| Иван | Feb   | 150    |

Если написать:

```python
df.pivot(index="name", columns="month", values="salary")
```

будет ошибка, потому что Pandas не понимает, что поставить в ячейку:

```text
Иван + Jan = 100 или 120?
```

---

## ✔ Что делать, если есть дубли

Если есть дубли, используй `pivot_table()`.

---

# 🔷 PIVOT_TABLE — pivot с агрегацией

pivot_table() похож на pivot(), но умеет агрегировать дубли
pivot() требует уникальные значения, pivot_table() — нет

Например, если у Ивана за январь две записи:

| name | month | salary |
|------|-------|--------|
| Иван | Jan   | 100    |
| Иван | Jan   | 120    |
| Иван | Feb   | 150    |

Можно посчитать среднее:

```python
df.pivot_table(
    index="name",
    columns="month",
    values="salary",
    aggfunc="mean"
)
```
👉 если есть дубли, pivot() упадет, а pivot_table() справится
---

## 📌 Что означает `aggfunc`

`aggfunc` говорит Pandas, как объединять дубли.

Популярные варианты:

```python
aggfunc="mean"   # среднее
aggfunc="sum"    # сумма
aggfunc="count"  # количество
aggfunc="max"    # максимум
aggfunc="min"    # минимум
```

---


## 📌 margins=True

Добавляет итоговые значения (в зависимости от aggfunc)

```python
df.pivot_table(
    index="name",
    columns="month",
    values="salary",
    aggfunc="sum",
    margins=True
)
```

👉 добавляет строку и столбец с итогами (`All`)


## 📌 fill_value

```python
df.pivot_table(
    index="name",
    columns="month",
    values="salary",
    aggfunc="sum",
    fill_value=0
)
```

👉 заменяет NaN на 0

---


## 📌 Параметры pivot_table

- index — строки  
- columns — столбцы  
- values — значения  
- aggfunc — функция агрегации  
- margins — итоги  
- margins_name — название итогов  
- fill_value — заменить NaN  
- dropna — убрать пустые  
- sort — сортировка  


## 📌 margins_name

```python
pd.pivot_table(
    df,
    index="name",
    columns="month",
    values="salary",
    aggfunc="sum",
    margins=True,
    margins_name="Total"
)
```

👉 вместо `All` будет `Total`
---

## 📌 Пример pivot_table()

```python
import pandas as pd

data = {
    "name": ["Иван", "Иван", "Иван", "Пётр"],
    "month": ["Jan", "Jan", "Feb", "Jan"],
    "salary": [100, 120, 150, 200]
}

df = pd.DataFrame(data)

pivot_table_df = df.pivot_table(
    index="name",
    columns="month",
    values="salary",
    aggfunc="mean"
)

print(pivot_table_df)
```

---

## 📌 Результат

```text
month    Feb    Jan
name
Иван   150.0  110.0
Пётр     NaN  200.0
```

Почему у Ивана `Jan = 110`?

```text
(100 + 120) / 2 = 110
```

---

# 🔶 MELT — делает таблицу длиннее

## 📌 Базовая идея

`melt()` делает обратное действие: берёт несколько колонок и превращает их в строки.

---

## Было: wide-format

| name | Jan | Feb |
|------|-----|-----|
| Иван | 100 | 150 |
| Пётр | 200 | NaN |

---

## Стало: long-format

| name | month | salary |
|------|-------|--------|
| Иван | Jan   | 100    |
| Пётр | Jan   | 200    |
| Иван | Feb   | 150    |
| Пётр | Feb   | NaN    |

---

## 📌 Синтаксис melt()

```python
df.melt(
    id_vars="name",
    var_name="month",
    value_name="salary"
)
```

---

## 📌 Что означают параметры

### `id_vars="name"`

Колонка, которую нужно оставить как есть.

В примере:

```python
id_vars="name"
```

Значит, колонка `name` останется обычной колонкой.

---

### `var_name="month"`

Название новой колонки, куда попадут старые названия колонок.

В примере старые колонки:

```text
Jan
Feb
```

станут значениями в новой колонке:

```text
month
```

---

### `value_name="salary"`

Название новой колонки, куда попадут значения.

В примере значения:

```text
100
150
200
NaN
```

попадут в новую колонку:

```text
salary
```

---

## 📌 Полный пример melt()

```python
import pandas as pd

data = {
    "name": ["Иван", "Пётр"],
    "Jan": [100, 200],
    "Feb": [150, None]
}

df = pd.DataFrame(data)

long_df = df.melt(
    id_vars="name",
    var_name="month",
    value_name="salary"
)

print(long_df)
```

---

## 📌 Результат

```text
   name month  salary
0  Иван   Jan   100.0
1  Пётр   Jan   200.0
2  Иван   Feb   150.0
3  Пётр   Feb     NaN
```

---

# 🔥 Мини-шпаргалка

## ✔ pivot()

Используй, когда нужно сделать таблицу шире.

```python
df.pivot(
    index="row_key",
    columns="column_key",
    values="value"
)
```

---

## ✔ pivot_table()

Используй, когда нужно сделать таблицу шире, но есть дубли.

```python
df.pivot_table(
    index="row_key",
    columns="column_key",
    values="value",
    aggfunc="sum"
)
```

---

## ✔ melt()

Используй, когда нужно сделать таблицу длиннее.

```python
df.melt(
    id_vars="column_to_keep",
    var_name="new_column_with_old_column_names",
    value_name="new_column_with_values"
)
```

---

# ⚠️ Частые ошибки

## ❌ Ошибка 1: использовать pivot(), когда есть дубли

```python
df.pivot(index="name", columns="month", values="salary")
```

Если есть две строки:

```text
Иван | Jan | 100
Иван | Jan | 120
```

`pivot()` выдаст ошибку.

Решение:

```python
df.pivot_table(
    index="name",
    columns="month",
    values="salary",
    aggfunc="mean"
)
```

---

## ❌ Ошибка 2: забыть `values`

Иногда пишут:

```python
df.pivot(index="name", columns="month")
```

Так можно делать, но результат может стать сложнее, если в таблице много колонок.

Для новичка лучше явно писать:

```python
df.pivot(index="name", columns="month", values="salary")
```

---

## ❌ Ошибка 3: перепутать `var_name` и `value_name`

```python
df.melt(
    id_vars="name",
    var_name="month",
    value_name="salary"
)
```

Запомнить просто:

- `var_name` → название колонки с бывшими названиями колонок
- `value_name` → название колонки со значениями

---

# ✅ Когда что использовать

## Используй `pivot()`, если:

- нужно сделать таблицу шире
- категорию нужно превратить в колонки
- нет дублей по паре `index + columns`

---

## Используй `pivot_table()`, если:

- нужно сделать таблицу шире
- есть дубли
- нужно посчитать сумму, среднее, количество и т.д.

---

## Используй `melt()`, если:

- нужно сделать таблицу длиннее
- несколько колонок нужно собрать в одну
- готовишь данные для анализа или графиков
- нужно вернуть данные из wide-format в long-format

---

# Главное

```text
pivot()       = шире
pivot_table() = шире + агрегация
melt()        = длиннее
```


---

## Объединение таблиц

---

### concat (склеивание)

```python
pd.concat([df1, df2], axis=0)
```

- axis=0 — сверху  
- axis=1 — сбоку  

👉 просто объединяет таблицы без логики

---

### merge (как JOIN в SQL)

```python
pd.merge(df1, df2, on="id")
```

👉 соединить по колонке `id`

---

### Типы join

```python
pd.merge(df1, df2, on="id", how="left")
```
👉 left join — все строки из df1 + совпадения из df2  

```python
pd.merge(df1, df2, on="id", how="right")
```
👉 right join — все строки из df2 + совпадения из df1  

```python
pd.merge(df1, df2, on="id", how="inner")
```
👉 inner join — только совпадения  

```python
pd.merge(df1, df2, on="id", how="outer")
```
👉 outer join — все строки из обеих таблиц  

---

### Разные названия колонок

```python
pd.merge(df1, df2, left_on="id", right_on="user_id")
```

👉 если названия колонок отличаются

---

## Что запомнить

- concat — просто склеить  
- merge — соединить по ключу  
- how — тип join  
- left_on / right_on — если названия разные  

---

## Полезные методы

```python
df["name"].unique()
# уникальные значения
```

```python
df.reset_index(drop=True)
# сбросить индекс
```

```python
df.sort_index()
# сортировка по индексу
```

---

## Настройки отображения

```python
pd.set_option("display.max_rows", 100)
pd.set_option("display.max_columns", None)
```

---

## Что запомнить

- `df["col"]` — выбрать столбец
- `df[условие]` — фильтрация
- `query()` — удобный фильтр
- `rename()` — переименование колонок
- `columns.str` — массовая очистка названий
- `fillna()` / `dropna()` — работа с пропусками
- `astype()` / `to_datetime()` — преобразование типов
- `sum()` / `mean()` / `count()` — агрегации
- `value_counts()` — частоты значений
- `groupby()` — группировка
- `merge()` — объединение таблиц
- `pivot()` / `melt()` — изменение формы таблицы
