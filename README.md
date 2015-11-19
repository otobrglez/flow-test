# flow-test

## Usage

    docker run -ti databox/flow-test

## Development


    docker build --rm=true -t databox/flow-test .
    gem install bundler ; bundle
    rspec


## Make GIFs

     convert   -delay 200   -loop 1 ./shots/*.jpg test.gif 