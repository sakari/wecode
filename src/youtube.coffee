define ['react', 'jquery'], ({createClass, DOM}, $) ->
        dfd = $.Deferred()
        window.onYouTubeIframeAPIReady = () ->
                dfd.resolve YT

        require ['https://www.youtube.com/iframe_api'], ->
        dfd.promise()

        idCounter = 0
        createClass
                _updateTime: ->
                        @props.events.push({ position: @state.player.getCurrentTime()})

                _onReady: (e) ->
                        @setState { poll: setInterval(@_updateTime.bind(@), 10) }
                        @props.commands.map('.seekTo').onValue (v) =>
                                return unless v?
                                console.log 'seekto', v
                                @state.player.seekTo v, true

                        @setState { state : 'ready' }
                        @props.events.push({
                                'playback-rates': @state.player.getAvailablePlaybackRates()
                                })

                _onPlayerStateChange: ->

                shouldComponentUpdate: (props, state) ->
                        if state.player && state.state == 'ready'
                                if props.mode != @props.mode
                                        switch props.mode
                                                when 'stop'
                                                        console.log 'stop', props
                                                        state.player.stopVideo()
                                                when 'play'
                                                        console.log 'play', props
                                                        state.player.playVideo()
                                                when 'pause'
                                                        console.log 'pause', props
                                                        state.player.pauseVideo()
                                                when 'interrupted'
                                                        console.log 'interrupted', props
                                                        state.player.pauseVideo()

                                if props.playbackRate != @props.playbackRate
                                        state.player.setPlaybackRate(props.playbackRate)
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
