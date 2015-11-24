FROM ruby:2.2

LABEL flow-test for Databox

ENV QMAKE=/usr/bin/qmake-qt4
ENV DISPLAY=:0.0
ENV TEST_HOST=http://dev1.host.development:9009/
ENV DATABOX_USER_EMAIL=flowtest@databox.com
ENV DATABOX_USER_PASS=testtest
ENV MAX_WAIT_TIME=60
ENV WITH_VIDEO=1

RUN apt-get update -qq  && \
    apt-get install build-essential g++ git wget curl \
    build-essential chrpath libssl-dev libxft-dev \
    libfreetype6 libfreetype6-dev \
    libfontconfig1 libfontconfig1-dev \
    libqtwebkit-dev qt4-qmake xvfb \
    software-properties-common python-software-properties \
    x11vnc imagemagick iceweasel \
    libav-tools \
    -y -q

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install
COPY . /usr/src/app

CMD ["rspec"]
