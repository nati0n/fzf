FROM golang:1.18-bullseye as builder
#FROM --platform=linux/amd64 ubuntu:20.04 as builder

#RUN apt-get update
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
#RUN add-apt-repository ppa:longsleep/golang-backports
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install make
#RUN export PATH=$PATH:/usr/local/go/bin


ADD . /fzf
WORKDIR /fzf
RUN make
RUN make install

FROM ubuntu:20.04 as package

COPY --from=builder /fzf/bin/fzf /fzf
COPY --from=builder /fzf/example_history /example_history

# Technically build and 'package'
# build step with required supporting packages
# package step new docker with binaryldd
# go make gcc cmake clang curl