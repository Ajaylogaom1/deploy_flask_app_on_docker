FROM python:3.9-slim AS builder

WORKDIR /app/backend

COPY requirements.txt /app/backend

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && pip install --no-cache-dir --prefix=/install -r requirements.txt \
    && rm -rf /var/lib/apt/lists/*


#final -------stage-------

FROM python:3.9-slim

WORKDIR /app/backend

# Runtime library for mysqlclient
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libmariadb3 \
    && rm -rf /var/lib/apt/lists/*

# Copy only Python packages from builder
COPY --from=builder /install /usr/local

COPY . .

EXPOSE 8000
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
#RUN python manage.py migrate
#RUN python manage.py makemigrations
