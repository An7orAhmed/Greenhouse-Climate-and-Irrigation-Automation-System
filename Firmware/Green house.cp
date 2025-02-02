#line 1 "C:/Users/antor/Desktop/55. Green house control/Firmware/Green house.c"
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D7 at RB7_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D7_Direction at TRISB7_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB4_bit;





char soil;

sbit Data at RC0_bit;
sbit DataDir at TRISC0_bit;
unsigned short TOUT = 0, CheckSum, i;
unsigned short T_Byte1, T_Byte2, RH_Byte1, RH_Byte2;

void StartSignal(){
 DataDir = 0;
 Data = 0;
 delay_ms(18);
 Data = 1;
 delay_us(30);
 DataDir = 1;
}

unsigned short CheckResponse(){
 TOUT = 0;
 TMR2 = 0;
 T2CON.TMR2ON = 1;
 while(!Data && !TOUT);
 if (TOUT) return 0;
 else {
 TMR2 = 0;
 while(Data && !TOUT);
 if (TOUT) return 0;
 else {
 T2CON.TMR2ON = 0;
 return 1;
 }
 }
}

unsigned short ReadByte(){
 unsigned short num = 0, t;
 DataDir = 1;
 for (i=0; i<8; i++){
 while(!Data);
 TMR2 = 0;
 T2CON.TMR2ON = 1;
 while(Data);
 T2CON.TMR2ON = 0;
 if(TMR2 > 40) num |= 1<<(7-i);
 }
 return num;
}

void interrupt(){
 if(PIR1.TMR2IF){
 TOUT = 1;
 T2CON.TMR2ON = 0;
 PIR1.TMR2IF = 0;
 }
}

void lcd_out_byte(char x, char y, char byte){
 char digit[4];
 digit[0] = byte / 100 + 48;
 digit[1] = (byte % 100) / 10 + 48;
 digit[2] = byte % 10 + 48;
 digit[3] = 0;
 lcd_out(x,y,digit);
}

void main() {
 unsigned short check;
 TRISB = 0b00000000;
 TRISC = 0b00000000;
 PORTB = 0;
 INTCON.GIE = 1;
 INTCON.PEIE = 1;

 PIE1.TMR2IE = 1;
 T2CON = 0;
 PIR1.TMR2IF =0;
 TMR2 = 0;

 Lcd_Init();
 Lcd_Cmd(_Lcd_Clear);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 lcd_out(1,1,"Soil:    %     C");
 lcd_chr(1,15, 223);
 lcd_out(2,1,"Humidity:    %");

 do {
 StartSignal();
 check = CheckResponse();
 if (!check);
 else{
 RH_Byte1 = ReadByte();
 RH_Byte2 = ReadByte();
 T_Byte1 = ReadByte();
 T_Byte2 = ReadByte();
 CheckSum = ReadByte();

 if (CheckSum == ((RH_Byte1 + RH_Byte2 + T_Byte1 + T_Byte2) & 0xFF)){
 lcd_out_byte(1,12,T_Byte1);
 lcd_out_byte(2,11,RH_Byte1);
 }
 }
 soil = adc_read(0);
 soil = (255 - soil) / 2.55;
 lcd_out_byte(1,7, soil);

 if(T_Byte1 > 30)  RC3_bit  = 0;
 if(T_Byte1 < 30)  RC3_bit  = 1;

 if(RH_Byte1 > 60)  RC1_bit  = 0;
 if(RH_Byte1 < 50)  RC1_bit  = 1;

 if(soil > 70)  RC2_bit  = 0;
 if(soil < 30)  RC2_bit  = 1;
 } while(1);
}
