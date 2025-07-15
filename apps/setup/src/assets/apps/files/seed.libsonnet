function(setup)
    {
      "configuration": {
          "generis": {
              "filesystem": {
                  "class": "oat\\oatbox\\filesystem\\FileSystemService",
                  "options": {
                      "adapters": {
                          "default": {
                              "class": "Local",
                              "options": {
                                  "location": "/app/construct/data"
                              }
                          },
                          "memory": {
                              "class": "League\\Flysystem\\InMemory\\InMemoryFilesystemAdapter"
                          }
                      },
                      "dirs": {
                          "dataStore": "default",
                          "deliveryAssemblyExport": "default",
                          "fileUploadDirectory": "default",
                          "itemDirectory": "default",
                          "log": "default",
                          "ltiKeyChain": "default",
                          "portableElementStorage": "default",
                          "private": "default",
                          "public": "default",
                          "qtiItemImsPci": "default",
                          "qtiItempPci": "default",
                          "sharedTmp": "default",
                          "stateBackup": "default",
                          "taoQtiTest": "default",
                          "taoQtiTestSessionFilesystem": "default",
                          "taskQueueStorage": "default"
                      },
                      "filesPath": "/app/construct/data"
                  },
                  "type": "configurableService"
              },
              "log": {
                  "class": "oat\\oatbox\\log\\LoggerService",
                  "options": {
                      "logger": {
                          "class": "oat\\oatbox\\log\\logger\\TaoLog",
                          "options": {
                              "appenders": [
                                  {
                                      "class": "SingleFileAppender",
                                      "file": "/app/construct/data/mono.log",
                                      "format": "%d [%s] [%p] '%m' %f %l",
                                      "prefix": "tao",
                                      "rotation-ratio": 0,
                                      "threshold": 2
                                  }
                              ]
                          }
                      }
                  },
                  "type": "configurableService"
              },
              "persistences": {
                  "cache": {
                      "driver": "phpfile"
                  },
                  "default": {
                      "dbname": "postgres",
                      "driver": "pdo_pgsql",
                      "host": setup.dependencies.pgsql.address.host,
                      "password": "postgres",
                      "user": "postgres"
                  },
                  "deliveryExecution": {
                      "driver": "phpredis",
                      "host": setup.dependencies.redis.address.host,
                      "port": setup.dependencies.redis.address.port,
                  },
                  "metricsCache": self.deliveryExecution,
                  "serviceState": self.deliveryExecution,
                  "session": self.deliveryExecution,
              }
          },
          "global": {
              "anonymous_lang": "en-US",
              "import_data": false,
              "instance_name": "tao",
              "lang": "en-US",
              "mode": "production",
              "namespace": "https://communityedition.tao/ontologies/tao.rdf",
              "session_name": "tao",
              "timezone": "Europe/Luxembourg",
              "url": "http://construct.default.svc"
          },
          "tao": {
              "session": {
                  "class": "\\common_session_php_KeyValueSessionHandler",
                  "options": {
                      "persistence": "session"
                  },
                  "type": "configurableService"
              },
              "stateStorage": {
                  "class": "tao_models_classes_service_StateStorage",
                  "options": {
                      "persistence": "serviceState"
                  },
                  "type": "configurableService"
              }
          },
          "taoDeliverConnect": {
              "DeliverTenantService": {
                  "class": "oat\\taoDeliverConnect\\model\\DeliverTenantService",
                  "options": {
                      "tenant_api": {
                          "class": "oat\\taoDeliverConnect\\model\\api\\TenantDriverApiReader",
                          "options": {
                              "OPTION_DRIVER": "oat\\generis\\persistence\\EnvironmentVariableKVDriver"
                          }
                      }
                  },
                  "type": "configurableService"
              }
          },
          "taoDelivery": {
              "execution_service": {
                  "class": "oat\\taoDelivery\\model\\execution\\implementation\\KeyValueService",
                  "options": {
                      "persistence": "deliveryExecution"
                  },
                  "type": "configurableService"
              }
          },
          "taoLti": {
              "LtiProviderService": {
                  "class": "oat\\taoLti\\models\\classes\\LtiProvider\\LtiProviderService",
                  "options": {
                      "ltiProviderListImplementations": [
                          {
                              "class": "oat\\taoDeliverConnect\\model\\TenantLtiProviderRepository",
                              "options": []
                          },
                          {
                              "class": "oat\\taoLti\\models\\classes\\LtiProvider\\RdfLtiProviderRepository",
                              "options": []
                          },
                          {
                              "class": "oat\\taoQtiTestExport\\model\\LtiProvider\\ExportLtiProviderRepository",
                              "options": []
                          }
                      ]
                  },
                  "type": "configurableService"
              },
              "PlatformKeyChainRepository": {
                  "type": "configurableService",
                  "class": "oat\\taoLti\\models\\classes\\Security\\DataAccess\\Repository\\PlatformKeyChainRepository",
                  "options": [
                    {
                      "defaultKeyId": "1_0",
                      "defaultKeyName": "defaultPlatformKeyName",
                      "defaultPublicKeyPath": "/platform/default/public.key",
                      "defaultPrivateKeyPath": "/platform/default/private.key"
                    }
                  ]
              }
            }
      },
      "extensions": [
          "tao",
          "taoCe",
          "taoLti",
          "taoLtiConsumer",
          "taoDeliverConnect",
          "taoBackOffice",
          "taoTaskQueue"
      ],
      "postInstall": [
          {
              "class": "oat\\generis\\scripts\\tools\\ContainerCacheWarmup",
              "params": []
          },
          {
              "class": "oat\\taoTaskQueue\\scripts\\tools\\InitializeQueue",
              "params": [
                  "--broker=rds",
                  "--persistence=default"
              ]
          },
          {
              "class": "oat\\tao\\scripts\\tools\\RegisterFrontendLog"
          },
          {
              "class": "oat\\taoDeliverConnect\\scripts\\install\\SetupTaskQueue",
              "params": []
          },
          {
              "class": "oat\\taoAdvancedSearch\\scripts\\tools\\IndexCreator"
          }
      ],
      "seed": {
          "identifier": "tao"
      },
      "super-user": {
          "email": "admin@localhost",
          "firstname": "Administrator",
          "lastname": "TAOTesting",
          "login": "taoAdmin",
          "password": "TAOce2025"
      }
    }