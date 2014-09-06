define ['lib/vis/vis',
        'jquery',
        'lib/react'],
(vis, $, {createClass, DOM}) ->
        createClass
                shouldComponentUpdate: (props, state) ->
                        unless props.position == @props.position
                                unless state.dragging
                                        @_preventDragEvent = true
                                        state.timeline.moveTo(props.position * 1000, { animate: false })
                                        @_preventDragEvent = false
                                @state.timeline.setCurrentTime(props.position * 1000)
                        false

                getInitialState: ->
                        items = new vis.DataSet([
                                {id: 1, content: 'item 1', start: 10 - 2 * 1000 * 60 * 60},
                                {id: 3, content: 'item 3', start: 1000 - 2 * 1000 * 60 * 60},
                                ])
                        opts =
                                showCurrentTime: true
                                zoomMax: 10 * 60 * 1000
                                zoomMin: 1000
                                showMajorLabels: false
                        node = $('<div>')
                        timeline = new vis.Timeline(node[0], items, opts)
                        timeline.on 'rangechanged', @_onDragEnd
                        timeline.on 'rangechange', @_onDrag
                        dragging: false
                        node: node
                        timeline: timeline

                _onDragEnd: ({start, end}) ->
                        unless @_preventDragEvent
                                at = (end.getTime() + start.getTime()) / 2
                                @state.timeline.setCurrentTime(at)
                                @props.events.push { 'timeScroll' : at }
                                @setState { dragging: false}

                _onDrag: ({start, end}) ->
                        unless @_preventDragEvent
                                @setState { dragging: true}
                                at = (end.getTime() + start.getTime()) / 2
                                @state.timeline.setCurrentTime(at)
                                @props.events.push { 'timeScroll' : at }

                componentDidMount: ->
                        $(@getDOMNode()).append(@state.node)

                render: ->
                        DOM.div {}
