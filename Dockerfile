FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# change per day
CMD ["python", "-i", "days/day1/main.py"]