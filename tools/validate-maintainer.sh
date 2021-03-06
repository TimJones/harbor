#!/bin/bash

MAINTAINER='MAINTAINER Port Direct <support@port.direct>'
RES=0

for dockerfile in "$@"; do
    if ! grep -q "$MAINTAINER" "$dockerfile"; then
        echo "ERROR: $dockerfile has incorrect MAINTAINER" >&2
        RES=1
    fi
done

exit $RES
