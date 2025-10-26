# Dockerfile
# Используем официальный Python образ
FROM python:3.9-slim

# Устанавливаем рабочую директорию в контейнере
WORKDIR /app

# Копируем файл с зависимостями (если будем добавлять библиотеки)
COPY requirements.txt .

# Устанавливаем зависимости (если есть)
RUN pip install --no-cache-dir -r requirements.txt

# Копируем основной код программы
COPY Capital_Country.py .

# Указываем команду для запуска при старте контейнера
CMD ["python", "Capital_Country.py"]
