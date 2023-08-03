package org.apache.camel.example;

import org.apache.camel.AggregationStrategy;
import org.apache.camel.Exchange;
import org.apache.jena.base.Sys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Optional;

public class CustomAggregationStrategy implements AggregationStrategy {
    private static final Logger logger = LoggerFactory.getLogger(CustomAggregationStrategy.class);
    @Override
    public Exchange aggregate(Exchange oldExchange, Exchange newExchange) {
        if(oldExchange == null)
            return newExchange;

        var header = newExchange.getMessage().getHeader("zipFileName");
        if (header != null) {
            if(header.toString().equals("stops.txt")) {
                String f = newExchange.getMessage().getBody(String.class);
                oldExchange.getMessage().setBody(f);
                return oldExchange;
            }
        }
        return oldExchange;
    }
}
