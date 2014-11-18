const NAV_HEIGHT = 30

function scrollToId(id) {
    $('html, body').animate({
        scrollTop: $(id).offset().top - NAV_HEIGHT
    }, 500);
}


$(window).resize(function () {

    $('.content-section').each(function (index) {
        var fullScreenSize = $(window).height();
        var currentDivSize = $(this).height();
        if (currentDivSize < fullScreenSize) {
            $(this).height(fullScreenSize);
        }
    })
});


function onChange() {
    $(window).trigger('resize');
    loadGame();
}

$(window).ready(function () {
    onChange()
})

$(document).on('page:load', function () {
    onChange()
})