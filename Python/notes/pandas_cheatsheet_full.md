# Pandas: полная шпаргалка

---

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

# 1. Загрузка данных

## CSV

```python
df = pd.read_csv("data.csv")
```

Самый популярный формат, разделитель — `,`.

## Excel

```python
df = pd.read_excel("data.xlsx")
```

---

# 2. Быстрый осмотр данных

```python
df.head()       # первые 5 строк
df.tail()       # последние 5 строк
df.shape        # размер: (строки, столбцы)
df.columns      # названия колонок
df.dtypes       # типы данных
df.info()       # типы данных и количество пропусков
df.describe()   # статистика по числовым колонкам
```

---

# 3. Выбор данных

## Столбцы

```python
df["name"]           # один столбец
df[["name", "age"]]  # несколько столбцов
```

## loc — по названию индекса

```python
df.loc[0]              # строка по индексу
df.loc[0, "name"]      # конкретная ячейка
df.loc[df["age"] > 18] # по условию
```

## iloc — по позиции

```python
df.iloc[0]    # первая строка
df.iloc[0, 1] # строка 0, столбец 1
```

---

# 4. Фильтрация

```python
df[df["age"] > 18]
```

## Несколько условий

```python
df[(df["age"] > 18) & (df["salary"] > 100)]
```

- `&` — И
- `|` — ИЛИ
- каждое условие в скобках ← обязательно!

## isin

```python
df[df["city"].isin(["Moscow", "SPB"])]
```

Фильтр по списку значений.

## between

```python
df[df["age"].between(18, 60)]
```

Диапазон значений.

## query

```python
df.query("age > 18 and salary > 100")
```

Поддерживает переменные Python через `@`:

```python
min_age = 25
df.query("age > @min_age")
```

---

# 5. Сортировка

```python
df.sort_values("salary")                          # по возрастанию
df.sort_values("salary", ascending=False)         # по убыванию
df.sort_values(["age", "salary"], ascending=[True, False])  # по нескольким колонкам
df.sort_index()                                   # по индексу
```

---

# 6. Создание и переименование колонок

## Новый столбец

```python
df["bonus"] = df["salary"] * 0.1  # векторизация — самый быстрый способ
```

## assign (удобно в цепочках)

```python
df = df.assign(bonus=df["salary"] * 0.1)
```

## Переименование

```python
df = df.rename(columns={"name": "user_name"})

df = df.rename(columns={
    "name": "user_name",
    "age": "user_age"
})

df.columns = ["user_name", "user_age", "salary"]  # полная замена всех названий
```

## Очистка названий колонок

```python
df.columns = (
    df.columns
    .str.strip()           # убрать пробелы по краям
    .str.lower()           # привести к нижнему регистру
    .str.replace(" ", "_") # заменить пробелы на _
)
# " User Name " → "user_name"
```

---

# 7. Работа с текстом (.str)

`.str` — доступ к строковым методам Series (работает только со строками).

## Регистр

```python
df["name"].str.lower()   # нижний регистр: IVAN → ivan
df["name"].str.upper()   # верхний регистр: ivan → IVAN
df["name"].str.title()   # каждое слово с большой: ivan petrov → Ivan Petrov
```

## Пробелы

```python
df["name"].str.strip()   # убрать пробелы по краям: '  ivan  ' → 'ivan'
df["name"].str.lstrip()  # убрать слева
df["name"].str.rstrip()  # убрать справа
```

## Поиск

```python
df["email"].str.contains("gmail", na=False)  # содержит ли (na=False — NaN не вызовет ошибку)
df["email"].str.startswith("admin")          # начинается ли
df["file"].str.endswith(".csv")              # заканчивается ли
```

## Замена и разделение

```python
df["phone"].str.replace("-", "")            # замена символов
df["email"].str.split("@")                  # разбить строку
df["email"].str.split("@", expand=True)     # разбить сразу на колонки
```

## Извлечение и длина

```python
df["email"].str.extract(r"@([\w.]+)")  # извлечь часть через regex
df["name"].str.len()                   # длина строки: ivan → 4
df["name"].str.slice(0, 3)             # символы с 0 по 3: ivan → iva
df["name"].str[0]                      # первый символ: ivan → i
```

## Проверки

```python
df["col"].str.isdigit()  # только цифры: 123 → True, 12a → False
df["col"].str.isalpha()  # только буквы: ivan → True, ivan123 → False
df["col"].str.isalnum()  # буквы + цифры: ivan123 → True, ivan_123 → False
```

---

