import urllib.request
import json
import time
import subprocess
import os

ipad = "192.168.1.56"
#example string of output
""""
{
  "smr_version": 42,
  "meter_model": "Kaifa KAIFA-METER",
  "wifi_ssid": "linksys320",
  "wifi_strength": 100,
  "total_power_import_t1_kwh": 12860.876,
  "total_power_import_t2_kwh": 8058.464,
  "total_power_export_t1_kwh": 0,
  "total_power_export_t2_kwh": 0,
  "active_power_w": 287,
  "active_power_l1_w": 288,
  "active_power_l2_w": null,
  "active_power_l3_w": null,
  "total_gas_m3": 8132.804,
  "gas_timestamp": 221122090000
}
"""""
while True:
    try:
        with urllib.request.urlopen("http://" + ipad + "/api/v1/data") as url:
            data = json.load(url)
            activekwh = data["active_power_w"]
            print(activekwh)
        with open('kwhnow.txt', 'w') as f:
            f.write(str(activekwh))
        output = subprocess.call([os.getcwd() + '/KWh_TO_LED.sh'])
        #print(output)
        time.sleep(10)
    except Exception:
        time.sleep(10)
