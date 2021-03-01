//
//  SBBasePeriferalModel.swift
//  Smart-bike
//
//  Created by Pascale Beaulac on 2021-02-22.
//

import Foundation
import CoreBluetooth

class SBBasePeriferalModel: NSObject, ObservableObject{
    @Published private(set) var batteryLevel: UInt8?
    @Published private(set) var name: String?
    internal var periferalController: SBPreripheralController
    internal var peripheral: CBPeripheral
    //Characetristics
    private static let kBattery = "180F"
    private static let kBatteryLevel = CBUUID(string: "2A19")
    //Services
    
    required init(_ peripheral: CBPeripheral, controller : SBPreripheralController)
    {
        self.name = peripheral.name
        self.periferalController = controller
        self.peripheral = peripheral
        super.init()
        self.peripheral.delegate = self
        self.setupServices()
    }
    
    func setupServices()
    {
        peripheral.discoverServices([CBUUID(string: SBBasePeriferalModel.kBattery)])
    }
}

extension SBBasePeriferalModel: CBPeripheralDelegate
{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
      guard let characteristics = service.characteristics else { return }

      for characteristic in characteristics {
        if characteristic.properties.contains(.read) {
          print("\(characteristic.uuid): properties contains .read")
        }
        if characteristic.properties.contains(.notify) {
          print("\(characteristic.uuid): properties contains .notify")
        }
        peripheral.readValue(for: characteristic)
      }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
      switch characteristic.uuid {
      case CBUUID(string: "2A19"):
          print(characteristic.value ?? "no value")
        guard let data: Data = characteristic.value else {
            return
        }
        var level : UInt8
        (level, _) = data.scanValueFromData(invalid: UInt8.max)
        print("Level : \(level)")
        self.batteryLevel = level
        default:
          print("Unhandled Characteristic UUID: \(characteristic.uuid)")
      }
    }
}

final class SBRecorderPeripheralModel: SBBasePeriferalModel
{
    @Published private(set) var firmwareVersion: String?
    @Published private(set) var memoryUsage: Int?
    @Published private(set) var numberOfRides: Int?
    @Published private(set) var numberOfAntDevice: Int?
    
   
}
