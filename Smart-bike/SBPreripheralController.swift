//
//  SBPreriferalController.swift
//  Smart-bike
//
//  Created by Pascale Beaulac on 2021-02-18.
//

import Foundation
import CoreBluetooth
import Combine

enum SBPeriferalError: Error {
    case noError
    
    //    static func map(_ error: Error) -> SBPeriferalError
    //    {
    //        return (error as? SBPeriferalError) ?? .other(error)
    //    }
}


final class DeviceCandidateModel: Identifiable {
    var name: String
    var id: UUID
    
    init(_ periferal: CBPeripheral) {
        self.name = periferal.name ?? "Unamed periferal"
        self.id = periferal.identifier
    }
}

final class SBPreripheralController: NSObject, ObservableObject
{
    private var scanTimer: Timer?
    private var centralManager: CBCentralManager!
    static let shared: SBPreripheralController = SBPreripheralController()
    @Published var foundPeriferal: DeviceCandidateModel?
    @Published var connectedPeripheral: SBBasePeriferalModel?
    private var nearistPeriferal: CBPeripheral?
    private var nearestRSSI: Int = -100
    deinit {
        
    }
    override init()
    {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    func connectDevice() {
        nearistPeriferal?.delegate = self
        self.centralManager.connect(nearistPeriferal!, options: nil)
    }
    
    func starScaning()
    {
        self.foundPeriferal = nil
        if let oldTimer = self.scanTimer {
            oldTimer.invalidate()
        }
        
        scanTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer) in
            self.centralManager.stopScan()
            if let periferal = self.nearistPeriferal
            {
                self.foundPeriferal = DeviceCandidateModel(periferal)
            }
            self.scanTimer = nil
            
        })
        centralManager.scanForPeripherals(withServices: [CBUUID(string: "0000ABCD")], options: nil)
    }
    
}

extension SBPreripheralController: CBCentralManagerDelegate
{
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        if central.state == CBManagerState.poweredOn
        {
            print("BLE powered on")
        }
        else
        {
            print("Something wrong with BLE")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        if let pname = peripheral.name {
            if RSSI.intValue > self.nearestRSSI {
                nearistPeriferal = peripheral
            }
            
            print(pname)
            print("RSSI: \(RSSI)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = SBRecorderPeripheralModel(peripheral, controller: self)
    }
    
}

extension SBPreripheralController: CBPeripheralDelegate
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
        default:
          print("Unhandled Characteristic UUID: \(characteristic.uuid)")
      }
    }
}

extension Data {
    func scanValueFromData<T>(start: Int = 0, invalid: T) -> (T, Int) {
        let length = MemoryLayout<T>.size
        guard self.count >= start + length else {
            return (invalid, start+length)
        }
        return (self.subdata(in: start..<start+length).withUnsafeBytes { $0.pointee }, start+length)
    }
}
