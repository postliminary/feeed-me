var notice = {
    close: function () {
        $("#notice").delay(1000).fadeOut('normal', function () {
            $(this).alert('close');
        });
    }
};