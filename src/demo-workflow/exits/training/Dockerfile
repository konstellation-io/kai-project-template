FROM python:3.13.1-slim-bullseye

LABEL maintainer="Intelygenz - KAI Team"


ARG USER=kai
ARG UID=1001

ENV PATH="/root/.local/bin:$PATH"
ENV PYTHONUNBUFFERED=1

WORKDIR /tmp

COPY ["pyproject.toml", "uv.lock", "./"]

RUN apt update &&\
    apt install -yq --no-install-recommends curl git && \
    apt-get clean && apt-get autoremove -y && \
    useradd -m -b /sdk --shell /bin/bash --uid ${UID} ${USER} && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    uv sync

WORKDIR /app

RUN chown -R kai:0 /app \
    && chmod -R g+w /app \
    && mkdir /var/log/app -p \
    && chown -R kai:0 /var/log/app \
    && chmod -R g+w /var/log/app

USER ${USER}

COPY *.py process/

CMD ["bash", "-c", "/usr/local/bin/python /app/process/main.py"]
