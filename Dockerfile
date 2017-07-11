FROM ubuntu AS prepare

RUN apt-get update && apt-get install -y curl

WORKDIR /windows

COPY CBaseOs_rs_prerelease_16237.1001.170701-0549_amd64fre_NanoServer_en-us.tar.gz /nano.tar.gz
RUN tar xzf /nano.tar.gz
