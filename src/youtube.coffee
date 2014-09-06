define ['lib/react', 'jquery'], ({createClass, DOM}, $) ->
        dfd = $.Deferred()
        window.onYouTubeIframeAPIReady = () ->
                dfd.resolve YT

        require ['https://www.youtube.com/iframe_api'], ->
        dfd.promise()

        idCounter = 0
        createClass
                _onReady: (e) ->
                        console.log 'on ready'
                        @setState { state : 'ready' }
                _onPlayerStateChange: ->

                shouldComponentUpdate: (props, state) ->
                        if state.player && state.state == 'ready'
                                switch props.mode
                                        when 'stop'
                                                state.player.stopVideo()
                                        when 'play'
                                                state.player.playVideo()
                                        when 'pause'
                                                state.player.pauseVideo()
                        false

                componentDidMount: ->
                        dfd.done (YT) =>
                                @_YT = YT
                                @setState
                                        player: new YT.Player @state.node,
                                                height: @props.height
                                                width: @props.width
                                                videoId: @props.videoId
                                                playerVars:
                                                        controls: 0
                                                        modestBranding: 1
                                                events:
                                                        onReady: @_onReady
                                                        onStateChange: @_onPlayerStateChange
                getInitialState: ->
                        id = 'youtube-player-' + (idCounter++)
                        { state: 'loading', play: @props.play , player: null, node: id}
                render: ->
                        DOM.div { className: 'youtube', id: @state.node }
