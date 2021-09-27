$(function() {
    var displayed = false
    $(".container").hide()
    window.addEventListener("message", function(v) {
        const val = event['data']
        if (val['show']) {
            if (!displayed) {
                displayed = true
                $(".container")['fadeIn'](500)
            }
            $(".text")['html'](val['text'])
        } else {
            if (displayed) {
                displayed = false
                $(".container")['fadeOut'](500)
            }
        }
    })    
})