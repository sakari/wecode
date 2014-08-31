define ['jquery'], ($) ->
        dfd = $.Deferred()
        window.onYouTubeIframeAPIReady = () ->
                dfd.resolve YT

        require ['https://www.youtube.com/iframe_api'], ->
        dfd.promise()
