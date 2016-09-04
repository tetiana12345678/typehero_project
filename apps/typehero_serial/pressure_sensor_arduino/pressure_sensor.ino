/******************************************/
const int analogPin = A0;//index finger
const int analogPin1 = A1; // middle finger
const int analogPin2 = A2; //Fourth finger
const int analogPin3 = A3; //Pinkie finger

int finger1 = 0; //variable to store the value coming from sensor A0
int finger2 = 0; //variable to store value from sensor A1
int finger3 = 0;
int finger4 = 0;

bool finger1_down = false;
bool finger2_down = false;
bool finger3_down = false;
bool finger4_down = false;

int finger1_sense = 200;
int finger2_sense = 800;
int finger3_sense = 900;
int finger4_sense = 800;

/******************************************/
void setup()
{
  Serial.begin(9600);
}
/******************************************/
void loop()

{

  // FINGER 1
  finger1 = analogRead(analogPin);//read the value from the sensor
  if (finger1 > finger1_sense && !finger1_down) {
    finger1_down = true;
    Serial.print("1");
  } else if (finger1 <= finger1_sense) {
    finger1_down = false;
  }

  // FINGER 2
  finger2 = analogRead(analogPin1);

  if (finger2 > finger2_sense && !finger2_down) {
    finger2_down = true;
    Serial.print("2");
  } else if (finger2 <= finger2_sense) {
    finger2_down = false;
  }
//
  // FINGER 3
  finger3 = analogRead(analogPin2);

  if (finger3 > finger3_sense && !finger3_down) {
    finger3_down = true;
    Serial.print("3");
  } else if (finger3 <= finger3_sense) {
    finger3_down = false;
  }
//
  // FINGER 4
  finger4 = analogRead(analogPin3);

  if (finger4 > finger4_sense && !finger4_down) {
    finger4_down = true;
    Serial.print("4");
  } else if (finger4 <= finger4_sense) {
    finger4_down = false;
  }

  delay(100);

}
/*******************************************/
