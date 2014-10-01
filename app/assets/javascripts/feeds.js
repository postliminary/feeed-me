var feeds = {
    update: function (id, interval) {
        setTimeout(function () {
            $.getJSON("/feeds/" + id, function (data) {
                $("#recent-entries").html(data.partial_html)

                // Slowly extend polling to match update freq
                // 2 - 30s
                var new_interval = Math.min(Math.max(data.last_updated, 2000), 30000)
                feeds.update(id, new_interval);
            })
        }, interval);
    }
}