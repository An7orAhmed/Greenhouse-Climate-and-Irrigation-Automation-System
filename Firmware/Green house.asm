
_StartSignal:

;Green house.c,25 :: 		void StartSignal(){
;Green house.c,26 :: 		DataDir = 0; // Data port is output
	BCF        TRISC0_bit+0, BitPos(TRISC0_bit+0)
;Green house.c,27 :: 		Data = 0;
	BCF        RC0_bit+0, BitPos(RC0_bit+0)
;Green house.c,28 :: 		delay_ms(18);
	MOVLW      24
	MOVWF      R12+0
	MOVLW      95
	MOVWF      R13+0
L_StartSignal0:
	DECFSZ     R13+0, 1
	GOTO       L_StartSignal0
	DECFSZ     R12+0, 1
	GOTO       L_StartSignal0
;Green house.c,29 :: 		Data = 1;
	BSF        RC0_bit+0, BitPos(RC0_bit+0)
;Green house.c,30 :: 		delay_us(30);
	MOVLW      9
	MOVWF      R13+0
L_StartSignal1:
	DECFSZ     R13+0, 1
	GOTO       L_StartSignal1
	NOP
	NOP
;Green house.c,31 :: 		DataDir = 1; // Data port is input
	BSF        TRISC0_bit+0, BitPos(TRISC0_bit+0)
;Green house.c,32 :: 		}
L_end_StartSignal:
	RETURN
; end of _StartSignal

_CheckResponse:

;Green house.c,34 :: 		unsigned short CheckResponse(){
;Green house.c,35 :: 		TOUT = 0;
	CLRF       _TOUT+0
;Green house.c,36 :: 		TMR2 = 0;
	CLRF       TMR2+0
;Green house.c,37 :: 		T2CON.TMR2ON = 1; // start timer
	BSF        T2CON+0, 2
;Green house.c,38 :: 		while(!Data && !TOUT);
L_CheckResponse2:
	BTFSC      RC0_bit+0, BitPos(RC0_bit+0)
	GOTO       L_CheckResponse3
	MOVF       _TOUT+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_CheckResponse3
L__CheckResponse36:
	GOTO       L_CheckResponse2
L_CheckResponse3:
;Green house.c,39 :: 		if (TOUT) return 0;
	MOVF       _TOUT+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_CheckResponse6
	CLRF       R0+0
	GOTO       L_end_CheckResponse
L_CheckResponse6:
;Green house.c,41 :: 		TMR2 = 0;
	CLRF       TMR2+0
;Green house.c,42 :: 		while(Data && !TOUT);
L_CheckResponse8:
	BTFSS      RC0_bit+0, BitPos(RC0_bit+0)
	GOTO       L_CheckResponse9
	MOVF       _TOUT+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_CheckResponse9
L__CheckResponse35:
	GOTO       L_CheckResponse8
L_CheckResponse9:
;Green house.c,43 :: 		if (TOUT) return 0;
	MOVF       _TOUT+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_CheckResponse12
	CLRF       R0+0
	GOTO       L_end_CheckResponse
L_CheckResponse12:
;Green house.c,45 :: 		T2CON.TMR2ON = 0;
	BCF        T2CON+0, 2
;Green house.c,46 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
;Green house.c,49 :: 		}
L_end_CheckResponse:
	RETURN
; end of _CheckResponse

_ReadByte:

