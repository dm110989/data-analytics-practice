# Pandas

---

# 1. Загрузка данных

## CSV

```python
df = pd.read_csv("data.csv")
```

Описание:
- Самый популярный формат данных.
- Обычно используется разделитель ",".

## Excel

```python
df = pd.read_excel("data.xlsx")
```

---

# 2. Быстрый осмотр данных

```python
df.head()
```
Первые 5 строк.

```python
df.tail()
```
Последние 5 строк.

```python
df.shape
```
Размер таблицы `(строки, столбцы)`.

```python
df.info()
```
Типы данных, количество пропусков.

```python
df.describe()
```
Статистика по числовым колонкам.

---

# 3. Выбор данных

## Столбцы

```python
df["name"]
```

Одна колонка.

```python
df[["name", "age"]]
```

Несколько колонок.

## loc

Работает по названию индекса.

```python
df.loc[0]
```

```python
df.loc[0, "name"]
```

```python
df.loc[df["age"] > 18]
```

## iloc

Работает по позиции.

```python
df.iloc[0]
```

```python
df.iloc[0, 1]
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

Важно:
- & = И
- | = ИЛИ
- каждое условие в скобках

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

Удобная запись сложных фильтров.

---

# 5. Сортировка

```python
df.sort_values("salary")
```

По возрастанию.

```python
df.sort_values("salary", ascending=False)
```

По убыванию.

---

# 6. Создание новых колонок

## Векторизация (предпочтительно)

```python
df["bonus"] = df["salary"] * 0.1
```

Самый быстрый способ.

## assign

```python
df = df.assign(
    bonus=df["salary"] * 0.1
)
```

Удобно в цепочках методов.

---

# 7. Работа с текстом

## Очистка

```python
df["name"].str.strip()
```

Убрать пробелы.

```python
df["name"].str.lower()
```

Нижний регистр.

```python
df["name"].str.upper()
```

Верхний регистр.

## Поиск

```python
df["email"].str.contains("gmail", na=False)
```

---

# 8. Работа с пропусками

## Найти

```python
df.isna().sum()
```

Количество NaN по колонкам.

## Заполнить

```python
df["age"] = df["age"].fillna(df["age"].mean())
```

## Удалить

```python
df.dropna()
```

---

# 9. Работа с дубликатами

## Найти

```python
df.duplicated().sum()
```

## Удалить

```python
df.drop_duplicates()
```

```python
df.drop_duplicates(subset=["email"])
```

---

# 10. Преобразование типов

## Число

```python
df["salary"] = pd.to_numeric(
    df["salary"],
    errors="coerce"
)
```

## Дата
## pd.to_datetime()

Преобразует строку (или столбец строк) в тип даты `datetime`.

```python
df["date"] = pd.to_datetime(
    df["date"],
    errors="coerce"
)
```

### Что делает

Было:

```text
2024-01-15
2024-02-20
2024-03-10
```

После:

```text
2024-01-15 00:00:00
2024-02-20 00:00:00
2024-03-10 00:00:00
```

Тип данных меняется со строки (`object`) на дату (`datetime64[ns]`).

### Зачем нужно

После преобразования становятся доступны методы работы с датами:

```python
df["date"].dt.year
```

Получить год.

```python
df["date"].dt.month
```

Получить месяц.

```python
df["date"].dt.day
```

Получить день месяца.

```python
df["date"].dt.day_name()
```

Получить день недели.

### Параметр errors

```python
errors="coerce"
```

Если Pandas встретит неправильную дату, ошибка не возникнет.

Невалидное значение будет заменено на `NaT`
(DateTime-аналог `NaN`).

Пример:

```python
df["date"] = pd.to_datetime(
    df["date"],
    errors="coerce"
)
```

Было:

```text
2024-01-01
не дата
2024-03-15
```

Стало:

```text
2024-01-01
NaT
2024-03-15
```

### Ускорение через format

Если формат известен заранее:

```python
pd.to_datetime(
    df["date"],
    format="%Y-%m-%d"
)
```

Pandas будет работать быстрее и строже проверять данные.

### Что запомнить

- `pd.to_datetime()` — превращает строку в дату.
- `.dt` — доступ к частям даты.
- `errors="coerce"` — безопасно превращает ошибки в `NaT`.
- `format=` — ускоряет обработку и помогает контролировать формат данных.

## Категория

```python
df["city"] = df["city"].astype("category")
```

---


# 12. Агрегации

```python
df["salary"].sum()
```

Сумма.

```python
df["salary"].mean()
```

Среднее.

```python
df["salary"].median()
```

Медиана.

```python
df["salary"].count()
```

Без NaN.

```python
df["salary"].size
```

Со всеми значениями.

```python
round(df["salary"].mean(), 2)
```

Округление.

---

# 13. Частоты

```python
df["city"].value_counts()
```

Количество.

```python
df["city"].value_counts(normalize=True)
```

Доли.

---

# 14. GroupBy

## Простая агрегация

```python
df.groupby("city")["salary"].mean()
```

## Несколько агрегатов

```python
df.groupby("city").agg(
    avg_salary=("salary", "mean"),
    max_salary=("salary", "max"),
    count=("salary", "count")
)
```

Современный и читаемый синтаксис.

---

# 15. Transform

Когда нужно сохранить размер таблицы.

```python
df["city_avg"] = (
    df.groupby("city")["salary"]
      .transform("mean")
)
```

Доля сотрудника от суммы отдела:

```python
total = (
    df.groupby("department")["salary"]
      .transform("sum")
)

df["share"] = df["salary"] / total
```

---

# 16. Merge

Аналог SQL JOIN.

```python
pd.merge(
    customers,
    orders,
    on="id",
    how="left"
)
```

Типы:
- left
- right
- inner
- outer

---

# 17. Concat

```python
pd.concat([df1, df2])
```

Просто склеивает таблицы.

---

# 18. Pivot Table

Главный инструмент аналитика.

```python
df.pivot_table(
    index="city",
    values="salary",
    aggfunc="mean"
)
```

Если есть дубли — используем pivot_table, а не pivot.

---

# 19. Частые ошибки

❌

```python
df["age"] > 18 & df["salary"] > 100
```

✅

```python
(df["age"] > 18) & (df["salary"] > 100)
```

---

❌

```python
df["salary"].apply(lambda x: x * 2)
```

✅

```python
df["salary"] * 2
```

Векторизация почти всегда быстрее.

---

❌ Использовать pivot() при дублях

✅ Использовать pivot_table()

---

# 20. Рабочий алгоритм аналитика

```python
df = pd.read_csv(...)

df.head()
df.info()

df.isna().sum()
df.duplicated().sum()

# очистка

df.groupby(...)

df.pivot_table(...)

df.to_excel(...)
```
