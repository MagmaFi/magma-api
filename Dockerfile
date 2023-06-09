FROM pypy:3.9-slim-bullseye AS base

ENV POETRY_HOME=/etc/poetry
ENV POETRY_VIRTUALENVS_CREATE=false

RUN apt-get update
RUN apt-get install -y --no-install-recommends gcc g++ libssl-dev libev-dev curl git
RUN apt-get clean

RUN curl -sSL https://install.python-poetry.org | python -

ENV PATH="$PATH:$POETRY_HOME/bin"

FROM base AS prod

WORKDIR /app
COPY ./pyproject.toml /app
COPY ./poetry.lock /app

RUN poetry install

COPY ./ /app

RUN poetry install --only-root

EXPOSE 8000

ENTRYPOINT ["api-start"]

FROM prod AS sync

ENTRYPOINT ["api-sync"]
