//#define DEBUG // Debug prints to serial instead of SD card

//#include <string.h>
#include <EnableInterrupt.h>
// Date and time functions using a DS3231 RTC connected via I2C and Wire lib
#include <Wire.h>
#include "RTClib.h"
#include <SPI.h>
#include <SD.h>


// anemometer input pin
#define ANEMOM 8 //6 

// vane input pins
#define GREEN 5  // counting signal, leads
#define YELLOW 7 // counting signal, follows
#define ORANGE 6 // zero signal

#define VANE_STEPS 180 // total steps of vane for one 360 deg rotation
#define VANE_SCALE_FACTOR 2 // must be 360 / VANE_STEPS
#define VANE_OFFSET 132 // degrees, hardware offset of the zero relative to the vane point; must be zero in next version hardware

// Period between data reports
#define REPORT_PERIOD 60000 // calculate rate every X ms

// anemometer pulse count
unsigned long anem_last_read = millis();
volatile int anem_count = 0;

// vane angular position in terms of VANE_STEPS
volatile int pos = 0;

// vane logic flags
bool G; // current state of green
bool Y; // current state of yellow
bool Z; //  ------------    zero

// Flags whether the vane has obtained a frame of reference
bool calibrated = false;

// File object to write to
File logfile;
String filename;

// Clock object to get timestamps
RTC_DS3231 rtc;

String datapoint; // "2019-02-23_12:29:01 DDD CCCCC..."

// converts vane units to degrees of arc
int get_degrees() {
  if (calibrated) 
    return ((pos * VANE_SCALE_FACTOR) + VANE_OFFSET) % 360;  
     
  return -1;
}

// Interrupt service routines
void isr_green() {
  G = digitalRead(GREEN);
  Y = digitalRead(YELLOW);
  
  if ((G && !Y) || (!G && Y))
    pos = (pos + 1) % VANE_STEPS; 
  else
    pos = (VANE_STEPS + pos - 1) % VANE_STEPS;
}

void isr_yellow() {
  G = digitalRead(GREEN);
  Y = digitalRead(YELLOW);
  Z = digitalRead(ORANGE);
  
  if (!Z)
    calibrated = true;
    
  if ((G && !Y) || (!G && Y)) {
    if (!Z)
      pos = VANE_STEPS - 1;
    else
      pos = (VANE_STEPS + pos - 1) % VANE_STEPS;        
  }
  else {
    if (!Z)
      pos = 0;
    else
      pos = (pos + 1) % VANE_STEPS;
  }
}

void isr_anem() {
  anem_count++;
}

void setup() {
  //Serial.begin(115200);
  Serial.begin(9600);

  // Clock
  //rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
  rtc.begin();

  // SD card begin on pin 10
  if (!SD.begin(10)) 
      Serial.println("initialization failed");
  filename = "log.txt"; //get_timestamp() + ".txt";

  // Anemometer interrupt
  pinMode(ANEMOM, INPUT_PULLUP);
  enableInterrupt(ANEMOM, isr_anem, CHANGE);

  // Vane interrputs
  pinMode(GREEN, INPUT_PULLUP);
  pinMode(YELLOW, INPUT_PULLUP);
  pinMode(ORANGE, INPUT_PULLUP);  
  enableInterrupt(GREEN, isr_green, CHANGE);
  enableInterrupt(YELLOW, isr_yellow, CHANGE);
}

String get_timestamp() {
  DateTime now = rtc.now();
  return String(now.year(), DEC) + '-' + String(now.month(), DEC) + '-' + String(now.day(), DEC) + '_' + String(now.hour(), DEC) + '-' + String(now.minute(), DEC) + '-' + String(now.second(), DEC);
}

// Get a string timestamp from the clock
void update_datapoint() {
  // No idea how efficient or idiomatic this is, gave up trying to find out
  datapoint = get_timestamp() + ' ' + get_degrees() + ' ' + anem_count;
}

void loop() { 

  // Move shit away to subroutines:
  // 1. char[] get_timestamp()
  // 2. use directives to either write to Serial or to SD

  if (millis() - anem_last_read > REPORT_PERIOD) {

    // prepare data
    update_datapoint();


    // report data
    #ifdef DEBUG

    Serial.println(datapoint);
    
    #else
    
    logfile = SD.open(filename, FILE_WRITE);
    if (logfile) {
      logfile.println(datapoint);        
      logfile.close();
      //Serial.println("Wrote to file.");
    }
    //else
    //  Serial.println("Fail.");
    
    #endif
    
    // Reset anemometer counters
    anem_count = 0;
    anem_last_read = millis();
  }
 
  
}
