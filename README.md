# flow-test

[flow-test](https://github.com/databox/flow-test) are set of high-level integration tests for [Databox](http://databox.com) Connect Platform.

[![Circle CI](https://circleci.com/gh/databox/flow-test/tree/master.svg?style=svg&circle-token=db81e31d79a77fd1f4953b537a6d8bc4c658f486)](https://circleci.com/gh/databox/flow-test/tree/master)

## Usage

    # With video recordings
    docker run --rm=true -v `pwd`/video:/usr/src/app/video \
      -m 2G \
      -i \
      registry.databox.com/flow-test:master

    # Without video recordings
    docker run --rm=true -ti -e WITH_VIDEO=0 -m 2G registry.databox.com/flow-test:master

> [run_from_cron.py](run_from_cron.py) is wrapper for `cron` to help run this script and report about its execution.

## (Default Docker) Environment variables

    DATABOX_APP_HOST=https://new.databox.com
    DATABOX_USER_EMAIL=oto@databox.com
    DATABOX_USER_PASS=geslo123
    WITH_VIDEO=1
    MAX_WAIT_TIME=60
    TEST_HOST=http://dev1.host.development:9009/

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
