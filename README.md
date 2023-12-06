Pico Reboot
===========

A small utility to send a reboot request to a Raspberry Pi Pico.

Uploading code to a Pico board involves resetting the board by plugging the USB cable
while holding down the boot button. This can be annoying for quick compile-upload cycles
and can be stressful for the hardware itself.

The Pico standard library can, if enabled, respond do a reboot request via USB and reboot
the device in either `flash` mode, just rebooting the device to the currently uploaded app,
or in `bootsel` mode, to boot into the boot loader, akin to plugging the Pico while
holding the 'boot' button.

**Note**: The reboot request handling is opt-in, and requires the pico application to be
properly setup for it. Check the Pico SDK documentation for more information.

Additionally, the Pico bootloader **does not** handle reboot requests, so if the device
is currently in `bootsel` mode (you can see the USB media for uploading .uf2 files), the
reboot request will **not** be handled, and no reboot occurs.


Usage
-----

By default, invoking the command will issue a request to boot to `bootsel`.

    willy@Hitagi pico-reboot main$ pico-reboot
    USB Reset tool
    Opening device...
    Claiming interface...
    Requesting reboot to bootsel...
    Done
    willy@Hitagi pico-reboot main$ 


Use the `--mode` argument to specify either `bootsel` or `flash`

    USAGE: pico-reboot [--mode <mode>]

    OPTIONS:
      -m, --mode <mode>       reset mode: 'bootsel' or 'flash' (default: bootsel)
      -h, --help              Show help information.