# 8. .map() — преобразование значений

`.map()` применяется к одному столбцу (Series).

## Замена через словарь (самый частый сценарий)

```python
df["sex"].map({"M": "Male", "F": "Female"})
# M → Male, F → Female
```

⚠️ Если значения нет в словаре → будет `NaN`. Защита:

```python
df["sex"].map({"M": "Male", "F": "Female"}).fillna("Unknown")
```

## Через lambda

```python
df["price"].map(lambda x: x * 100)               # числа: 0.15 → 15
df["name"].map(lambda x: x.upper())               # текст: ivan → IVAN
df["age"].map(lambda x: "adult" if x >= 18 else "child")  # категоризация
df["salary"].map(lambda x: x / 1000)
```

## map() vs replace()

| Метод | Особенность |
|---|---|
| `map()` | только Series; отсутствующие значения → NaN |
| `replace()` | Series и DataFrame; не найденные значения остаются как есть |

---

# 9. apply() и lambda

`apply()` применяет функцию к каждому элементу.

```python
df["status"] = df["age"].apply(lambda x: "adult" if x >= 18 else "child")  # с условием
df.apply(lambda row: row["age"] * 2, axis=1)  # по строкам (axis=1), по колонкам (axis=0)
```

⚠️ `apply()` медленнее обычных операций. Если можно сделать через `+ - * /` — делай без `apply()`.

---

# 10. Работа с пропусками (NaN)

## Найти

```python
df.isna()          # True/False для каждой ячейки
df.isna().sum()    # количество NaN по колонкам
```

## Заполнить

```python
df.fillna(0)                                      # заменить на 0
df["age"].fillna(df["age"].mean())                # заполнить средним
```

## Удалить

```python
df.dropna()                   # строки с любым NaN
df.dropna(subset=["age"])     # строки, где NaN в колонке age
```

---

# 11. Работа с дубликатами

```python
df.duplicated().sum()              # количество дублей
df.drop_duplicates()               # удалить дубли
df.drop_duplicates(subset=["email"])  # дубли по конкретной колонке
```

---

# 12. Преобразование типов

```python
df["age"] = df["age"].astype(float)              # к float
df["city"] = df["city"].astype("category")       # категориальный тип

df["salary"] = pd.to_numeric(df["salary"], errors="coerce")
# errors="coerce" → невалидные значения станут NaN

df["date"] = pd.to_datetime(df["date"], errors="coerce")
# errors="coerce" → невалидные даты станут NaT
```

## pd.to_datetime() подробнее

После преобразования доступны методы `.dt`:

```python
df["year"]    = df["date"].dt.year
df["month"]   = df["date"].dt.month
df["day"]     = df["date"].dt.day
df["weekday"] = df["date"].dt.day_name()
```

Ускорение через явный формат:

```python
pd.to_datetime(df["date"], format="%Y-%m-%d")
```

---

# 13. Агрегации

```python
df["salary"].sum()     # сумма
df["salary"].mean()    # среднее
df["salary"].median()  # медиана (устойчива к выбросам)
df["salary"].min()     # минимум
df["salary"].max()     # максимум
df["salary"].count()   # количество без NaN
df["salary"].size      # количество со всеми значениями (включая NaN)
df["salary"].mean().round(2)  # округление до 2 знаков
```

> `count()` — не считает NaN. `size` — считает всё.

---

# 14. Частоты

```python
df["city"].value_counts()                         # количество
df["city"].value_counts(normalize=True)           # доли
(df["city"].value_counts(normalize=True) * 100).round(2)  # проценты
df["city"].nunique()                              # количество уникальных значений
df["city"].unique()                               # сами уникальные значения
```

Параметры `value_counts()`: `sort=True`, `ascending=True`, `dropna=False`.

---

# 15. GroupBy

## Простая агрегация

```python
df.groupby("city")["salary"].mean()
df.groupby("name")["salary"].sum()
df.groupby("name").size()  # количество строк в группе (включая NaN)
```

## Несколько агрегатов — старый синтаксис

```python
df.groupby("name")["salary"].agg(["sum", "mean", "count"])
```

## Несколько агрегатов — новый синтаксис (предпочтительно)

```python
df.groupby("city").agg(
    avg_salary=("salary", "mean"),
    max_salary=("salary", "max"),
    count=("salary", "count")
)
```

---

# 16. Transform

Когда нужно сохранить размер таблицы (в отличие от `agg()`, который уменьшает).

```python
df["city_avg"] = df.groupby("city")["salary"].transform("mean")
```

