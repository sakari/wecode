define ['lib/react'], ({createClass, DOM}) ->
        createClass
                _command: (e) ->
                        this.props.commands.push(e.target.value)
                render: ->
                        DOM.div {},
                                (DOM.input { type: 'button', value: 'play', onClick: @_command }),
                                (DOM.input { type: 'button', value: 'pause', onClick: @_command }),
                                (DOM.input { type: 'button', value: 'stop', onClick: @_command }),
