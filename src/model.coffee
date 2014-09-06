define ['lib/Bacon'],
(Bacon) ->
        class Youtube
                constructor: ->
                        @height =  '390'
                        @width = '640'
                        @videoId = 'Oh2TNO5CGXQ'
                        @mode = 'stop'
                        @allowedPlaybackRates = new Bacon.Bus
                        @playbackRate = 1
        class Control
                constructor: ->
                        @allowedPlaybackRates = []
                        @selectedPlaybackRate =  1
                        @commands = new Bacon.Bus

        class Model
                _trigger: ->
                        @_change.push(true)
                render: (renderer) ->
                        @_renderer ||= renderer
                        @_renderer(@)
                        @
                constructor:->
                        @_change = new Bacon.Bus
                        @_change.onValue @render.bind(@)
                        @control = new Control
                        @youtube = new Youtube
                        @youtube.allowedPlaybackRates.onValue (v) =>
                                @control.allowedPlaybackRates = v
                                @_trigger()

                        @control.commands.map('.playback-rate').filter((a) -> a).onValue (v) =>
                                @youtube.playbackRate = v
                                @control.selectedPlaybackRate = v
                                @_trigger()

                        @control.commands.map('.mode').filter((a) -> a).onValue (v) =>
                                @youtube.mode = v
                                @_trigger()

        Model
