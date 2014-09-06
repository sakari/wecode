define ['react',
        'bootstrap',
        'cs!src/tagger'],
({createClass, DOM}, {Button, Input}, tagger) ->
        createClass
                _command: (e) ->
                        this.props.events.push({ mode: e.target.value})
                _step: (e) ->
                        d = {}
                        d[e.target.value] = true
                        this.props.events.push d
                _setPlaybackRate: (e) ->
                        this.props.events.push({ 'playback-rate': e.target.value })

                _playbackRateSelector: ->
                        options = for rate in @props.allowedPlaybackRates
                                DOM.option { value: rate }, rate
                        Input { type: 'select', value: @props.selectedPlaybackRate, onChange: @_setPlaybackRate }, options
                render: ->
                        DOM.div {},
                                (Button { value: 'play', onClick: @_command }, 'play'),
                                (Button { value: 'pause', onClick: @_command }, 'pause'),
                                (Button { value: 'stop', onClick: @_command }, 'stop'),
                                @_playbackRateSelector(),
                                (Button { value: 'step-back', onClick: @_step}, 'back'),
                                (Button { value: 'step-forward', onClick: @_step}, 'forward'),
                                (tagger {})
