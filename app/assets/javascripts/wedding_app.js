const NAV_HEIGHT = 30

function scrollToId(id) {
    $('html, body').animate({
        scrollTop: $(id).offset().top - NAV_HEIGHT
    }, 500);
}


$(window).resize(function () {

    $('.content-section').each( function(index){
        var fullScreenSize = $(window).height() - NAV_HEIGHT;
        var currentDivSize = $(this).height();
        var rightSize = Math.max(fullScreenSize, currentDivSize)
        $(this).height(rightSize);
    })
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