SQL Practice



Мои SQL задачи и заметки во время обучения аналитике данных.



📌 О проекте



В этом репозитории я собираю:

\- решения SQL задач

\- примеры запросов

\- полезные заметки и шпаргалки



Цель — закрепить знания и сформировать портфолио.



\---


 🧠 Изученные темы



\- SELECT, WHERE, ORDER BY

\- DATE\_PART, DATE\_TRUNC

\- CASE WHEN

\- COALESCE

\- JOIN



\---



 📁 Структура проекта



\- `basics/` — базовые запросы

\- `functions/` — функции (DATE\_PART, COALESCE и т.д.)

\- `joins/` — соединения таблиц

\- `notes/` — заметки и шпаргалки



\---



 💡 Пример запроса



```sql

SELECT 

DATE\_PART('day', order\_estimated\_delivery\_time - order\_delivered\_customer\_time) AS delay\_days

FROM orders;

