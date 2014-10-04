var feeds = {
    max_interval: 30000,
    default_interval: 2000,

    update: function (id, interval) {
        setTimeout(function () {
            $.getJSON("/api/feeds/" + id, function (data) {
                $("#recent-entries").html(data.partial_html)

                // Slowly extend polling to match update freq
                // 2 - 30s
                if (data.last_entry_at < home.max_interval) {
                    feeds.update(id, feeds.default_interval);
                }
                else {
                    var new_interval = Math.min(interval + feeds.default_interval, feeds.max_interval)
                    feeds.update(id, new_interval);
                }
            })
        }, interval);
    }
}