import ArgumentParser
import Foundation
import CLibUSB

@main
struct PicoReboot: ParsableCommand {
    enum Mode: String, ExpressibleByArgument {
        case bootsel
        case flash

        var request: UInt8 {
            switch self {
            case .bootsel: return 0x01
            case .flash: return 0x02
            }
        }
    }

    @Option(name: .shortAndLong, help: "reset mode: 'bootsel' or 'flash'")
    var mode = Mode.bootsel

    mutating func run() throws {
        print("USB Reset tool")

        try libusb_init(nil).libusbError()
        defer { libusb_exit(nil) }

        let vid = UInt16(0x2e8a)
        let pid = UInt16(0x000a)
        let iface = Int32(2)
        let reqtype = UInt8(0x01)
        let windex = UInt16(iface)
        let wvalue = UInt16(0)

        print("Opening device...")
        guard let handle = libusb_open_device_with_vid_pid(nil, vid, pid) else {
            throw Errors.deviceNotFound
        }

        print("Claiming interface...")
        try libusb_claim_interface(handle, iface).libusbError()
        do {
            print("Requesting reboot to \(mode.rawValue)...")
            try libusb_control_transfer(handle, reqtype, mode.request, wvalue, windex, nil, 0, 0).libusbError()
        }
        catch let error as libusb_error {
            if error != LIBUSB_ERROR_PIPE {
                // ignore LIBUSB_ERROR_PIPE as the pico rebooting will break it
                throw error
            }
        }

        print("Done")
    }

}

extension Int32 {
    func libusbError() throws {
        guard self != 0 else { return }
        throw libusb_error(self)
    }
}

extension libusb_error: Error, CustomStringConvertible {
    public var description: String {
        String(cString: libusb_strerror(self))
    }
}

enum Errors: String, Error, CustomStringConvertible {
    var description: String { rawValue }
    case deviceNotFound = "No device found"
}
