#include "TimerOne.h"

const int IRLedPin = 3;

void setup() {
  pinMode(IRLedPin, OUTPUT);
  Timer1.initialize(26);
  Timer1.attachInterrupt(callback);
}

void loop() {
}

void callback() {
  digitalWrite(IRLedPin, digitalRead(IRLedPin) ^ 1);
}

