/******************************************/
const int analogPin = A0;//index finger
const int analogPin1 = A1; // middle finger
const int analogPin2 = A2; //Fourth finger

int inputValue = 0;//variable to store the value coming from sensor A0
int inputValue1 = 0; //variable to store value from sensor A1
int inputValue2 = 0;

bool wasDown = false;
bool wasDown1 = false;
bool wasDown2 = false;
/******************************************/
void setup()
{
  Serial.begin(9600);
}
/******************************************/
void loop()
{
  inputValue = analogRead(analogPin);//read the value from the sensor

  if (inputValue > 100 && !wasDown) {
    wasDown = true;
    Serial.println("1"); //Index finger
  } else if (inputValue <= 100) {
    wasDown = false;
  }

  inputValue1 = analogRead(analogPin1);

  if (inputValue1 > 600 && !wasDown1) {
    wasDown1 = true;
    Serial.println("2"); //Middle finger
  } else if (inputValue1 <= 600) {
    wasDown1 = false;
  }

  inputValue2 = analogRead(analogPin2);

  if (inputValue2 > 100 && !wasDown2) {
    wasDown2 = true;
    Serial.println("3"); // Fourth finger
  } else if (inputValue2 <= 100) {
    wasDown2 = false;
  }


  //Serial.println(inputValue);
  //Serial.print("   ");
 // Serial.println(inputValue1);
  //Serial.print("   ");
  //Serial.print(inputValue2);
  //Serial.println();

  // delay 10 milliseconds before the next reading:
  // delay(10);

}
/*******************************************/