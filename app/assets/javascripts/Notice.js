/**
 * Created by thomastuttle on 10/1/14.
 */
var notice = {
    close: function () {
        $("#notice").delay(1000).fadeOut('normal', function () {
            $(this).alert('close');
        });
    }
};