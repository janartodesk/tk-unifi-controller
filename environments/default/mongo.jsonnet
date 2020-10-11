{
    mongo: {
        serviceAccount: {
            apiVersion: 'v1',
            kind: 'ServiceAccount',
            metadata: {
                name: $.k.serviceName.new('mongo', 'server'),
                labels: $.k.labels.new('mongo', 'server'),
            },
        },
        service: {
            apiVersion: 'v1',
            kind: 'Service',
            metadata: {
                name: $.k.serviceName.new('mongo', 'server'),
                labels: $.k.labels.new('mongo', 'server'),
            },
            spec: {
                ports: [
                    {port: $._config.mongo.ports.server, name: 'server'},
                ],
            },
        },
        server: {
            apiVersion: 'apps/v1',
            kind: 'StatefulSet',
            metadata: {
                name: 'mongo',
                labels: $.k.labels.new('mongo', 'server'),
            },
            spec: {
                serviceName: $.k.serviceName.new('mongo', 'server'),
                selector: $.k.labelSelector.new('mongo', 'server'),
                template: {
                    metadata: {
                        labels: $.k.labels.new('mongo', 'server'),
                    },
                    spec: {
                        dnsPolicy: 'ClusterFirstWithHostNet',
                        hostNetwork: true,
                        securityContext: {
                            runAsUser: 999,
                            runAsGroup: 999,
                            fsGroup: 999,
                        },
                        serviceAccountName: $.k.serviceName.new('mongo', 'server'),
                        containers: [
                            {
                                name: 'server',
                                image: $._config.mongo.image,
                                command: [],
                                ports: [
                                    {containerPort: $._config.mongo.ports[k], name: k} for k in std.objectFields($._config.mongo.ports)
                                ],
                                volumeMounts: [
                                    {
                                        mountPath: '/data/configdb',
                                        name: 'config',
                                    },
                                    {
                                        mountPath: '/data/db',
                                        name: 'data',
                                    },
                                ],
                            },
                        ],
                    },
                },
                volumeClaimTemplates: [
                    {
                        metadata: {
                            name: 'config',
                        },
                        spec: {
                            accessModes: ['ReadWriteOnce'],
                            resources: {
                                requests: {
                                    storage: '512Mi',
                                },
                            },
                        },
                    },
                    {
                        metadata: {
                            name: 'data',
                        },
                        spec: {
                            accessModes: ['ReadWriteOnce'],
                            resources: {
                                requests: {
                                    storage: '2Gi',
                                },
                            },
                        },
                    },
                ],
            },
        },
    },
}
