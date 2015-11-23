# flow-test

[flow-test](https://github.com/databox/flow-test) is are set of high-level integration tests of [Databox](http://databox.com) Connect Platform.

## Usage

    make build
    make run

## Development

    docker run -ti -v `pwd`/./:/usr/src/app \
      databox/flow-test rspec

    docker run -ti -v `pwd`/./:/usr/src/app \
      databox/flow-test bash -l

## Authors

- [Oto Brglez](https://github.com)
