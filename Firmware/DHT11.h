
char _Check = 0;

void StartSignal(){
  DHT11_dir = 0;
  DHT11 = 0;
  delay_ms(18);
  DHT11 = 1;
  delay_us(30);
  DHT11_dir = 1;
}

void CheckResponse(){
  _Check = 0;
  delay_us(40);
  if(DHT11 == 0){
    delay_us(80);
    if(DHT11 == 1) _Check = 1;
    delay_us(40);
  }
}

char ReadData(){
  char i, j;
  for(j = 0; j < 8; j++){
    while(!DHT11);
    delay_us(30);
    if(DHT11 == 0)
       i&= ~(1 << (7 - j));
    else {
      i|= (1 << (7 - j));
      while(DHT11);
    }
  }
  return i;
}

int DHT11_read(){
  char Temp, RH, Sum;
  StartSignal();
  CheckResponse();
  if(_Check == 1){
    RH = ReadData();
    ReadData();
    Temp = ReadData();
    ReadData();
    Sum = ReadData();
    if(Sum == (RH + Temp)){
      return (RH << 8) + Temp;
    }
  }
}