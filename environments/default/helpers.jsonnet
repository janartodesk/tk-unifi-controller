{
    k:: {
        labels: {
            new(app, component): {
                'app.kubernetes.io/name': app,
                'app.kubernetes.io/component': component,
            },
        },
        labelSelector: {
            new(app, component): {
                matchLabels: {
                    'app.kubernetes.io/name': app,
                    'app.kubernetes.io/component': component,
                },
            },
        },
        serviceName: {
            new(app, component): app + '-' + component,
        }
    },
}
