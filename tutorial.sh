case "$1" in
        "lifting")
		curl --location --request POST 'http://localhost:8888/chimera-demo/lift/gtfs/' --header 'Content-Type: application/zip' \
			--data-binary '@inbox/sample-gtfs-feed.zip' > outbox/lifting.ttl
        ;;
        "construct")
		curl --location --request POST 'http://localhost:8888/chimera-demo/lift/gtfs/' --header 'construct: true' \
			--header 'Content-Type: application/zip' --data-binary '@inbox/sample-gtfs-feed.zip' > outbox/construct.ttl
		;;
		"conversion")
		curl --location --request POST 'http://localhost:8888/chimera-demo/roundtrip/gtfs/' --header 'Content-Type: application/zip' \
			--data-binary '@inbox/sample-gtfs-feed.zip' > outbox/conversion.csv
		;;
        "enrich")
		curl --location --request POST 'http://localhost:8888/chimera-demo/roundtrip/gtfs/' --header 'additional_source: enrich.ttl' \
			--header 'Content-Type: application/zip' --data-binary '@inbox/sample-gtfs-feed.zip' > outbox/enrich.csv
		;;
		"load-enrich")
		curl --location --request POST 'http://localhost:8888/chimera-demo/load/' --header 'filename: my-source.ttl' \
			--header 'Content-Type: text/turtle' --data-binary '@inbox/my-source.ttl'
		curl --location --request POST 'http://localhost:8888/chimera-demo/roundtrip/gtfs/' --header 'additional_source: my-source.ttl' \
			--header 'Content-Type: application/zip' --data-binary '@inbox/sample-gtfs-feed.zip' > outbox/load-enrich.csv
		;;
		"inference")
		curl --location --request POST 'http://localhost:8888/chimera-demo/roundtrip/gtfs/' --header 'inference: true' \
			--header 'additional_source: enrich.ttl' --header 'Content-Type: application/zip' \
			--data-binary '@inbox/sample-gtfs-feed.zip' > outbox/inference.csv
		;;
		*)
		echo "Provide an argument specifying the tutorial step id."
		;;
esac