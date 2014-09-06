require.config({
    baseUrl: '/',
    paths: {
        jquery: 'lib/jquery',
        'coffee-script': 'lib/coffee-script',
        'cs': 'lib/cs',
        'bootstrap': 'lib/react-bootstrap/react-bootstrap',
        'react': 'lib/react'
    },
    shims: {
        bootstrap: {
            deps: ['jquery']
        }
    }
});

require(['cs!src/app'], function() {
})
