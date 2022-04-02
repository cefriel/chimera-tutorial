: ${PORT:=8888}

case "$1" in
        "lifting")
		curl --location --request POST 'http://localhost:'"${PORT}"'/chimera-demo/lift/gtfs/' --header 'Content-Type: application/zip' \
			--data-binary '@inbox/sample-gtfs-feed.zip'
        ;;
        "construct")
		curl --location --request POST 'http://localhost:'"${PORT}"'/chimera-demo/lift/gtfs/' --header 'construct: true' \
			--header 'Content-Type: application/zip' --data-binary '@inbox/sample-gtfs-feed.zip'
		;;
		"conversion")
		curl --location --request POST 'http://localhost:'"${PORT}"'/chimera-demo/roundtrip/gtfs/' --header 'Content-Type: application/zip' \
			--data-binary '@inbox/sample-gtfs-feed.zip'
		;;
        "enrich")
		curl --location --request POST 'http://localhost:'"${PORT}"'/chimera-demo/roundtrip/gtfs/' --header 'additional_source: enrich.ttl' \
			--header 'Content-Type: application/zip' --data-binary '@inbox/sample-gtfs-feed.zip'
		;;
		"load-enrich")
		curl --location --request POST 'http://localhost:'"${PORT}"'/chimera-demo/load/' --header 'filename: my-source.ttl' \
			--header 'Content-Type: text/turtle' --data-binary '@inbox/my-source.ttl'
		curl --location --request POST 'http://localhost:'"${PORT}"'/chimera-demo/roundtrip/gtfs/' --header 'additional_source: my-source.ttl' \
			--header 'Content-Type: application/zip' --data-binary '@inbox/sample-gtfs-feed.zip'
		;;
		"inference")
		curl --location --request POST 'http://localhost:'"${PORT}"'/chimera-demo/roundtrip/gtfs/' --header 'inference: true' \
			--header 'additional_source: enrich.ttl' --header 'Content-Type: application/zip' \
			--data-binary '@inbox/sample-gtfs-feed.zip'
		;;
		*)
		echo "Provide an argument specifying the tutorial step id."
		;;
esac