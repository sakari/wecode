define ['react', 'bootstrap'],
({createClass, DOM},
{Button, Modal, OverlayMixin}) ->
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

                renderOverlay: ->
                    if !@state.isModalOpen
                        DOM.span {}
                    else
                        (Modal { title: "Modal heading", onRequestHide: @handleToggle},
                                (DOM.div { className: 'modal-body'}, 'modaali'),
                                (DOM.div { className: 'modal-footer'},
                                        (Button { onClick: @handleToggle }, 'Close')
                                )
                        )
