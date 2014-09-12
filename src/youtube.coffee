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
                        console.log 'player ready for:', @props.videoId
                        @props.events.push playerReady: true
                        @props.events.push position: 0
                        if @state.poll
                                clearInterval @state.poll
                        @setState { poll: setInterval(@_updateTime.bind(@), 10) }
                        @props.commands.map('.seekTo').onValue (v) =>
                                return unless v?
                                console.log 'seekto', v
                                @state.player.seekTo v, true

                        @setState { state : 'ready' }
                        @props.events.push({
                                'playback-rates': @state.player.getAvailablePlaybackRates()
                                })

                _onPlayerStateChange: (event) ->
                        state = switch event.data
                                when -1 then 'stopped'
                                when 0 then 'unstarted'
                                when 1 then 'playing'
                                when 2 then 'paused'
                                when 3 then 'buffering'
                                when 4 then 'queued'
                        console.log 'state change to:', state
                        @props.events.push playerState: state

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
                _createPlayer: (videoId) ->
                        new @state.yt.Player @state.node,
                                height: @props.height
                                width: @props.width
                                videoId: videoId
                                playerVars:
                                        controls: 0
                                        modestBranding: 1
                                events:
                                        onReady: @_onReady
                                        onStateChange: @_onPlayerStateChange
                                        onError: () ->
                                                console.log 'error', arguments

                componentWillReceiveProps: (props) ->
                        if @state.yt && props.videoId && props.videoId != @props.videoId
                                if @state.player
                                        @state.player.stopVideo()
                                        @state.player.loadVideoById(props.videoId)
                                else
                                        @setState player: @_createPlayer(props.videoId)

                componentDidMount: ->
                        dfd.done (YT) =>
                                @setState yt: YT
                                if @props.videoId
                                        @setState player: @_createPlayer()

                getInitialState: ->
                        id = 'youtube-player-' + (idCounter++)
                        { state: 'loading', play: @props.play , player: null, node: id}

                render: ->
                        placeholder = if @props.videoId
                                DOM.span {}, 'loading a video'
                        else
                                DOM.span {}, 'load a video'
                        (DOM.div { className: 'youtube', id: @state.node }, placeholder)
