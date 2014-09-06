define ['lib/react'], ({createClass, DOM}) ->
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
                        DOM.select { value: @props.selectedPlaybackRate, onChange: @_setPlaybackRate }, options
                render: ->
                        DOM.div {},
                                (DOM.input { type: 'button', value: 'play', onClick: @_command }),
                                (DOM.input { type: 'button', value: 'pause', onClick: @_command }),
                                (DOM.input { type: 'button', value: 'stop', onClick: @_command }),
                                @_playbackRateSelector(),
                                (DOM.input { type: 'button', value: 'step-back', onClick: @_step}),
                                (DOM.input { type: 'button', value: 'step-forward', onClick: @_step}),
