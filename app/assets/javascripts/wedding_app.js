function scrollToId(id) {
    $('html, body').animate({
        scrollTop: $(id).offset().top
    }, 500);
}




$(window).resize(function() {
    $('.content-section').height($(window).height() - 46);
});

$(window).trigger('resize');
$(window).ready(function(){
    $(window).resize();
})