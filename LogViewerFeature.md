# Log viewer feature

## Main Feature


The "web" application should provide a real time stream of the application logs via the API.

The "ui-ex" app should query the logs and process the response to be able to show a list of lines to the user.

Inside the app dashboard, a new "Logs" section would be created where upon selecting it the logs of the app will be displayed. A certain amount of logs should be retrieved from the API and refreshed in real time.

The logs should be inside a scrollable container,
with each log line will appearing at the bottom, pushing the rest up (just like `flyctl logs`). 
If the users scrolls away new logs should come in but the scroll should not be taken back to the bottom. Later a feature to pin/unpin the scroll can be implemented

Each line would be shown colored in the same way as `flyctl` with additional formatting for dates and region codes. This would make the log easy to read for the user specially when there are several messages coming in with different properties.

Additional specific features wold be:

#### Log stream filtering
  The user filters which log lines are shown using a text field, to search for specific messages.

  Additionaly, users will be able to filter by log level and other fields to be able to switch focus to the requests that are important at the moment.

#### Historical logs

A separate section to check older logs for the app, either by scrolling back manually through the full log, or by performing a full text search on them. 
Users can find specific errors or dates to find information on incidents that happened some time ago.

Historical logs would also be filterable by fields like log level, timestamp, event provider, etc.

Filtering and search would rely on elastic search

### Feature success

The feature's success can be measured with analytics (if available) from the dashboard, and the community reactions. 
New feature requests from the community or requests to port some of these new features to `flyctl` would probably mean people are making good use of the log viewer


## Changes in systems

web:
* Enabling real-time log streaming to ui-ex via NATS

ui-ex:
* New "Logs" section in the app's dashboard
  * A scrollable container with initally the latests log lines, refreshing in real-time using the API
  * Each new line shows at the bottom and pushes the rest up
  * Inner section to access historical logs
    * Full text search for these logs
  * Filtering by different fields like log level in both historical and real-time logs.

* Accessing the historical logs from elastic search

## Future Improvements
* Efficient full text search for real time logs. Useful feature, but for a first version the browser search feature may be good enough.

* Log analysis to obtain metrics like amount of errors per day, a summary of responses grouped by status codes, etc. This can be useful but given that many kinds of apps can be deployed, either the analysis has to be generic for all of them or multiple kinds of analysis should be done for each type of app, which can be complex to do well.

* An option to pin the scroll to the bottom of the log list and move it back everytime a new log line appears

* An option to show server absolute dates or a relative date with timezone calculations (`1 hour ago` vs `2021-10-01 18:32:20`)

* A way to split the log area to be able to scroll through old lines at the top, while the bottom keeps showing the latest ones coming. 

## Other considerations

* The dashboard may grow too large in memory if the amount of logs is big enough

* The log page should keep streaming logs if the users loses internet connection, once they connect again


# Feature Announcement


You can now view your app logs from the dashboard!

Here's what you can do:
* Stream logs in real time
* Filter them by log level, timestamp, and more.
* Access your apps historical logs, with full text search on all your available log history.

Want to see what was going on in the logs for an issue that happened weeks ago? 
Maybe track down an specific error that may have occurred in the past?

Historic logs are perfect for that! Use the full text search to track down instances of specific messages through time, or filter by date and log level to catch what was happening when no one was there to check the logs in real time.

An issue is happening now, or is easily reproducible? Use the real time logs to quickly check what is going on. Even if there are a lot of messages, use the filters to narrow down to only what you need at this moment.