Доля сотрудника от суммы отдела:

```python
total = df.groupby("department")["salary"].transform("sum")
df["share"] = df["salary"] / total
```

---

# 17. Merge (JOIN)

Аналог SQL JOIN.

```python
pd.merge(df1, df2, on="id", how="left")   # left — все из df1 + совпадения из df2
pd.merge(df1, df2, on="id", how="right")  # right — все из df2 + совпадения из df1
pd.merge(df1, df2, on="id", how="inner")  # inner — только совпадения
pd.merge(df1, df2, on="id", how="outer")  # outer — все строки из обеих таблиц
```

Если названия колонок отличаются:

```python
pd.merge(df1, df2, left_on="id", right_on="user_id")
```

---

# 18. Concat

```python
pd.concat([df1, df2], axis=0)  # склеить по строкам (сверху вниз)
pd.concat([df1, df2], axis=1)  # склеить по столбцам (сбоку)
```

`concat` просто объединяет таблицы без логики, `merge` — соединяет по ключу.

---

# 19. Pivot, Pivot Table, Melt

Инструменты для изменения формы таблицы:

```text
pivot()       = шире (строки → колонки)
pivot_table() = шире + агрегация
melt()        = длиннее (колонки → строки)
```

## pivot() — сделать таблицу шире

```python
df.pivot(index="name", columns="month", values="salary")
```

Было (long-format):

| name | month | salary |
|------|-------|--------|
| Иван | Jan   | 100    |
| Иван | Feb   | 150    |
| Пётр | Jan   | 200    |

Стало (wide-format):

| name | Jan | Feb |
|------|-----|-----|
| Иван | 100 | 150 |
| Пётр | 200 | NaN |

⚠️ `pivot()` не умеет агрегировать. Для одной пары `index + columns` должно быть только одно значение, иначе — ошибка.

## pivot_table() — шире + агрегация

Используй вместо `pivot()`, если есть дубли.

```python
df.pivot_table(
    index="name",
    columns="month",
    values="salary",
    aggfunc="mean"   # mean / sum / count / max / min
)
```

Дополнительные параметры:

```python
margins=True          # добавить итоговую строку/столбец
margins_name="Total"  # название итогов вместо "All"
fill_value=0          # заменить NaN на 0
```

## melt() — сделать таблицу длиннее

```python
df.melt(
    id_vars="name",       # колонки, которые остаются как есть
    var_name="month",     # название колонки с бывшими заголовками
    value_name="salary"   # название колонки со значениями
)
```

Используй, когда нужно подготовить данные для анализа или графиков (из wide-format в long-format).

---

# 20. Полезные методы

```python
df.reset_index(drop=True)  # сбросить индекс
pd.set_option("display.max_rows", 100)     # настройка отображения
pd.set_option("display.max_columns", None)
```

---

# 21. Частые ошибки

❌ Условия без скобок:

```python
df["age"] > 18 & df["salary"] > 100
```

✅

```python
(df["age"] > 18) & (df["salary"] > 100)
```

---

❌ apply() там, где не нужно:

```python
df["salary"].apply(lambda x: x * 2)
```

✅ Векторизация почти всегда быстрее:

```python
df["salary"] * 2
```

---

❌ `pivot()` при наличии дублей → ошибка.

✅ Используй `pivot_table()`.

---

❌ Забыть `values` в `pivot()` — может дать неожиданный результат при многих колонках. Лучше указывать явно:

```python
df.pivot(index="name", columns="month", values="salary")
```

---

# 22. Рабочий алгоритм аналитика

```python
df = pd.read_csv(...)

df.head()
df.info()

df.isna().sum()
df.duplicated().sum()

# очистка данных

df.groupby(...)

df.pivot_table(...)

df.to_excel(...)
```

---

# Быстрая шпаргалка

| Задача | Метод |
|---|---|
| Выбрать столбец | `df["col"]` |
| Фильтрация | `df[условие]` |
| Удобный фильтр | `query()` |
| Переименовать | `rename()` |
| Очистить названия | `columns.str` |
| Пропуски | `fillna()` / `dropna()` |
| Типы | `astype()` / `to_datetime()` |
| Агрегации | `sum()` / `mean()` / `count()` |
| Частоты | `value_counts()` |
| Группировка | `groupby()` |
| Добавить агрегат к строке | `transform()` |
| Объединить таблицы | `merge()` / `concat()` |
| Таблица шире | `pivot()` / `pivot_table()` |
| Таблица длиннее | `melt()` |
| Замена значений | `map()` / `replace()` |
