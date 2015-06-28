const NAV_HEIGHT = 30

function scrollToId(id) {
    $('html, body').animate({
        scrollTop: $(id).offset().top - NAV_HEIGHT
    }, 500);
    location.hash = id;
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

function moveDiv(newParent, child) {
    if (child.parent != newParent) {
        newParent.append(child)
    }
}
function isScrolledIntoView(elem) {
    var $elem = $(elem);
    var $window = $(window);

    var docViewTop = $window.scrollTop();
    var docViewBottom = docViewTop + $window.height();

    return ((originalBottom <= docViewBottom) && (orginalTop >= docViewTop));
}

var originalParentsHash = {};
var orginalTop = null;
var originalBottom = null;
$(window).scroll(function (event) {
    var child = $(".followMe")

    if (!originalParentsHash[child]) {
        var elemTop = child.offset().top;
        var elemBottom = elemTop + child.height();
        originalBottom = elemBottom
        orginalTop= elemTop
        originalParentsHash[child] = child.parent();
    }
    //var scroll = $(window).scrollTop();
    if (isScrolledIntoView(originalParentsHash[child])) {
        moveDiv(originalParentsHash[child], child)
    } else {
        moveDiv($("#headContainer"), child)
    }
});