require.config({
    baseUrl: '/',
    paths: {
        jquery: 'lib/jquery',
        'coffee-script': 'lib/coffee-script',
        'cs': 'lib/cs'
    }
});

require(['cs!src/app'], function() {
})
