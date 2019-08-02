#include <Keyboard.h>

int RXLED = 17;

void setup() {

  pinMode(RXLED, OUTPUT);
  delay(5000);
  Keyboard.print("hdiutil mount http://pollinate");
  Keyboard.write(10);
  Keyboard.write(13);
  delay(2000);
  Keyboard.print("/Volumes/pollinate/run");
  Keyboard.write(10);
  Keyboard.write(13);
}

void loop() {
  digitalWrite(RXLED, HIGH);
  TXLED1;
}
