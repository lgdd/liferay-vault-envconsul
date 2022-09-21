FROM alpine

RUN apk --no-cache add curl

COPY secrets.json .
COPY --chmod=0755 init-secrets.sh .

CMD ["./init-secrets.sh"]
