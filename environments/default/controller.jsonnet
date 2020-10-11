{
    controller: {
        serviceAccount: {
            apiVersion: 'v1',
            kind: 'ServiceAccount',
            metadata: {
                name: $.k.serviceName.new('controller', 'server'),
                labels: $.k.labels.new('controller', 'server'),
            },
        },
        service: {
            apiVersion: 'v1',
            kind: 'Service',
            metadata: {
                name: $.k.serviceName.new('controller', 'server'),
                labels: $.k.labels.new('controller', 'server'),
            },
            spec: {
                ports: [
                    {port: $._config.controller.ports[k], name: k} for k in std.objectFields($._config.controller.ports)
                ],
            },
        },
        server: {
            apiVersion: 'apps/v1',
            kind: 'StatefulSet',
            metadata: {
                name: 'controller',
                labels: $.k.labels.new('controller', 'server'),
            },
            spec: {
                serviceName: $.k.serviceName.new('controller', 'server'),
                selector: $.k.labelSelector.new('controller', 'server'),
                template: {
                    metadata: {
                        labels: $.k.labels.new('controller', 'server'),
                    },
                    spec: {
                        dnsPolicy: 'ClusterFirstWithHostNet',
                        hostNetwork: true,
                        securityContext: {
                            runAsUser: 999,
                            runAsGroup: 999,
                            fsGroup: 999,
                        },
                        serviceAccountName: $.k.serviceName.new('controller', 'server'),
                        containers: [
                            {
                                name: 'server',
                                image: $._config.controller.image,
                                command: [],
                                env: [
                                    {name: 'DB_URI', value: 'mongodb://mongo-server.default.svc:'+ $._config.mongo.ports.server +'/unifi'},
                                    {name: 'STATDB_URI', value: 'mongodb://mongo-server.default.svc:'+ $._config.mongo.ports.server +'/unifi_stat'}
                                    {name: 'DB_NAME', value: 'unifi'},
                                ],
                                ports: [
                                    {containerPort: $._config.controller.ports[k], name: k} for k in std.objectFields($._config.controller.ports)
                                ],
                                volumeMounts: [
                                    {mountPath: '/unifi/data', name: 'data'},
                                    {mountPath: '/unifi/log', name: 'log'},
                                    {mountPath: '/unifi/cert', name: 'cert'},
                                    {mountPath: '/unifi/init.d', name: 'initd'},
                                    {mountPath: '/var/run/unifi', name: 'run'},
                                ],
                            },
                        ],
                        volumes: [
                            {
                                emptyDir: {},
                                name: 'run',
                            },
                        ],
                    },
                },
                volumeClaimTemplates: [
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
                    {
                        metadata: {
                            name: 'log',
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
                    {
                        metadata: {
                            name: 'cert',
                        },
                        spec: {
                            accessModes: ['ReadWriteOnce'],
                            resources: {
                                requests: {
                                    storage: '128Mi',
                                },
                            },
                        },
                    },
                    {
                        metadata: {
                            name: 'initd',
                        },
                        spec: {
                            accessModes: ['ReadWriteOnce'],
                            resources: {
                                requests: {
                                    storage: '128Mi',
                                },
                            },
                        },
                    },
                ],
            },
        },
    },
}
