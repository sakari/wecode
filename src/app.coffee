define ['lib/react', 'cs!src/youtube'], ({createClass, renderComponent, DOM}, youtube) ->
        hello = createClass
                render: ->
                        DOM.p {}, "aoeuaoeuaeou"
        renderComponent (hello {}), document.getElementById('target')

        youtube.done (YT) ->
                player = new YT.Player 'player',
                        height: '' + 390 * 2
                        width: '' + 640 * 2
                        videoId: 'Oh2TNO5CGXQ'
                        events:
                            onReady: (e) -> e.target.playVideo
                            onStateChange: onPlayerStateChange

                done = false;
                onPlayerStateChange = (event) ->
                        if (event.data == YT.PlayerState.PLAYING) && !done
                                setTimeout(stopVideo, 6000)
                                done = true

                stopvideo = () ->
                      player.stopVideo();
