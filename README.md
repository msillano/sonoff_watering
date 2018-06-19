# sonoff_watering
Complete DIY project of an irrigation timer, better than many commercial timers

Tired of changing the terrace irrigation timer every 2 years, I decided to design a timer: obviously IoT and based on MQTT. 

The result is this complete DIY project of an irrigation timer, better than many commercial timers, designed and manufactured according to the state of the art. 

This timer contains a STA (WIFI client), an AP (not used), a MQTT client and a MQTT server (broker), provided with programmable logic (script): in practice a mini mosquitto + node-red on-board ! 

So in this project the operating logic is all internal: an external MQTT server 24/7 is not required (in fact I think a server 24/7 is too much to water a terrace!). The timer is totally autonomous, but at the same time always compatible with external standard MQTT clients and brokers. 

A probe monitors the state of the soil (dry/soaked, with adjustable threshold) and conditions the watering. 

Monitoring and configuration of the timer are performed with MQTT clients with dashboards, both on a PC and on a smartphone. Access is local via WIFI, but can be made Internet global using a free dynamic DNS service (example noip: https://www.noip.com/). 

While using updated and quality components, this timer is very cheap: total cost less than € 15 (US$ 18)!  All this is made possible by the happy union of two phenomenal products: 
1) Sonoff basic, economic WIFI card with power supply, microprocessor EPS8266 and relay
2) esp_MQTT, a firmware for EPS8266 created by Martin-ger, which transforms the Sonoff-basic into a tank. 

For the full story, see watering-sonoff-enXX.pdf (english version) or watering-sonoff-itXX.pdf (versione italiana).
