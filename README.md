# flow-test

[flow-test](https://github.com/databox/flow-test) is are set of high-level integration tests of [Databox](http://databox.com) Connect Platform.

## Usage

    docker build --rm=true -t databox/flow-test .
    docker run -ti databox/flow-test

## Development

    docker run -ti -v `pwd`/./:/usr/src/app databox/flow-test
    docker run -ti -v `pwd`/./:/usr/src/app \
        databox/flow-test bash -l

## Authors

- [Oto Brglez](https://github.com)