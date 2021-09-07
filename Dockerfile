FROM python:3.8.6-alpine

WORKDIR /usr/src/smallboard

# install psycopg2 dependencies
RUN apk update && apk add \
    build-base \
    cargo \
    gcc \
    libffi-dev \
    musl-dev \
    postgresql-dev \
    python3-dev \
    rust \
    tzdata

# install npm & yarn
RUN apk add --update nodejs yarn

RUN pip install --upgrade pip
RUN pip install pipenv
COPY Pipfile* ./
RUN pipenv lock --requirements > requirements.txt
RUN pipenv lock -d --pre -r >> requirements.txt
#ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
RUN pip install -r requirements.txt

# Install npm dependencies
COPY ./package.json ./yarn.lock ./
RUN yarn install
# Install patches
COPY ./patches ./patches
RUN yarn install
