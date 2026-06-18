# 📊 Seaborn — шпаргалка

Seaborn — библиотека для статистической визуализации поверх matplotlib.
Меньше кода, красивее по умолчанию, умеет агрегировать сам.

---

## Подключение

```python
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
```

---

## 🗺️ Какой график выбрать?

| Задача | График |
|--------|--------|
| Посмотреть распределение одной переменной | `displot` |
| Сравнить распределения / выбросы по группам | `boxplot` |
| Найти зависимость между двумя переменными | `scatterplot` |
| Показать тренд / временной ряд | `lineplot` |
| Сравнить среднее (агрегат) по категориям | `barplot` |
| Посчитать количество по категориям | `countplot` |
| Увидеть все зависимости сразу | `pairplot` |

---

## Загрузка тестовых данных

```python
df = sns.load_dataset("penguins")   # встроенный датасет
df.head()
```

---

## 📉 `displot` — распределение

```python
sns.displot(
    data=df,
    x="flipper_length_mm",
    bins=20,
    hue="species",    # цвет по категории
    col="island"      # отдельный график на каждый остров
)
```

| Параметр | Что делает |
|----------|------------|
| `bins` | количество столбиков |
| `hue` | разбивка по цвету |
| `col` / `row` | разбивка на отдельные графики |
| `kind` | `"hist"` / `"kde"` / `"ecdf"` |

> ⚠️ `displot` — **fig-level** функция, создаёт свою фигуру. Нельзя передать `ax=`.  
> Для вставки в subplot используйте `histplot` вместо `displot`.

---

## 📍 `scatterplot` — зависимость двух переменных

```python
sns.scatterplot(
    data=df,
    x="flipper_length_mm",
    y="bill_length_mm",
    hue="species",    # цвет по категории
    size="body_mass_g",  # размер точки по значению
    s=60,             # базовый размер точек
    alpha=0.7         # прозрачность
)
```

> 👉 Используйте, чтобы найти корреляцию или кластеры.  
> ⚠️ При большом кол-ве точек добавьте `alpha=0.3` — иначе точки сливаются.

---

## 📈 `lineplot` — тренд / временной ряд

```python
sns.lineplot(
    data=df,
    x="bill_length_mm",
    y="flipper_length_mm",
    hue="species",    # отдельная линия на категорию
    style="species",  # стиль линии (пунктир и т.д.)
    markers=True,     # точки на линии
    dashes=False      # сплошные линии
)
```

> ⚠️ `lineplot` по умолчанию **агрегирует** повторяющиеся значения x (берёт среднее + рисует доверительный интервал).  
> Чтобы отключить интервал: `errorbar=None`.

---

## 📊 `barplot` — среднее (агрегат) по категориям

```python
sns.barplot(
    data=df,
    x="species",
    y="flipper_length_mm",
    hue="sex",          # разбивка по второй категории
    estimator="mean",   # функция агрегации (mean / median / sum)
    errorbar="ci"       # 95% доверительный интервал (по умолчанию)
)
```

> 👉 `barplot` сам считает агрегат — не нужен `groupby`.  
> ⚠️ Показывает только среднее. Если важен разброс и выбросы — используйте `boxplot`.

**barplot vs countplot:**
```
barplot   → агрегирует значения (mean, sum…)
countplot → просто считает строки
```

---

## 📦 `boxplot` — разброс, квартили, выбросы

```python
sns.boxplot(
    data=df,
    x="species",
    y="flipper_length_mm",
    hue="sex"
)
```

Что показывает ящик:

```
      ┌─────────────────┐
──────┤  Q1 (25%)       ├──────  ← медиана (линия внутри)
      │                 │
──────┤  Q3 (75%)       ├──────
      └─────────────────┘
  ○                          ← выброс (точка за усами)
```

> 👉 Лучший выбор когда нужно сравнить **распределения** нескольких групп.

---

## 🔢 `countplot` — количество по категориям

```python
sns.countplot(
    data=df,
    x="species",
    hue="sex",
    order=df["species"].value_counts().index  # сортировка по убыванию
)
```

