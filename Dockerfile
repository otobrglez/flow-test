FROM ruby:2.2-onbuild

LABEL flow-test for Databox

RUN apt-get update -qq && \
    apt-get install build-essential g++ git wget curl \
    build-essential chrpath libssl-dev libxft-dev \
    libfreetype6 libfreetype6-dev \
    libfontconfig1 libfontconfig1-dev \
    software-properties-common python-software-properties \
    -y -q

ADD ./bin/phantomjs /usr/bin/phantomjs

CMD ["rspec"]