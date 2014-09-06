define ['lib/Bacon'],
(Bacon) ->
        class Model
                _trigger: ->
                        @_change.push(true)
                render: (renderer) ->
                        @_renderer ||= renderer
                        @_renderer(@)
                        @
                constructor:->
                        @_change = new Bacon.Bus()
                        @_change.onValue @render.bind(@)
                        @control =
                                commands: new Bacon.Bus
                        @youtube =
                                height: '390'
                                width: '640'
                                videoId: 'Oh2TNO5CGXQ'
                                mode: 'stop'
                        @control.commands.onValue (v) =>
                                @youtube.mode = v
                                @_trigger()

        Model