> 👉 Аналог `value_counts()` в виде графика. Агрегация не нужна.

---

## 🔗 `pairplot` — все зависимости сразу

```python
sns.pairplot(
    df,
    hue="species",
    diag_kind="kde",   # на диагонали: "hist" или "kde"
    corner=True        # только нижний треугольник (быстрее)
)
```

> 👉 Удобен для **быстрого EDA** — сразу видно корреляции и кластеры.  
> ⚠️ При большом числе колонок работает медленно.

---

## 🪟 Разбивка на подграфики

```python
# col — отдельный график для каждой категории
sns.displot(data=df, x="flipper_length_mm", col="species")

# col + row — сетка графиков
sns.displot(data=df, x="flipper_length_mm", col="species", row="sex")
```

> ⚠️ `col` / `row` работают только у **fig-level** функций:  
> `displot`, `relplot`, `catplot`, `lmplot`.  
> Для **axes-level** (`histplot`, `scatterplot`, `boxplot`…) используйте `plt.subplots`.

---

## 🎨 Внешний вид

### Стиль и палитра

```python
sns.set_theme(style="whitegrid")   # стиль фона: darkgrid / whitegrid / white / ticks
sns.set_palette("tab10")           # цветовая палитра

# Популярные палитры:
# "tab10"     — яркие различимые цвета (по умолчанию)
# "Set2"      — пастельные
# "viridis"   — последовательная (для числовых hue)
# "RdYlGn"    — дивергентная (красный → жёлтый → зелёный)
```

### Заголовки и подписи осей

```python
ax = sns.barplot(data=df, x="species", y="flipper_length_mm")

ax.set_title("Длина плавников по видам", fontsize=14)
ax.set_xlabel("Вид пингвина")
ax.set_ylabel("Длина плавника (мм)")
plt.tight_layout()
plt.show()
```

### Размер фигуры

```python
plt.figure(figsize=(10, 5))        # для axes-level функций
sns.boxplot(data=df, x="species", y="flipper_length_mm")
plt.show()
```

---

## 🧩 Несколько графиков на одном холсте

```python
import matplotlib.pyplot as plt

fig, axes = plt.subplots(3, 1, figsize=(12, 15))

sns.lineplot(data=df_report, x="date", y="orders",        ax=axes[0], marker="o")
sns.lineplot(data=df_report, x="date", y="revenue",       ax=axes[1], marker="o")
sns.lineplot(data=df_report, x="date", y="avg_check",     ax=axes[2], marker="o")

titles = ["Заказы", "Выручка за день", "Средний чек за день"]
for ax, title in zip(axes, titles):
    ax.set_title(title, fontsize=13)
    ax.set_xlabel("")              # убираем подпись оси X (она очевидна)
    ax.tick_params(axis="x", rotation=45)

plt.tight_layout()
plt.show()
```

> 💡 Передавайте `ax=axes[i]` — это ключевой параметр для вставки seaborn-графика в нужную ячейку.

---

## ⚡ Быстрая шпаргалка

```
displot      → распределение одной переменной
scatterplot  → зависимость X от Y
lineplot     → тренд, временной ряд
barplot      → среднее по категориям (сам агрегирует)
countplot    → количество по категориям (не агрегирует)
boxplot      → разброс, медиана, выбросы
pairplot     → все связи сразу (EDA)

hue          → разбивка по цвету
col / row    → разбивка на отдельные графики (fig-level only)
ax=          → вставка в subplot (axes-level only)
```

---

## ❌ Частые ошибки

| Ошибка | Решение |
|--------|---------|
| `displot` не принимает `ax=` | Используйте `histplot` вместо `displot` |
| `col=` не работает у `boxplot` | Оберните в `catplot(kind="box")` |
| Точки на scatterplot сливаются | Добавьте `alpha=0.3` |
| lineplot рисует интервал, а нужна чистая линия | Добавьте `errorbar=None` |
| Легенда перекрывает график | `plt.legend(bbox_to_anchor=(1.05, 1), loc="upper left")` |
