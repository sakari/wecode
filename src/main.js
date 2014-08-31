require.config({
    baseUrl: '/',
    paths: {
        'coffee-script': 'lib/coffee-script',
        'cs': 'lib/cs'
    }
});

require(['cs!src/app'], function() {
})
