``` php
GWT::add('testing http api1', function ($tester) {
    $request = $tester->httpRequest();
    $request->setPath('/v1/admins');
    $request->setVerb('GET');

    return $request;
}, function ($request, $tester) {
    $response = $tester->http($request);

    return $response->success(200);
}, true);

GWT::add('testing http api2', function ($tester) {
    $server = $tester->httpServer();
    $server->addr = Env::get('HTTP_TESTING_SERVER_ADDR');
    $server->port = Env::get('HTTP_TESTING_SERVER_PORT', 80);
    $server->ssl = Env::get('HTTP_TESTING_SERVER_SSL', false);

    return $server;
}, function ($server, $tester) {
    $request = $tester->httpRequest();
    $request->setPath('/v1/admins');
    $request->setVerb('GET');

    $response = $tester->curl($server, $request);

    return $response->success(200);
}, true);
```
