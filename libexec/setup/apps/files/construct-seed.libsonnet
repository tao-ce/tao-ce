function(setup)
  {
    seed: {
      identifier: 'tao',
    },

    extensions: [
      'tao',
      'taoCe',
      'taoLti',
      'taoLtiConsumer',
      'taoDeliverConnect',
      'taoBackOffice',
      'taoTaskQueue',
      'taoMediaManager',
    ],
    'super-user': {
      lastname: 'TAOTesting',
      firstname: 'Administrator',
      email: 'admin@localhost',
      login: 'taoAdmin',
      password: 'TAOce2025',
    },
    configuration: {
      global: {
        lang: 'en-US',
        anonymous_lang: self.lang,
        mode: 'demo',
        instance_name: 'tao',
        session_name: 'tao',
        namespace: 'https://communityedition.tao/ontologies/tao.rdf',
        url: 'http://construct.default.svc',
        timezone: 'Europe/Luxembourg',
        import_data: false,
      },
      generis: {

        filesystem: {
          type: 'configurableService',
          class: 'oat\\oatbox\\filesystem\\FileSystemService',
          options: {
            filesPath: '%s/construct/data' % setup.dirs.varlib,
            adapters: {
              default: { class: 'Local', options: { location: '%s/construct/data' % setup.dirs.varlib } },
              memory: { class: 'League\\Flysystem\\InMemory\\InMemoryFilesystemAdapter' },
            },
            dirs: {
              taskQueueStorage: 'default',
              fileUploadDirectory: 'default',
              public: 'default',
              private: 'default',
              log: 'default',
              sharedTmp: 'default',
              stateBackup: 'default',
              ltiKeyChain: 'default',
              itemDirectory: 'default',
              taoQtiTest: 'default',
              taoQtiTestSessionFilesystem: 'default',
              deliveryAssemblyExport: 'default',
              qtiItempPci: 'default',
              qtiItemImsPci: 'default',
              portableElementStorage: 'default',
              dataStore: 'default',
              revisions: 'default',
              dataStoreQTITests: 'default',
            },
          },
        },
        persistences: {

          local redis = {
            driver: 'phpredis',
            host: setup.dependencies.redis.address.host,
            port: setup.dependencies.redis.address.port,
          },

          default: {
            driver: 'pdo_pgsql',
            host: setup.dependencies.pgsql.address.host,
            dbname: 'postgres',
            user: 'postgres',
            password: 'postgres',
          },
          cache: { driver: 'phpfile' },
          deliveryExecution: redis,
          serviceState: redis,
          session: redis,
          metricsCache: redis,
        },
        log: {
          type: 'configurableService',
          class: 'oat\\oatbox\\log\\LoggerService',
          options: {
            logger: {
              class: 'oat\\oatbox\\log\\logger\\TaoLog',
              options: {
                appenders: [{
                  class: 'SingleFileAppender',
                  file: 'php://stderr',
                  format: "%d [%s] [%p] '%m' %f %l",
                  threshold: 2,
                  prefix: 'tao',
                  'rotation-ratio': 0,
                }],
              },
            },
          },
        },
      },
      taoDelivery: {
        execution_service: {
          type: 'configurableService',
          class: 'oat\\taoDelivery\\model\\execution\\implementation\\KeyValueService',
          options: {
            persistence: 'deliveryExecution',
          },
        },
      },
      tao: {
        stateStorage: {
          type: 'configurableService',
          class: 'tao_models_classes_service_StateStorage',
          options: {
            persistence: 'serviceState',
          },
        },
        session: {
          type: 'configurableService',
          class: '\\common_session_php_KeyValueSessionHandler',
          options: {
            persistence: 'session',
          },
        },
      },
      taoLti: {
        LtiProviderService: {
          type: 'configurableService',
          class: 'oat\\taoLti\\models\\classes\\LtiProvider\\LtiProviderService',
          options: {
            ltiProviderListImplementations: [
              {
                class: 'oat\\taoDeliverConnect\\model\\TenantLtiProviderRepository',
                options: [],
              },
              {
                class: 'oat\\taoLti\\models\\classes\\LtiProvider\\RdfLtiProviderRepository',
                options: [],
              },
              {
                class: 'oat\\taoQtiTestExport\\model\\LtiProvider\\ExportLtiProviderRepository',
                options: [],
              },
            ],
          },
        },
        PlatformKeyChainRepository: {
          type: 'configurableService',
          class: 'oat\\taoLti\\models\\classes\\Security\\DataAccess\\Repository\\PlatformKeyChainRepository',
          options: [
            {
              defaultKeyId: '1_0',
              defaultKeyName: 'defaultPlatformKeyName',
              defaultPublicKeyPath: '/platform/default/public.key',
              defaultPrivateKeyPath: '/platform/default/private.key',
            },
          ],
        },
      },
      taoDeliverConnect+: {
        DeliverTenantService: {
          type: 'configurableService',
          class: 'oat\\taoDeliverConnect\\model\\DeliverTenantService',
          options: {
            tenant_api: {
              class: 'oat\\taoDeliverConnect\\model\\api\\TenantDriverApiReader',
              options: {
                OPTION_DRIVER: 'oat\\generis\\persistence\\EnvironmentVariableKVDriver',
              },
            },
          },
        },
      },
    },
    postInstall: [
      {
        class: 'oat\\generis\\scripts\\tools\\ContainerCacheWarmup',
        params: [],
      },
      {
        class: 'oat\\taoTaskQueue\\scripts\\tools\\InitializeQueue',
        params: [
          '--broker=rds',
          '--persistence=default',
        ],
      },
      {
        class: 'oat\\tao\\scripts\\tools\\RegisterFrontendLog',
      },
      {
        class: 'oat\\taoDeliverConnect\\scripts\\install\\SetupTaskQueue',
        params: [],
      },
      {
        class: 'oat\\taoAdvancedSearch\\scripts\\tools\\IndexCreator',
      },
    ],
  }
