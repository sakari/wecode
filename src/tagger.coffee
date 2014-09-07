define ['react', 'bootstrap'],
({createClass, DOM},
{Button, Modal, OverlayMixin, Input}) ->
        createClass
                mixins: [OverlayMixin]
                getInitialState: ->
                        isModalOpen: false
                handleToggle: ->
                    @setState(
                        isModalOpen: !@state.isModalOpen
                        )

                render: ->
                        Button { onClick: @handleToggle, bsStyle: "primary" }, 'Tag'

                _submitTag: (e) ->
                        @props.events.push { tag: @state.tag } if @state.tag
                        e.preventDefault()
                        @handleToggle()

                _inputTag: (e) ->
                        @setState { tag: e.target.value }

                renderOverlay: ->
                    if !@state.isModalOpen
                        DOM.span {}
                    else
                        (Modal {  onRequestHide: @handleToggle },
                                (DOM.div { className: 'modal-body'},
                                        (DOM.form { onSubmit: @_submitTag },
                                                (Input { type: 'text', placeholder: 'tag', onChange: @_inputTag}))),
                                (DOM.div { className: 'modal-footer'},
                                        (Button { onClick: @handleToggle }, 'Close'))
                        )
