#include <Servo.h> 

Servo servo_winch_1;
Servo servo_winch_2;

int pin_light_front_1;
int pin_light_front_2;
int pin_light_front_3;
int pin_light_back_1;
int pin_light_back_2;
int pin_light_back_3;
int pin_light_roof_1;
int pin_light_roof_2;
int pin_light_roof_3;
int pin_winch_1;
int pin_winch_2;

boolean state_light_front_1;
boolean state_light_front_2;
boolean state_light_front_3;
boolean state_light_back_1;
boolean state_light_back_2;
boolean state_light_back_3;
boolean state_light_roof_1;
boolean state_light_roof_2;
boolean state_light_roof_3;

int state_winch_1;
int state_winch_2;
const int winch_safe_value = 95;
const int winch_lower_value = 106;
const int winch_lift_value = 80;

int value_read;

void setup() {
  Serial.begin(9600);

  setup_pins();
  setup_pinmodes();
  setup_states();

  servo_winch_1.attach(pin_winch_1);
  servo_winch_2.attach(pin_winch_2);
}

/*
 * Bluetooth uses pin 0, 1
 * Light front (3, 4, 5), back (7, 8, 9), roof (10, 11, 12)
 * Last light in each segment is blinking
 * Winch 5, 6, 
 */
void setup_pins() {
  pin_light_front_1 = 2;
  pin_light_front_2 = 3;
  pin_light_front_3 = 4;
  pin_light_back_1 = 7;
  pin_light_back_2 = 8;
  pin_light_back_3 = 9;
  pin_light_roof_1 = 10;
  pin_light_roof_2 = 11;
  pin_light_roof_3 = 12;
  pin_winch_1 = 5;
  pin_winch_2 = 6;
}

void setup_pinmodes() {
  pinMode(pin_light_front_1, OUTPUT);
  pinMode(pin_light_front_2, OUTPUT);
  pinMode(pin_light_front_3, OUTPUT);
  pinMode(pin_light_back_1, OUTPUT);
  pinMode(pin_light_back_2, OUTPUT);
  pinMode(pin_light_back_3, OUTPUT);
  pinMode(pin_light_roof_1, OUTPUT);
  pinMode(pin_light_roof_2, OUTPUT);
  pinMode(pin_light_roof_3, OUTPUT);
}

void setup_states() {
  state_light_front_1 = true;
  state_light_back_1 = true;
  // the others are implicitly false
  state_winch_1 = winch_safe_value;
  state_winch_2 = winch_safe_value;
}

/*
 * Front: 100-199
 * Back:  200-299
 * Roof:  300-399
 */
boolean isValueForLight(int val) {
  return val >= 100 && val < 400;
}

/*
 * Winch: 500-599
 */
boolean isValueForWinch(char val) {
  return val >= 500 && val < 600;
}

/*
 * Failsafe 0
 */
boolean isValueForFailsafe(char val) {
  return val == 0;
}

/*
 * The idea is that even is on, odd is off
 */
void manageLight(char val) {
  switch (val) {
  case 100:
    state_light_front_1 = true;
    digitalWrite(pin_light_front_1, state_light_front_1);
    break;
  case 101:
    state_light_front_1 = false;
    digitalWrite(pin_light_front_1, state_light_front_1);
    break;
  case 102:
    state_light_front_1 = true;
    digitalWrite(pin_light_front_1, state_light_front_1);
    break;
  case 103:
    state_light_front_1 = false;
    digitalWrite(pin_light_front_1, state_light_front_1);
    break;
  case 104:
    state_light_front_1 = true;
    digitalWrite(pin_light_front_1, state_light_front_1);
    break;
  case 105:
    state_light_front_1 = false;
    digitalWrite(pin_light_front_1, state_light_front_1);
    break;
  case 200:
    state_light_back_1 = true;
    digitalWrite(pin_light_back_1, state_light_back_1);
    break;
  case 201:
    state_light_back_1 = false;
    digitalWrite(pin_light_back_1, state_light_back_1);
    break;
  case 202:
    state_light_back_1 = true;
    digitalWrite(pin_light_back_1, state_light_back_1);
    break;
  case 203:
    state_light_back_1 = false;
    digitalWrite(pin_light_back_1, state_light_back_1);
    break;
  case 204:
    state_light_back_2 = true;
    digitalWrite(pin_light_back_2, state_light_back_2);
    break;
  case 205:
    state_light_back_3 = false;
    digitalWrite(pin_light_back_3, state_light_back_3);
    break;
  case 300:
    state_light_roof_1 = true;
    digitalWrite(pin_light_roof_1, state_light_roof_1);
    break;
  case 301:
    state_light_roof_2 = false;
    digitalWrite(pin_light_roof_2, state_light_roof_2);
    break;
  case 302:
    state_light_roof_3 = true;
    digitalWrite(pin_light_roof_3, state_light_roof_3);
    break;
  case 303:
    state_light_roof_1 = false;
    digitalWrite(pin_light_roof_1, state_light_roof_1);
    break;
  case 304:
    state_light_roof_2 = true;
    digitalWrite(pin_light_roof_2, state_light_roof_2);
    break;
  case 305:
    state_light_roof_3 = false;
    digitalWrite(pin_light_roof_3, state_light_roof_3);
    break;
  }
}

/*
 * The idea is that even is on, odd is off
 */
void manageWinch(char val) {
  switch (val) {
  case 500:
    servo_winch_1.write(winch_lift_value);
    break;
  case 501:
    servo_winch_1.write(winch_lower_value);
    break;
  case 502:
    servo_winch_2.write(winch_lift_value);
    break;
  case 503:
    servo_winch_2.write(winch_lower_value);
    break;
  }
}

/*
 * Avoid operating the winch when no bluetooth signals
 */
void winchFailsafe() {
  servo_winch_1.write(winch_safe_value);
  servo_winch_2.write(winch_safe_value);
}

void manageFailsafe() {
  winchFailsafe();
}

void loop() {
  if (Serial.available()) {
    // value_read = (int) Serial.read();
    value_read = Serial.parseInt();
    Serial.println(value_read);
  } 
  else {
    winchFailsafe();
  }

  if (isValueForLight(value_read)) {
    manageLight(value_read);
    value_read = ' ';
  } 
  else if (isValueForWinch(value_read)) {
    manageWinch(value_read);
  } 
  else if (isValueForFailsafe(value_read)) {
    manageFailsafe();
    value_read = ' ';
  }

  delay(50);
}















