FROM alpine

RUN apk --no-cache add curl

COPY --chmod=0755 init-secrets.sh .

CMD ["./init-secrets.sh"]
