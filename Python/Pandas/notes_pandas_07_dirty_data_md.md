# 🧹 Работа с грязными данными

---

## 📂 Открытие файлов (open)

```python
file = open('text.txt')
```

Тип:

```python
type(file)
# _io.TextIOWrapper
```

👉 используется для текстовых файлов  
👉 для csv лучше `pd.read_csv()`

---

## 📖 Чтение файла

### readlines()

```python
file.readlines()
```

👉 возвращает список строк

```python
for line in file.readlines():
    print(line)
```

⚠️ Важно:

```python
file.readlines()  # второй раз вернёт []
```

👉 файл "прочитался" и курсор в конце

---

### Закрытие файла

```python
file.close()
```

---

## 📁 Модуль os

```python
import os
```

---

### Основные функции

```python
os.getcwd()          # текущая папка
os.listdir(path)     # список файлов
os.path.exists(path) # существует ли путь
os.path.join(a, b)   # объединение путей
os.mkdir('dir')      # создать папку
os.rmdir('dir')      # удалить папку
```

---

## 📂 os.listdir()

```python
os.listdir('shared')
```

👉 возвращает список файлов

```python
['file1.csv', 'file2.csv']
```

---

### Построение пути

```python
path = 'shared'
file = os.listdir(path)[0]

path_to_file = path + '/' + file
```

👉 лучше:

```python
os.path.join(path, file)
```

---

## 🔁 Обход папок (os.listdir + цикл)

```python
paths = []

for folder in os.listdir('data'):
    if folder != '.DS_Store':
        folder_path = os.path.join('data', folder)

        for sub in os.listdir(folder_path):
            if sub != '.DS_Store':
                file_path = os.path.join(folder_path, sub)
                paths.append(file_path)
```

---

## 🌳 os.walk()

```python
for path, dirs, files in os.walk('data'):
    print(path, dirs, files)
```

👉 возвращает:
- path — текущая папка
- dirs — подпапки
- files — файлы

---

### Пример сбора всех файлов

```python
paths = []

for path, dirs, files in os.walk('data'):
    for file in files:
        if file != '.DS_Store':
            full_path = os.path.join(path, file)
            paths.append(full_path)
```

---

## 🔎 Регулярные выражения (re)

```python
import re
```

---

### Пример (домен из email)

```python
mail = 'test@gmail.com'

pattern = re.compile(r'@([\w.]+)')
pattern.findall(mail)
# ['gmail.com']
```

---

## 🔤 Основные символы

| Символ | Значение |
|------|--------|
| \d | цифра |
| \D | не цифра |
| \s | пробел |
| \S | не пробел |
| \w | буква/цифра/_ |
| \W | не \w |
| . | любой символ |

---

## 📦 Группы ()

```python
pattern = re.compile(r'(\d\d\d)-(\d\d\d)')
```

```python
pattern.findall(text)
# [('921', '000')]
```

👉 возвращает кортежи

---

## 🔁 Квантификаторы

| Символ | Значение |
|------|--------|
| * | 0+ |
| + | 1+ |
| ? | 0 или 1 |

```python
pattern = re.compile(r'\d+')
```

---

## ⚠️ Экранирование

```python
r'\d'   # цифра
r'\\d'  # строка "\\d"
```

---

## 🧠 Разбор регулярки

```python
@([\w.]+)
```

- `@` — начало
- `[\w.]` — буквы или точки
- `+` — 1 или больше
- `()` — вернуть только это

---

## 🐼 Парсинг строк в pandas

### str.extract()

```python
df['info'].str.extract(r'(?P<name>\w+), \((?P<date>.+)\)')
```

👉 создаёт новые колонки:
- name
- date

---

## 🔎 Отбор колонок

### filter()

```python
df.filter(like='id')
```

👉 колонки содержащие 'id'

```python
df.filter(regex='id$')
```

👉 колонки, заканчивающиеся на 'id'

---

## 🔄 Конвертация типов

```python
df = df.astype({'money': 'float'})
```

или

```python
df['height'] = df['height'].astype('float')
```

---

## ❌ Удаление колонок и строк

```python
df = df.drop(columns='Date')
```

```python
df = df.drop(index=350)
```

---

## 💡 Итог

👉 open + os → работа с файлами  
👉 re → парсинг текста  
👉 pandas → очистка и преобразование  

👉 база для работы с "грязными" данными

