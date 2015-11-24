# flow-test

[flow-test](https://github.com/databox/flow-test) is are set of high-level integration tests of [Databox](http://databox.com) Connect Platform.

## Usage

    docker run -ti -v `pwd`/video:/usr/src/app/video -m 2G registry.databox.com/flow-test:master



## (Default) Environment variables

    DATABOX_APP_HOST=https://new.databox.com
    DATABOX_USER_EMAIL=oto@databox.com
    DATABOX_USER_PASS=geslo123
    WITH_VIDEO=1
    MAX_WAIT_TIME=60

> Google Analytic specific environment variables / [suite is here](spec/ga_spec.rb).

## Development

    make build
    make run

    docker run -ti -v `pwd`/./:/usr/src/app \
      databox/flow-test rspec

    docker run -ti -v `pwd`/./:/usr/src/app \
      databox/flow-test bash -l



## Authors

- [Oto Brglez](https://github.com)
