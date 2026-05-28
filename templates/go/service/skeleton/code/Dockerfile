FROM golang:1.25.5-alpine AS build

RUN apk add --no-cache \
    gcc \
    musl-dev

WORKDIR /workspace
RUN go install github.com/DataDog/orchestrion@latest

COPY go.mod go.sum ./
RUN go mod download

COPY ./*.go /workspace/
RUN orchestrion pin
RUN go build -ldflags='-s -w -extldflags "-static"' -toolexec="orchestrion toolexec" -o "app"

FROM scratch AS deploy

WORKDIR /app/
COPY --from=build /workspace/app /usr/local/bin/app
EXPOSE 8080
ENTRYPOINT [ "app" ]