;Green house.c,51 :: 		unsigned short ReadByte(){
;Green house.c,52 :: 		unsigned short num = 0, t;
	CLRF       ReadByte_num_L0+0
;Green house.c,53 :: 		DataDir = 1;
	BSF        TRISC0_bit+0, BitPos(TRISC0_bit+0)
;Green house.c,54 :: 		for (i=0; i<8; i++){
	CLRF       _i+0
L_ReadByte14:
	MOVLW      8
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_ReadByte15
;Green house.c,55 :: 		while(!Data);
L_ReadByte17:
	BTFSC      RC0_bit+0, BitPos(RC0_bit+0)
	GOTO       L_ReadByte18
	GOTO       L_ReadByte17
L_ReadByte18:
;Green house.c,56 :: 		TMR2 = 0;
	CLRF       TMR2+0
;Green house.c,57 :: 		T2CON.TMR2ON = 1;
	BSF        T2CON+0, 2
;Green house.c,58 :: 		while(Data);
L_ReadByte19:
	BTFSS      RC0_bit+0, BitPos(RC0_bit+0)
	GOTO       L_ReadByte20
	GOTO       L_ReadByte19
L_ReadByte20:
;Green house.c,59 :: 		T2CON.TMR2ON = 0;
	BCF        T2CON+0, 2
;Green house.c,60 :: 		if(TMR2 > 40) num |= 1<<(7-i); // If time > 40us, Data is 1
	MOVF       TMR2+0, 0
	SUBLW      40
	BTFSC      STATUS+0, 0
	GOTO       L_ReadByte21
	MOVF       _i+0, 0
	SUBLW      7
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      R1+0
	MOVLW      1
	MOVWF      R0+0
	MOVF       R1+0, 0
L__ReadByte40:
	BTFSC      STATUS+0, 2
	GOTO       L__ReadByte41
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__ReadByte40
L__ReadByte41:
	MOVF       R0+0, 0
	IORWF      ReadByte_num_L0+0, 1
L_ReadByte21:
;Green house.c,54 :: 		for (i=0; i<8; i++){
	INCF       _i+0, 1
;Green house.c,61 :: 		}
	GOTO       L_ReadByte14
L_ReadByte15:
;Green house.c,62 :: 		return num;
	MOVF       ReadByte_num_L0+0, 0
	MOVWF      R0+0
;Green house.c,63 :: 		}
L_end_ReadByte:
	RETURN
; end of _ReadByte

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Green house.c,65 :: 		void interrupt(){
;Green house.c,66 :: 		if(PIR1.TMR2IF){
	BTFSS      PIR1+0, 1
	GOTO       L_interrupt22
;Green house.c,67 :: 		TOUT = 1;
	MOVLW      1
	MOVWF      _TOUT+0
;Green house.c,68 :: 		T2CON.TMR2ON = 0; // stop timer
	BCF        T2CON+0, 2
;Green house.c,69 :: 		PIR1.TMR2IF = 0; // Clear TMR0 interrupt flag
	BCF        PIR1+0, 1
;Green house.c,70 :: 		}
L_interrupt22:
;Green house.c,71 :: 		}
L_end_interrupt:
L__interrupt43:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_lcd_out_byte:

;Green house.c,73 :: 		void lcd_out_byte(char x, char y, char byte){
;Green house.c,75 :: 		digit[0] = byte / 100 + 48;
	MOVLW      100
	MOVWF      R4+0
	MOVF       FARG_lcd_out_byte_byte+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       R0+0, 0
	MOVWF      lcd_out_byte_digit_L0+0
;Green house.c,76 :: 		digit[1] = (byte % 100) / 10 + 48;
	MOVLW      100
	MOVWF      R4+0
	MOVF       FARG_lcd_out_byte_byte+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      lcd_out_byte_digit_L0+1
;Green house.c,77 :: 		digit[2] = byte % 10 + 48;
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_lcd_out_byte_byte+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      lcd_out_byte_digit_L0+2
;Green house.c,78 :: 		digit[3] = 0;
	CLRF       lcd_out_byte_digit_L0+3
;Green house.c,79 :: 		lcd_out(x,y,digit);
	MOVF       FARG_lcd_out_byte_x+0, 0
	MOVWF      FARG_Lcd_Out_row+0
	MOVF       FARG_lcd_out_byte_y+0, 0
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      lcd_out_byte_digit_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Green house.c,80 :: 		}
L_end_lcd_out_byte:
	RETURN
; end of _lcd_out_byte

_main:

;Green house.c,82 :: 		void main() {
;Green house.c,84 :: 		TRISB = 0b00000000;
	CLRF       TRISB+0
;Green house.c,85 :: 		TRISC = 0b00000000;
	CLRF       TRISC+0
;Green house.c,86 :: 		PORTB = 0;
	CLRF       PORTB+0
;Green house.c,87 :: 		INTCON.GIE = 1; //Enable global interrupt
	BSF        INTCON+0, 7
;Green house.c,88 :: 		INTCON.PEIE = 1; //Enable peripheral interrupt
	BSF        INTCON+0, 6
;Green house.c,90 :: 		PIE1.TMR2IE = 1; // Enable Timer2 interrupt
	BSF        PIE1+0, 1
;Green house.c,91 :: 		T2CON = 0; // Prescaler 1:1, and Timer2 is off initially
	CLRF       T2CON+0
;Green house.c,92 :: 		PIR1.TMR2IF =0; // Clear TMR INT Flag bit
	BCF        PIR1+0, 1
;Green house.c,93 :: 		TMR2 = 0;
	CLRF       TMR2+0
;Green house.c,95 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;Green house.c,96 :: 		Lcd_Cmd(_Lcd_Clear);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Green house.c,97 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Green house.c,99 :: 		lcd_out(1,1,"Soil:    %     C");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Green_32house+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Green house.c,100 :: 		lcd_chr(1,15, 223);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      223
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Green house.c,101 :: 		lcd_out(2,1,"Humidity:    %");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Green_32house+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Green house.c,103 :: 		do {
L_main23:
;Green house.c,104 :: 		StartSignal();
	CALL       _StartSignal+0
;Green house.c,105 :: 		check = CheckResponse();
	CALL       _CheckResponse+0
;Green house.c,106 :: 		if (!check);
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main26
	GOTO       L_main27
L_main26:
;Green house.c,108 :: 		RH_Byte1 = ReadByte();
	CALL       _ReadByte+0
	MOVF       R0+0, 0
	MOVWF      _RH_Byte1+0
;Green house.c,109 :: 		RH_Byte2 = ReadByte();
	CALL       _ReadByte+0
	MOVF       R0+0, 0
	MOVWF      _RH_Byte2+0
;Green house.c,110 :: 		T_Byte1 = ReadByte();
	CALL       _ReadByte+0
	MOVF       R0+0, 0
	MOVWF      _T_Byte1+0
;Green house.c,111 :: 		T_Byte2 = ReadByte();
	CALL       _ReadByte+0
	MOVF       R0+0, 0
	MOVWF      _T_Byte2+0
;Green house.c,112 :: 		CheckSum = ReadByte();
	CALL       _ReadByte+0
	MOVF       R0+0, 0
	MOVWF      _CheckSum+0
;Green house.c,114 :: 		if (CheckSum == ((RH_Byte1 + RH_Byte2 + T_Byte1 + T_Byte2) & 0xFF)){
	MOVF       _RH_Byte2+0, 0
	ADDWF      _RH_Byte1+0, 0
	MOVWF      R1+0
	CLRF       R1+1
	BTFSC      STATUS+0, 0
	INCF       R1+1, 1
	MOVF       _T_Byte1+0, 0
	ADDWF      R1+0, 1
	BTFSC      STATUS+0, 0
	INCF       R1+1, 1
	MOVF       _T_Byte2+0, 0
	ADDWF      R1+0, 1
	BTFSC      STATUS+0, 0
	INCF       R1+1, 1
	MOVLW      255
	ANDWF      R1+0, 0
	MOVWF      R3+0
	MOVF       R1+1, 0
	MOVWF      R3+1
	MOVLW      0
	ANDWF      R3+1, 1
	MOVLW      0
	XORWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main46
	MOVF       R3+0, 0
	XORWF      R0+0, 0
L__main46:
	BTFSS      STATUS+0, 2
	GOTO       L_main28
;Green house.c,115 :: 		lcd_out_byte(1,12,T_Byte1);
	MOVLW      1
	MOVWF      FARG_lcd_out_byte_x+0
	MOVLW      12
	MOVWF      FARG_lcd_out_byte_y+0
	MOVF       _T_Byte1+0, 0
	MOVWF      FARG_lcd_out_byte_byte+0
	CALL       _lcd_out_byte+0
;Green house.c,116 :: 		lcd_out_byte(2,11,RH_Byte1);
	MOVLW      2
	MOVWF      FARG_lcd_out_byte_x+0
	MOVLW      11
	MOVWF      FARG_lcd_out_byte_y+0
	MOVF       _RH_Byte1+0, 0
	MOVWF      FARG_lcd_out_byte_byte+0
	CALL       _lcd_out_byte+0
;Green house.c,117 :: 		}
L_main28:
;Green house.c,118 :: 		}
L_main27:
;Green house.c,119 :: 		soil = adc_read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _soil+0
;Green house.c,120 :: 		soil = (255 - soil) / 2.55;
	MOVF       R0+0, 0
	SUBLW      255
	MOVWF      R0+0
	CLRF       R0+1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	CALL       _int2double+0
	MOVLW      51
	MOVWF      R4+0
	MOVLW      51
	MOVWF      R4+1
	MOVLW      35
	MOVWF      R4+2
	MOVLW      128
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2byte+0
	MOVF       R0+0, 0
	MOVWF      _soil+0
;Green house.c,121 :: 		lcd_out_byte(1,7, soil);
	MOVLW      1
	MOVWF      FARG_lcd_out_byte_x+0
	MOVLW      7
	MOVWF      FARG_lcd_out_byte_y+0
	MOVF       R0+0, 0
	MOVWF      FARG_lcd_out_byte_byte+0
	CALL       _lcd_out_byte+0
;Green house.c,123 :: 		if(T_Byte1 > 30) light_rly = 0;
	MOVF       _T_Byte1+0, 0
	SUBLW      30
	BTFSC      STATUS+0, 0
	GOTO       L_main29
	BCF        RC3_bit+0, BitPos(RC3_bit+0)
L_main29:
;Green house.c,124 :: 		if(T_Byte1 < 30) light_rly = 1;
	MOVLW      30
	SUBWF      _T_Byte1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main30
	BSF        RC3_bit+0, BitPos(RC3_bit+0)
L_main30:
;Green house.c,126 :: 		if(RH_Byte1 > 60) fan_rly = 0;
	MOVF       _RH_Byte1+0, 0
	SUBLW      60
	BTFSC      STATUS+0, 0
	GOTO       L_main31
	BCF        RC1_bit+0, BitPos(RC1_bit+0)
L_main31:
;Green house.c,127 :: 		if(RH_Byte1 < 50) fan_rly = 1;
	MOVLW      50
	SUBWF      _RH_Byte1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main32
	BSF        RC1_bit+0, BitPos(RC1_bit+0)
L_main32:
;Green house.c,129 :: 		if(soil > 70) motor_rly = 0;
	MOVF       _soil+0, 0
	SUBLW      70
	BTFSC      STATUS+0, 0
	GOTO       L_main33
	BCF        RC2_bit+0, BitPos(RC2_bit+0)
L_main33:
;Green house.c,130 :: 		if(soil < 30) motor_rly = 1;
	MOVLW      30
	SUBWF      _soil+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main34
	BSF        RC2_bit+0, BitPos(RC2_bit+0)
L_main34:
;Green house.c,131 :: 		} while(1);
	GOTO       L_main23
;Green house.c,132 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
