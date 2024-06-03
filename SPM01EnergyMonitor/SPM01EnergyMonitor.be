import global
import string

class SPM01EnergyMonitorDriver : Driver
  def init()
    tasmota.add_rule("TuyaReceived", /value,trigger,jsonmap->self.received(jsonmap))
    tasmota.add_driver(self)
  end
  def received(jsonmap)
    var spm01 = global.spm01
    if spm01
      spm01.tuyaReceived(jsonmap['TuyaReceived'])
    end
  end
end

class SPM01EnergyMonitor
  def tuyaReceived(jsonmap)
    if jsonmap.contains('Cmnd')
      if jsonmap['Cmnd'] == 7
        if jsonmap.contains('DpType0Id6')
          var data = bytes().fromhex( string.split(jsonmap['DpType0Id6'],2)[1])
          var voltage = data.get(0,-2)/10
          var current = data.get(2,-3)
          var power = data.get(5,-3)
          print("voltage=",voltage," current=",current," power=",power)
        end
      end
    end
  end
end

global.spm01 = SPM01EnergyMonitor()

if !global.contains("spm01driver")
  global.spm01driver = SPM01EnergyMonitorDriver()
end


