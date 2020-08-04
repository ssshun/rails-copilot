FROM ruby:2.7.1-alpine3.12

ENV ROOT="/myapp" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

WORKDIR ${ROOT}

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        tzdata \
        nodejs \
        mysql-dev \
        mysql-client \
        vim && \
    apk add --virtual build-packs --no-cache \
        build-base \
        curl-dev \
        gcc \
        g++ \
        libc-dev \
        libxml2-dev \
        linux-headers \
        make

COPY Gemfile ${ROOT}
COPY Gemfile.lock ${ROOT}

RUN bundle install
RUN apk del build-packs

COPY . ${ROOT}

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
