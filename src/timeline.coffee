define ['lib/vis/vis',
        'jquery',
        'lib/react'],
(vis, $, {createClass, DOM}) ->
        createClass
                shouldComponentUpdate: (props, state) ->
                        unless props.position == @props.position || state.dragging
                                @_preventDragEvent = true
                                state.timeline.moveTo(props.position * 1000, { animate: false })
                                @_preventDragEvent = false
                        false

                getInitialState: ->
                        items = new vis.DataSet([
                                {id: 1, content: 'item 1', start: 10},
                                {id: 2, content: 'item 2', start: 30 },
                                {id: 3, content: 'item 3', start: 1000 },
                                ])
                        opts =
                                showCurrentTime: false
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
                                @props.events.push { 'timeScroll' : (end.getTime() + start.getTime()) / 2}
                                @setState { dragging: false}

                _onDrag: ({start, end}) ->
                        unless @_preventDragEvent
                                @setState { dragging: true}
                                @props.events.push { 'timeScroll' : (end.getTime() + start.getTime()) / 2}

                componentDidMount: ->
                        $(@getDOMNode()).append(@state.node)

                render: ->
                        DOM.div {}
