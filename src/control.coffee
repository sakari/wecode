define ['lib/react'], ({createClass, DOM}) ->
        createClass
                _command: (e) ->
                        this.props.commands.push({ mode: e.target.value})

                _setPlaybackRate: (e) ->
                        this.props.commands.push({ 'playback-rate': e.target.value })

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
