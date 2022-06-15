FROM golang:1.9 AS build
RUN go get -u github.com/golang/dep/cmd/dep
COPY . $GOPATH/src/app
WORKDIR $GOPATH/src/app
RUN dep ensure && \
  CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM golang:1.9-alpine
COPY --from=build /go/src/app/app /app
RUN apk update && apk upgrade && apk add bash
EXPOSE 8080 8086 9101
CMD ["/app"]
