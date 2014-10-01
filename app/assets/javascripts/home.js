var home = {
    pollForUpdates: function (interval) {
        setTimeout(function () {
            $.getJSON("/home/index", function (data) {
                $("#recent-entries").html(data.partial_html)

                // Slowly extend polling to match update freq
                // 2 - 30s
                var new_interval = Math.min(Math.max(data.last_updated, 2000), 30000)
                home.pollForUpdates(new_interval);
            })
        }, interval);
    }
}