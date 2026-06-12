FROM python:3.11-slim
WORKDIR /app

COPY pyproject.toml /app/
RUN python -m pip install --upgrade pip && pip install fastapi uvicorn

COPY . /app

CMD ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8001"]
