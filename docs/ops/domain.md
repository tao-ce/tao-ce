# Custom DNS

If you want to change public name of your instance, you can edit [`/etc/tao-ce/config/tao.yaml`](/etc/tao-ce/config/tao.yaml) and change `spec.publicDomain`.

It is recommended to edit this file before running building/deployment, as it may change several URL accross configuration and databases.