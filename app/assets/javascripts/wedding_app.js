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
function isElementScrolledIntoView($elem) {
    var elemTop = $elem.offset().top;
    var elemBottom = elemTop + $elem.height();
    return areCoordinatesScrolledIntoView(elemTop, elemBottom);
}

function areCoordinatesScrolledIntoView(elemTop, elemBottom) {
    var docViewBottom = windowBottom();
    return ((elemBottom <= docViewBottom) && (elemTop >= $(window).scrollTop()));
}

var originalParentsHash = {};
function windowBottom() {
    var docViewTop = $(window).scrollTop();
    return docViewTop + $(window).height();
}
$(window).scroll(function (event) {
    var child = $(".followMe")

    var holder = originalParentsHash[child];
    if (!holder) {
        holder = {};
        originalParentsHash[child] = holder;
        holder.top = child.offset().top;
        holder.bottom = holder.top + child.height();
        holder.element = child.parent();
    }
    var isAboveOrigin = windowBottom() < holder.bottom;
    if (areCoordinatesScrolledIntoView(holder.top, holder.bottom) || isAboveOrigin) {
        moveDiv(holder.element, child);
    } else {
        moveDiv($("#headContainer"), child)
    }
    var $navbarz = $("#navbarz");
    if (isElementScrolledIntoView($navbarz)) {
        $("#headContainer").css("padding-top", $navbarz.height());
    } else {
        $("#headContainer").css("padding-top", 0);
    }
});