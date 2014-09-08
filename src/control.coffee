define ['react',
        'bootstrap',
        'cs!src/tagger'],
({createClass, DOM}, {Button, Input, ButtonGroup, DropdownButton, MenuItem}, tagger) ->
        createClass
                _command: (e) ->
                        this.props.events.push({ mode: e.target.value})
                _step: (e) ->
                        d = if e.target.value == 'step-back'
                                -0.05
                        else
                                0.05
                        @props.events.push { step: d }

                _setPlaybackRate: (e) ->
                        @props.events.push({ 'playback-rate': e.target.text})

                _playbackRateSelector: ->
                        options = for rate in @props.allowedPlaybackRates
                                MenuItem { value: rate, onClick: @_setPlaybackRate }, rate
                        DropdownButton { title: @props.selectedPlaybackRate, className: 'glyphicon glyphicon-time', onClick: @_setPlaybackRate }, options

                render: ->
                        ButtonGroup {},
                                (Button { value: 'play', onClick: @_command, className: 'glyphicon glyphicon-play'}),
                                (Button { value: 'pause', onClick: @_command, className: 'glyphicon glyphicon-pause'}),
                                (Button { value: 'stop', onClick: @_command, className: 'glyphicon glyphicon-stop'}),
                                (Button { value: 'step-back', onClick: @_step, className: 'glyphicon glyphicon-step-backward'}),
                                (Button { value: 'step-forward', onClick: @_step, className: 'glyphicon glyphicon-step-forward'}),
                                (tagger { events: @props.events } ),
                                @_playbackRateSelector()
