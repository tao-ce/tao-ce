local default_args = {
    disk: {
        capacity:  null,
        file: 'disk.vmdk',
        uuid: null,
        format: "http://www.vmware.com/interfaces/specifications/vmdk.html#streamOptimized",
    },
    virtualId: 'tao-ce-cozy',
    product: {
        name:"TAO Community Edition",
        vendor: "Open Assessment Technologies S.A.",
        version: "latest",
        url: "https://www.taotesting.com",
        vendorUrl: "https://www.taotesting.com",
    },
    os: {
        id: '100',
        type: 'Fedora_64',
    },
    system: {
        identifier: 'tao-ce-cozy',
    },
    resources: {
        cpu: 4,
        memory: 8192,
    },
    machine: {
        uuid: null,
        name: 'tao-ce-cozy',
        description: "TAO Community Edition - Cozy"
    }
};


function(args={})
    local c_args = std.mergePatch(default_args, args);

'<?xml version="1.0"?>\n'
+ std.manifestXmlJsonml([
        'Envelope',
        {

            'ovf:version':"2.0",
            'xml:lang':"en-US",
            xmlns: "http://schemas.dmtf.org/ovf/envelope/2",
            'xmlns:ovf':"http://schemas.dmtf.org/ovf/envelope/2",
            'xmlns:rasd':"http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData",
            'xmlns:vssd':"http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_VirtualSystemSettingData",
            'xmlns:xsi':"http://www.w3.org/2001/XMLSchema-instance",
            'xmlns:vbox':"http://www.virtualbox.org/ovf/machine",
            'xmlns:epasd':"http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_EthernetPortAllocationSettingData.xsd",
            'xmlns:sasd':"http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_StorageAllocationSettingData.xsd",
        },
        [
            'References',{}, [
                'File', {
                    "ovf:id": 'file1',
                    'ovf:href': c_args.disk.file,
                    'ovfg:diskId': 'vmdisk1',
                    'ovfg:fileRef': 'file1',

                }
            ],
        ],
        [
            'DiskSection',
            [
                'Info',
                'List of virtual disks used in the package'
            ],
            [
                'Disk',
                {
                    'ovf:capacity': c_args.disk.capacity,
                    'ovf:diskId': "vmdisk1",
                    'ovf:fileRef': "file1",
                    'ovf:format': c_args.disk.format,
                    'vbox:uuid': '%s' % c_args.disk.uuid,
                }
            ],
        ],
        [
            'NetworkSection',
            [
                'Info',
                'Logical networks used in the package',
            ],
            [
                'Network', { 'ovf:name': 'Bridged' },
                [
                    'Description',
                    'Logical network used by this appliance.'   
                ]
            ],
        ],
        [
            'VirtualSystem',
            {
                'ovf:id': c_args.virtualId,
            },
            [
                'Info',
                'A virtual machine',
            ],
            [
                'ProductSection',
                [
                    'Info',
                    'Meta-information about the installed software',
                ],
                [   'Product', c_args.product.name ],
                [   'Vendor', c_args.product.vendor ],
                [   'Version', c_args.product.version ],
                [   'ProductUrl', c_args.product.url  ],
                [   'VendorUrl', c_args.product.vendorUrl ],
            ],
            [
                'OperatingSystemSection', { 'ovf:id': c_args.os.id, },
                [
                    'Info',
                    'The kind of installed guest operating system',
                ],
                [
                    'Description',
                    'Linux26_64',
                ],
                [
                    'vbox:OSType',
                    {
                        'ovf:required': "false",
                    },
                    c_args.os.type,
                ]
            ],
            [
                'VirtualHardwareSection',
                [
                    'Info',
                    'Virtual hardware requirements for a virtual machine'
                ],
                [
                    'System',
                    [ 'vssd:ElementName', 'Virtual Hardware Family', ],
                    [ 'vssd:InstanceID', '0', ],
                    [ 'vssd:VirtualSystemIdentifier', c_args.system.identifier, ],
                    [ 'vssd:VirtualSystemType', 'virtualbox-2.2', ],
                ],
                [
                    'Item',
                    [ 'rasd:Caption', '%s virtual CPU' % c_args.resources.cpu, ],
                    [ 'rasd:Description', 'Number of virtual CPUs', ],
                    [ 'rasd:InstanceID', '1', ],
                    [ 'rasd:ResourceType', '3', ],
                    [ 'rasd:VirtualQuantity', '%s' % c_args.resources.cpu, ],
                ],
                [
                    'Item',
                    [ 'rasd:AllocationUnits', 'MegaBytes', ],
                    [ 'rasd:Caption', '%s MB of memory' % c_args.resources.memory, ],
                    [ 'rasd:Description', 'Memory Size', ],
                    [ 'rasd:InstanceID', '2', ],
                    [ 'rasd:ResourceType', '4', ],
                    [ 'rasd:VirtualQuantity', '%s' % c_args.resources.memory, ],
                ],
                [
                    'Item',
                    [ 'rasd:Address', '0', ],
                    [ 'rasd:Caption', 'ideController0', ],
                    [ 'rasd:Description', 'IDE Controller', ],
                    [ 'rasd:InstanceID', '3', ],
                    [ 'rasd:ResourceType', '5', ],
                    [ 'rasd:ResourceSubType', 'PIIX4', ],
                ],
                [
                    'Item',
                    [ 'rasd:Address', '1', ],
                    [ 'rasd:Caption', 'ideController1', ],
                    [ 'rasd:Description', 'IDE Controller', ],
                    [ 'rasd:InstanceID', '4', ],
                    [ 'rasd:ResourceType', '5', ],
                    [ 'rasd:ResourceSubType', 'PIIX4', ],
                ],
                [
                    'Item',
                    [ 'rasd:Address', '0', ],
                    [ 'rasd:Caption', 'sataController0', ],
                    [ 'rasd:Description', 'SATA Controller', ],
                    [ 'rasd:InstanceID', '5', ],
                    [ 'rasd:ResourceType', '20', ],
                    [ 'rasd:ResourceSubType', 'AHCI', ],
                ],
                [
                    'Item',
                    [ 'rasd:Address', '0', ],
                    [ 'rasd:Caption', 'usb', ],
                    [ 'rasd:Description', 'USB Controller', ],
                    [ 'rasd:InstanceID', '6', ],
                    [ 'rasd:ResourceType', '23', ],
                ],
                [
                    'Item',
                    [ 'rasd:AddressOnParent', '3', ],
                    [ 'rasd:AutomaticAllocation', 'true', ],
                    [ 'rasd:Caption', 'sound', ],
                    [ 'rasd:Description', 'Sound Card', ],
                    [ 'rasd:InstanceID', '7', ],
                    [ 'rasd:ResourceType', '35', ],
                    [ 'rasd:ResourceSubType', 'ensoniq1371', ],
                ],
                [
                    'StorageItem',
                    [ 'rasd:AddressOnParent', '0', ],
                    [ 'rasd:Caption', 'disk1', ],
                    [ 'rasd:Description', 'Disk Image', ],
                    [ 'rasd:HostResource', 'ovf:/disk/vmdisk1', ],
                    [ 'rasd:InstanceID', '8', ],
                    [ 'rasd:Parent', '5', ],
                    [ 'rasd:ResourceType', '17', ],
                ],
                [
                    'EthernetPortItem',
                    [ 'rasd:AutomaticAllocation', 'true', ],
                    [ 'rasd:Caption', "Ethernet adapter on 'Bridged'", ],
                    [ 'rasd:Connection', 'Bridged', ],
                    [ 'rasd:InstanceID', '9', ],
                    [ 'rasd:ResourceType', '10', ],
                    [ 'rasd:ResourceSubType', 'E1000', ],
                ],
            ],
            [
                "vbox:Machine",
                {
                    'ovf:required': "false",
                    version: '1.19-linux',
                    uuid: '{%s}' % c_args.machine.uuid,
                    name: c_args.machine.name,
                    OSType: c_args.os.type,
                    snapshotFolder: "Snapshots", 
                },
                [
                    'ovf:Info', 'Complete VirtualBox machine configuration in VirtualBox format',
                ],
                [
                    'Description', c_args.machine.description,
                ],
                [
                    'Hardware',
                    [
                        'CPU',
                        { count: c_args.resources.cpu },
                        [ 'PAE', {enabled: 'true', } ],
                        [ 'LongMode', {enabled: 'true', } ],
                        [ 'X2APIC', {enabled: 'true', } ],
                        [ 'HardwareVirtExLargePage', {enabled: 'true', } ],
                    ],
                    [ 'Memory', { RAMSize: c_args.resources.memory }, ],
                    [ 'HID', {Pointing: "USBTablet"}, ],
                    [
                        'Boot',
                        [ 'Order', {position: "1", device: 'HardDisk', } ],
                    ],
                    [ 'Display', {controller: 'VMSVGA', VRAMSize: "128", } ],
                    [ 'VideoCapture', { screens: "1", file: ".", fps: "25"}],
                    [
                        'BIOS',
                        ['IOAPIC', {enabled: "true"}, ],
                        ['SmbiosUuidLittleEndian', {enabled: "true"}, ],
                    ],
                    [
                        'USB',
                        [
                            'Controllers',
                            [ 'Controller', {name: 'OHCI', type: 'OHCI' }],
                            [ 'Controller', {name: 'EHCI', type: 'EHCI' }],
                        ],
                    ],
                    [
                        'Network',
                        ['Adapter', {slot: "0", enabled: "true", type: "82540EM", }, ],
                    ],
                    [ "RTC", {localOrUTC: "UTC", }, ],
                    [ "Clipboard", {mode: "Bidirectional", }, ],
                    [ "DragAndDrop", {mode: "Bidirectional", }, ],
                    [ "AudioAdapter", {codec: 'AD1980', useDefault: 'true', driver: 'ALSA', enabled: 'true', enabledOut: 'true'}],
                    [
                        'StorageControllers',
                        [
                            'StorageController',
                            {
                                name: 'IDE',
                                type: 'PIIX4',
                                PortCount: "2",
                                useHostIOCache: "true",
                                Bootable: "true",
                            },
                        ],
                        [
                            'StorageController',
                            {
                                name: 'SATA',
                                type: 'AHCI',
                                PortCount: "1",
                                useHostIOCache: "false",
                                Bootable: "true",
                                IDE0MasterEmulationPort: "0",
                                IDE0SlaveEmulationPort: "1",
                                IDE1MasterEmulationPort: "2",
                                IDE1SlaveEmulationPort: "3",
                            },
                            [
                                'AttachedDevice',
                                {
                                    type: "HardDisk",
                                    hotpluggable: "false",
                                    port: "0",
                                    device: "0",
                                },
                                ['Image', {uuid: '{%s}' % c_args.disk.uuid}],
                            ]
                        ]
                    ],
                ]
            ]
        ]
    ]
)