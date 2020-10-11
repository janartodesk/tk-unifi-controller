(import "helpers.jsonnet") +
(import "controller.jsonnet") +
(import "mongo.jsonnet") +
{
    _config:: {
        controller: {
            image: 'jacobalberty/unifi:6.0.23',
            ports: {
                stun: 3478,
                speedtest: 6789,
                device: 8080,
                ui: 8443,
                'portal-http': 8880,
                'portal-https': 8843,
                discovery: 10001,
            },

        },
        mongo: {
            image: 'mongo:3.6',
            ports: {
                server: 26257,
            },
        },
    },
}
