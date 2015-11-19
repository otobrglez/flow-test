FROM ruby:2.2-onbuild

LABEL flow-test for Databox

CMD ["rspec"]