#include <SPI.h>
#include <Ethernet.h>
#include <PusherClient.h>

#define RED    6
#define GREEN  9
#define BLUE   5

int led = 13;
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
PusherClient client;
long k;

void setup() {
  pinMode(RED,OUTPUT);
  pinMode(BLUE, OUTPUT);
  pinMode(GREEN, OUTPUT);

  analogWrite(RED, 255 * 0.4);
  analogWrite(GREEN, 102 * 0.26);
  analogWrite(BLUE, 0 * 1);
  
  Serial.begin(9600);
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Init Ethernet failed");
    for(;;)
      ;
  }
  
  if(client.connect("your-pusher-key")) {
    client.bind("orange", orange);
    client.bind("blue", blue);
    client.bind("red", red);
    client.bind("purple", purple);
    client.bind("green", green);
    client.bind("chaos", chaos);
    client.subscribe("trick_channel");
  }
  else {
    while(1) {}
  }
}

void loop() {
  if (client.connected()) {
    digitalWrite(led,HIGH);
    client.monitor();
  }
  else {
    Serial.println("Client error connecting.");
  }
}

void orange(String data) {
  analogWrite(RED, 255);
  analogWrite(GREEN, 102);
  analogWrite(BLUE, 0);
}

void blue(String data) {
  analogWrite(RED, 30);
  analogWrite(GREEN, 144);
  analogWrite(BLUE, 255);
}

void red(String data) {
  analogWrite(RED, 255);
  analogWrite(GREEN, 0);
  analogWrite(BLUE, 0);
}

void green(String data) {
  analogWrite(RED, 124);
  analogWrite(GREEN, 252);
  analogWrite(BLUE, 0);
}

void purple(String data) {
  analogWrite(RED, 160);
  analogWrite(GREEN, 32);
  analogWrite(BLUE, 240);
}
void on() {
  analogWrite(RED, 125);
  analogWrite(GREEN, 125);
  analogWrite(BLUE, 125);
}
void off() {
  analogWrite(RED, 0);
  analogWrite(GREEN, 0);
  analogWrite(BLUE, 0);
}
void back() {
  analogWrite(RED, 255);
  analogWrite(GREEN, 102);
  analogWrite(BLUE, 0);
}

void chaos(String data) {
  // Strobe effect
  for (k=0; k<400; k++) {
    on();
    delay(50);
    off();
    delay(50);
  }
  back();
}