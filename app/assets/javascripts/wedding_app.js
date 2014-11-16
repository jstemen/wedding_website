function scrollToId(id) {
    $('html, body').animate({
        scrollTop: $(id).offset().top - 30
    }, 500);
}


$(window).resize(function () {
    $('.content-section').height($(window).height() - 30);
});

$(window).trigger('resize');

function onChange() {
    $(window).resize();
    loadGame();
}

$(window).ready(function () {
    onChange()
})

$(document).on('page:load', function () {
    onChange()
})