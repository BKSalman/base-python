FROM python:3.10-slim AS production

ENV MODULE_NAME=app.main:app
ENV WORKER_CLASS=uvicorn.workers.UvicornWorker

ENV SQLALCHEMY_WARN_20=true
ENV PORT=$port

COPY /start.sh /start.sh
RUN chmod +x /start.sh

COPY /start-reload.sh /start-reload.sh
RUN chmod +x /start-reload.sh

WORKDIR /app/

EXPOSE 80

COPY app/requirements.txt app/requirements.txt

# to build psycopg2
RUN apt-get update \
    && apt-get install -y libpq-dev gcc openssl \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir --upgrade pip \
    pip install --no-cache-dir -r app/requirements.txt

COPY app .

# CMD ["/start.sh"]
CMD [ "/start-reload.sh" ]


FROM production AS dev

RUN pip install -r ./requirements-dev.txt


# FROM production AS testing

# COPY app/requirements.txt requirements.txt
# COPY app/requirements-dev.txt requirements-dev.txt

# RUN pip install -r requirements-dev.txt

# COPY . .

# CMD [ "pytest" ]
