FROM docker.elastic.co/wolfi/jdk:openjdk-25.0.3-r6-dev@sha256:72cdebdd4f35c880568894eef0c4a14773e885abec414dc62a57ace74419fa25 AS builder

#####################
# Build code
#####################
USER root

WORKDIR /build

COPY ./ ./

RUN ./gradlew --no-daemon build

FROM docker.elastic.co/wolfi/jdk:openjdk-25.0.3-r6@sha256:5f7e6555a18c13cfea4f085f78f447408052aaefe6826b25c2ed4529118cc12e AS runner

########################
# Prepare the code to run
########################
WORKDIR /support-diagnostics

COPY --from=builder /build/scripts /support-diagnostics
COPY --from=builder /build/build/libs/diagnostics-*.jar /support-diagnostics/lib/
COPY --from=builder /build/build/lib/ /support-diagnostics/lib/
COPY --from=builder /build/src/main/resources /support-diagnostics/config
