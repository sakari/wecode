define [], ->
        zero: (time) ->
                time + new Date(0).getTimezoneOffset() * 60 * 1000
        unzero: (time) ->
                time - new Date(0).getTimezoneOffset() * 60 * 1000
