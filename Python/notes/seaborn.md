# 📊 Seaborn (красивые графики)

Seaborn — библиотека для статистической визуализации (поверх matplotlib)

---

## Подключение

```python
import seaborn as sns
import pandas as pd
```

---

## Данные (пример)

```python
df = sns.load_dataset("penguins")
```

---

## Основные типы графиков

```python
sns.displot()        # распределение (гистограмма)
sns.scatterplot()    # зависимость
sns.boxplot()        # разброс
sns.countplot()      # категории (количество)
sns.barplot()        # агрегированные значения
sns.pairplot()       # все связи
```

---

### **📊 sns.barplot() — агрегированные значения**

```python
sns.barplot(
    data=df,
    x="species",
    y="flipper_length_mm"
)

```
Основные параметры:

- x — категория
- y — значения
- hue — разбивка по второй категории
- estimator — функция агрегации (по умолчанию mean)
- errorbar — отображение интервала ошибки/разброса  
  по умолчанию показывает 95% доверительный интервал

👉 показывает среднее (или другую агрегацию) по категориям
👉 сам считает агрегат (не нужно groupby)

barplot → агрегирует (mean, sum и т.д.)
countplot → считает количество

⚠️ barplot показывает только среднее/агрегат.  
Если важен разброс и выбросы — лучше использовать boxplot.

---

# 📈 sns.lineplot() — линия / тренд

```python
sns.lineplot(
    data=df,
    x="bill_length_mm",
    y="flipper_length_mm"
)
```

### Основные параметры:

- x, y — данные
- hue — разделение по категориям
- style — стиль линий
- markers=True — показать точки
- dashes=False — сплошные линии

Пример:

```python
sns.lineplot(
    data=df,
    x="bill_length_mm",
    y="flipper_length_mm",
    hue="species",
    markers=True
)
```

👉 показывает изменение / тренд  
👉 часто используется для временных рядов

⚠️ lineplot по умолчанию агрегирует значения по x  
(обычно среднее)

---
### **📉 sns.displot() — распределение**

```python
sns.displot(data=df, x="flipper_length_mm", bins=20)
```

Основные параметры:

- x — данные  
- bins — количество столбиков  
- hue — разбивка по категории  

👉 показывает распределение значений  
👉 fig-level функция (создает отдельную фигуру)

---

### **📍 sns.scatterplot() — зависимость**

```python
sns.scatterplot(
    data=df,
    x="flipper_length_mm",
    y="bill_length_mm",
    hue="species",
    s=50
)
```

Основные параметры:

- x, y — данные  
- hue — цвет по категории  
- s — размер точек  

👉 показывает зависимость между переменными  

---

### **📊 sns.boxplot() — разброс**

```python
sns.boxplot(
    data=df,
    x="species",
    y="flipper_length_mm"
)
```

Основные параметры:

- x — категория  
- y — значения  

👉 показывает:
- медиану  
- разброс  
- квартили Q1 / Q3 — 25% и 75%  
- выбросы  

---

### **📊 sns.countplot() — количество по категориям**

```python
sns.countplot(data=df, x="species")
```

Основные параметры:

- x — категория  
- hue — разбивка по второй категории  
- order — порядок категорий  

👉 считает количество значений  
👉 аналог value_counts() в виде графика  
👉 не требует агрегации  

---

### **📊 sns.pairplot() — все зависимости**

```python
sns.pairplot(df, hue="species")
```

👉 показывает:
- все зависимости между переменными  
- распределения по диагонали  

---

## Разделение на графики

```python
sns.displot(
    data=df,
    x="flipper_length_mm",
    col="species"
)
```

- col — отдельный график для каждой категории  

---

## Что запомнить

- displot → распределение  
- scatterplot → зависимость  
- boxplot → разброс  
- countplot → категории  
- pairplot → всё сразу  
- hue → цвет по категории  
- col → разбивка на графики  