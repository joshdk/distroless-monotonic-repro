FROM gcr.io/distroless/python2.7:latest

COPY monotonic/monotonic.py /usr/lib/python2.7/

CMD ["-c", "import monotonic"]
