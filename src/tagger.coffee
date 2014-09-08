define ['react', 'bootstrap'],
({createClass, DOM},
{Button, Modal, OverlayMixin, Input, ButtonGroup}) ->
        createClass
                mixins: [OverlayMixin]
                getInitialState: ->
                        isModalOpen: false

                handleToggle: ->
                        @setState isModalOpen: !@state.isModalOpen

                render: ->
                        Button { onClick: @handleToggle, bsStyle: "primary", className: 'glyphicon glyphicon-tag' }

                _submitTag: (e) ->
                        @props.events.push { tag: @state.tag } if @state.tag
                        e.preventDefault()
                        @handleToggle()

                _inputTag: (e) ->
                        @setState { tag: e.target.value }

                _step: (e) ->
                        d = if e.target.value == 'step-back'
                                -1
                        else
                                1
                        @props.events.push step: d

                renderOverlay: ->
                    if !@state.isModalOpen
                        @props.events.push tagging: false
                        DOM.span {}
                    else
                        @props.events.push tagging: true
                        (Modal {  onRequestHide: @handleToggle },
                                (DOM.div { className: 'modal-body'},
                                        (ButtonGroup {},
                                                (Button { value: 'step-back', onClick: @_step, className: 'glyphicon glyphicon-step-backward'}),
                                                (Button { value: 'step-forward', onClick: @_step, className: 'glyphicon glyphicon-step-forward' })),
                                        (DOM.form { onSubmit: @_submitTag },
                                                (Input { type: 'text', placeholder: 'enter tag', onChange: @_inputTag}))),
                                (DOM.div { className: 'modal-footer'},
                                        (Button { onClick: @handleToggle }, 'Close'))
                        )
