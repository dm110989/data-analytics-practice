# 📊 Matplotlib (база)

Matplotlib — библиотека для построения графиков

---

## Подключение

```python
import matplotlib.pyplot as plt
```

---

## Простой график

```python
x = [1, 2, 3, 4]
y = [2, 3, 4, 5]

plt.plot(x, y)
plt.show()
```

---

## Заголовок и подписи

```python
plt.plot(x, y)

plt.title("График")
plt.xlabel("Ось X")
plt.ylabel("Ось Y")

plt.show()
```

---

## Сетка

```python
plt.grid()
```

---

## Цвет и стиль

```python
plt.plot(x, y, 'r--')  
```

- r — красный  
- -- — пунктир  

---

## Маркеры

```python
plt.plot(x, y, 'bo-')
```

- b — синий  
- o — точки  

---

## Легенда

```python
plt.plot(x, y, label="Линия")

plt.legend()
```

---

## Несколько графиков

```python
plt.plot(x, y, label="1")
plt.plot(x, [i**2 for i in x], label="2")

plt.legend()
plt.show()
```

---

## Границы осей

```python
plt.axis([0, 5, 0, 10])
```

---

## Несколько графиков (subplots)

```python
fig, axs = plt.subplots(2, 2)

axs[0, 0].plot(x, y)
axs[0, 1].plot(x, y)
```

---

## Основные типы графиков

```python
plt.plot()      # линия
plt.scatter()   # точки
plt.bar()       # столбцы
plt.hist()      # гистограмма
```

---

## Что запомнить

- plt.plot() — линия  
- plt.title() — заголовок  
- plt.xlabel() / ylabel() — подписи  
- plt.legend() — легенда  
- plt.grid() — сетка  
- plt.subplots() — несколько графиков  


## Параметры графиков

---

## 📊 plt.subplot() — несколько графиков

```python
plt.subplot(1, 2, 1)
```

Основные параметры:

- nrows — количество строк  
- ncols — количество столбцов  
- index — номер графика (начинается с 1)  

---

## Как работает

```python
plt.subplot(1, 2, 1)  # первый график (слева)
plt.subplot(1, 2, 2)  # второй график (справа)
```

👉 формат: `subplot(строки, столбцы, номер)`

---

## Пример

```python
import matplotlib.pyplot as plt

plt.subplot(1, 2, 1)
plt.plot([1, 2, 3])
plt.title("График 1")

plt.subplot(1, 2, 2)
plt.plot([3, 2, 1])
plt.title("График 2")

plt.show()
```

---

## Упрощённая запись

```python
plt.subplot(121)
plt.subplot(122)
```

👉 это то же самое:

- 121 → 1 строка, 2 столбца, 1 график  
- 122 → 1 строка, 2 столбца, 2 график  

---

## Что запомнить

- subplot → выбрать место для графика  
- index начинается с 1  

### **📈 plt.plot() — линия**

```python
plt.plot(x, y, color="blue", linestyle="--", linewidth=2, label="Линия")
```

Основные параметры:

- x, y — данные  
- color — цвет (`"red"`, `"blue"`, `"green"`)  
- linestyle — стиль линии (`"-"`, `"--"`, `":"`)  
- linewidth — толщина линии  
- label — название (для легенды)  

---

### **📍 plt.scatter() — точки**

```python
plt.scatter(x, y, color="red", s=50, alpha=0.7)
```

Основные параметры:

- x, y — данные  
- color — цвет  
- s — размер точек  
- alpha — прозрачность (0–1)  

---

### **📊 plt.bar() — столбцы**

```python
plt.bar(x, y, color="green", width=0.5)
```

Основные параметры:

- x — категории  
- y — значения  
- color — цвет  
- width — ширина столбцов  

---

### 📊 **plt.barh() — горизонтальные столбцы**

```python
plt.barh(x, y, color="green")
```

- x — категории (по оси Y)  
- y — значения (длина столбцов)  
- color — цвет  
- height → толщина столбца

👉 столбцы растут вправо

---

### **📉 plt.hist() — гистограмма**

```python
plt.hist(data, bins=10, color="blue", alpha=0.7)
```

Основные параметры:

- data — данные  
- bins — количество столбиков  
- color — цвет  
- alpha — прозрачность  
- rwidth — уменьшает ширину столбиков (появляется расстояние между ними)
---

## Общие параметры графиков

```python
plt.figure(figsize=(10, 6))   # размер графика (ширина, высота) в дюймах

plt.plot(x, y, label="Линия") # label нужен для легенды

plt.title("Заголовок")        # заголовок графика
plt.suptitle("Общий заголовок")  # общий заголовок для нескольких графиков (figure)

plt.xlabel("X")               # подпись оси X
plt.ylabel("Y")               # подпись оси Y

plt.xlim(0, 10)               # границы оси X
plt.ylim(0, 100)              # границы оси Y

plt.xticks(rotation=45, ha='right')  # поворот и выравнивание подписей по оси X

plt.legend()                  # легенда (нужен label в plot)
plt.grid()                    # сетка
plt.tight_layout()            # авто-отступы, чтобы ничего не налезало
 
```  

---
