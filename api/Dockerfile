FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

ADD requirements.txt /app
RUN pip install -r requirements.txt
COPY . /app