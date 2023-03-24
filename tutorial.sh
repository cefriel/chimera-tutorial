#!/bin/bash

: ${PORT:=8888}
: ${ADDRESS:='http://localhost:'}

case "$1" in
    "lift")
	curl --location --request POST "${ADDRESS}${PORT}/chimera-demo/lift" --header 'Content-Type: application/zip' \
	     --data-binary '@inbox/sample-gtfs-feed.zip'
	;;
    "liftConstruct")
	curl --location --request POST "${ADDRESS}${PORT}/chimera-demo/liftConstruct" --header 'Content-Type: application/zip' \
	     --data-binary '@inbox/sample-gtfs-feed.zip'
	;;
    "roundtrip")
	curl --location --request POST "${ADDRESS}${PORT}/chimera-demo/roundtrip" --header 'Content-Type: application/zip' \
	     --data-binary '@inbox/sample-gtfs-feed.zip'
	;;
    "roundtripAdd")
	curl --location --request POST "${ADDRESS}${PORT}/chimera-demo/roundtripAdd" --header 'Content-Type: application/zip' \
	     --data-binary '@inbox/sample-gtfs-feed.zip'
	;;
    "roundtripInference")
	curl --location --request POST "${ADDRESS}${PORT}/chimera-demo/roundtripInference" --header 'Content-Type: application/zip' \
	     --data-binary '@inbox/sample-gtfs-feed.zip'
	;;
    "roundtripTemplate")
	curl --location --request POST "${ADDRESS}${PORT}/chimera-demo/roundtripTemplate" --header 'Content-Type: application/zip' \
	     --data-binary '@inbox/sample-gtfs-feed.zip'
	;;
    *)
	echo "Provide an argument specifying the tutorial step id."
	;;
esac
