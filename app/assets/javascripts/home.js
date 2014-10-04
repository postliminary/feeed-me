var home = {
    max_interval: 30000,
    default_interval: 2000,

    update: function (interval) {
        setTimeout(function () {
            $.getJSON("/api/home/index", function (data) {
                $("#recent-entries").html(data.partial_html)

                // Slowly extend polling to match update freq
                // 2 - 30s
                if (data.last_entry_at < home.max_interval) {
                    home.update(home.default_interval);
                }
                else {
                    var new_interval = Math.min(interval + home.default_interval, home.max_interval)
                    home.update(new_interval);
                }
            })
        }, interval);
    }
}

