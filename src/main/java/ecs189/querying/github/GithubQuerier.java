package ecs189.querying.github;

import ecs189.querying.Util;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Vincent on 10/1/2017.
 */
public class GithubQuerier {

    private static final String BASE_URL = "https://api.github.com/users/";

    public static String eventsAsHTML(String user) throws IOException, ParseException {
        List<JSONObject> response = getEvents(user);
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < response.size(); i++) {
            sb.append("<div class=\"item\">");
            sb.append("<span class=\"octicon octicon-clippy icon\"></span>");
            sb.append("<div class=\"text\">");

            JSONObject event = response.get(i);
            // Get event type
            String type = event.getString("type");
            // Get created_at date, and format it in a more pleasant style
            String creationDate = event.getString("created_at");
            SimpleDateFormat inFormat = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss'Z'");
            SimpleDateFormat outFormat = new SimpleDateFormat("dd MMM, yyyy");
            Date date = inFormat.parse(creationDate);
            String formatted = outFormat.format(date);

            sb.append("<h3 class=\"title\">Push Event</h3>");
            sb.append("<span class=\"date\">");
            sb.append(formatted);
            sb.append("</span>");



            JSONArray commits = event.getJSONObject("payload").getJSONArray("commits");

            for(int j = 0; j < commits.length(); j++) {
                String sha = commits.getJSONObject(j).getString("sha");
                String message = commits.getJSONObject(j).getString("message");

                sb.append("<span class=\"sha\">");
                sb.append(sha);
                sb.append("</span>");
                sb.append("<p class=\"commit\">");
                sb.append(message);
                sb.append("</p>");

                // shaw + all commits - sha and commit message for each commit
            }
            sb.append("</div>");
            sb.append("</div>");
        }
        return sb.toString();
    }

    private static List<JSONObject> getEvents(String user) throws IOException {
        List<JSONObject> eventList = new ArrayList<JSONObject>();

        int counter = 0;
        int page = 1;
        while(counter < 10) {
            String url = BASE_URL + user + "/events?per_page=100&page=" + page;
            System.out.println(url);
            JSONObject json = Util.queryAPI(new URL(url));
            System.out.println(json);
            JSONArray events = json.getJSONArray("root");

            // Check if we hit the end of a user's history
            if(events.length() == 0)
                break;

            for (int i = 0; i < events.length() && counter < 10; i++) {
                if(events.getJSONObject(i).getString("type").equals("PushEvent")) {
                    counter++;
                    eventList.add(events.getJSONObject(i));
                }
            }
            page++;
        }

        return eventList;
    }
}