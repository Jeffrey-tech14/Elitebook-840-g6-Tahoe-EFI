DefinitionBlock ("", "SSDT", 2, "ACDT", "_UIAC", 0)
{
    Device(UIAC)
    {
        Name(_HID, "UIA00000")

        Name(RMCF, Package()
        {
            // XHC (8086_9ded)
            "XHC", Package()
            {
                "port-count", Buffer() { 0x0E, 0x00, 0x00, 0x00 },
                "ports", Package()
                {
                    "HS01", Package()
                    {
                         "name", Buffer() { "HS01" },
                         "usb-port-type", 3,
                         "UsbConnector", 3,
                         "port", Buffer() { 0x01, 0x00, 0x00, 0x00 },
                         "usb-port-number", Buffer() { 0x01, 0x00, 0x00, 0x00 },
                    },
                    "HS02", Package()
                    {
                         "name", Buffer() { "HS02" },
                         "usb-port-type", 3,
                         "UsbConnector", 3,
                         "port", Buffer() { 0x02, 0x00, 0x00, 0x00 },
                         "usb-port-number", Buffer() { 0x02, 0x00, 0x00, 0x00 },
                    },
                    "HS03", Package()
                    {
                         "name", Buffer() { "HS03" },
                         "usb-port-type", 255,
                         "UsbConnector", 255,
                         "port", Buffer() { 0x08, 0x00, 0x00, 0x00 },
                         "usb-port-number", Buffer() { 0x08, 0x00, 0x00, 0x00 },
                    },
                    "HS04", Package()
                    {
                         "name", Buffer() { "HS04" },
                         "usb-port-type", 255,
                         "UsbConnector", 255,
                         "port", Buffer() { 0x09, 0x00, 0x00, 0x00 },
                         "usb-port-number", Buffer() { 0x09, 0x00, 0x00, 0x00 },
                    },
                    "HS05", Package()
                    {
                         "name", Buffer() { "HS05" },
                         "usb-port-type", 255,
                         "UsbConnector", 255,
                         "port", Buffer() { 0x0A, 0x00, 0x00, 0x00 },
                         "usb-port-number", Buffer() { 0x0A, 0x00, 0x00, 0x00 },
                    },
                    "SS01", Package()
                    {
                         "name", Buffer() { "SS01" },
                         "usb-port-type", 3,
                         "UsbConnector", 3,
                         "port", Buffer() { 0x0D, 0x00, 0x00, 0x00 },
                         "usb-port-number", Buffer() { 0x0D, 0x00, 0x00, 0x00 },
                    },
                    "SS02", Package()
                    {
                         "name", Buffer() { "SS02" },
                         "usb-port-type", 3,
                         "UsbConnector", 3,
                         "port", Buffer() { 0x0E, 0x00, 0x00, 0x00 },
                         "usb-port-number", Buffer() { 0x0E, 0x00, 0x00, 0x00 },
                    },
                },
            },
        })
    }
}
