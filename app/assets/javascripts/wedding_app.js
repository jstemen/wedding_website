function scrollToId(id) {
    $('html, body').animate({
        scrollTop: $(id).offset().top -30
    }, 500);
}




$(window).resize(function() {
    $('.content-section').height($(window).height() - 30);
});

$(window).trigger('resize');
$(window).ready(function(){
    $(window).resize();
})