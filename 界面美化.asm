.586
DATA SEGMENT USE16
MESG DB 128
	 DB ?
	 DB 128 DUP(?)
LENS EQU $-MESG
OLD0B DD ?
A1 DB "   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$"
A2 DB "   *** * *  *   Transfer   *  * * ****$"
A3 DB "   designer:B20030726 zcy $"
A4 DB "   Please input the word:$"
A5 DB "   THE output:$"
A6 DB "   -----------------------------------$"
A7 DB "   $"
A8 DB "   ENTER BAUD(like 01 01 and <=01 80 >=00 0C):$";����45
A9 DB "   ENTER FRAME FORMAT(<=3F ):$";����27
;�����ʱ���
WRONGB DB "   !!! Wrong!ENTER BAUD(like 01 01 and <=01 80 >=00 0C) !!!$"
;֡��ʽ����
WRONGF DB "   !!! Wrong!PlEASE ENTER FRAME FORMAT(<=3F ) !!!$"
LINE DB 1
STRING DB 6,0,6 DUP(0);6λBUF,������Ų����ʸ�λ�͵�λ(����16��������һ���ո�)
STRINGF DB 3,0,3 DUP(0);3λ���������֡��ʽ
DATA1 DB 2 DUP(0);2λdata���ڴ��ת����Ĳ�����
DATAF DB 1 DUP(0);1λdataf���ڴ��ת�����֡��ʽ
DATA ENDS


CODE SEGMENT USE16
ASSUME CS:CODE,DS:DATA 
BEG:   
;������ʽ
    ;�����ⴰ������
    MOV   AH,7				;���ܣ���Ļ��ʼ��
    MOV   AL,0				;page
    MOV   BH,70H			;�׵׺���
    MOV   CH,1				;row����
    MOV   CL,2				;column����
    MOV   DH,23				;row����
    MOV   DL,77				;column����
    INT   10H				;BIOS��ʾ�����ж�
    
    ;�����ڴ�������
    MOV   AH,7				;���ܣ���Ļ��ʼ��
    MOV   AL,0				;page
    MOV   BH,00111111B		;ǳ��ɫ�װ���
    MOV   CH,2				;row����
    MOV   CL,4				;column����
    MOV   DH,22				;row����
    MOV   DL,75				;column����
    INT   10H				;BIOS��ʾ�����ж�
        ;���ù������(��С)
    MOV   CH,12				;�����ʼ��
    MOV   CL,13				;��������
    MOV   AH,1				;���ù������
    INT   10H				;DOS�жϣ���ʾ����
        ;��ʼ�����λ��
    MOV   DH,2				;��Ļ��ʾ��
    MOV   DL,4				;��Ļ��ʾ��
    MOV   BH,0				;��ʾҳ��
    MOV   AH,2				;�ù��λ��
    INT   10H				;BIOS��ʾ�����ж�
		MOV AX,DATA
		MOV DS,AX
		;MOV AH,0           ;������ʾ��ʽ
		;MOV AL,3           ;80*25��ɫ�ı���ʽ
		INT 10H
		;MOV AH,6
		;MOV AL,0
		;MOV CH,0
		;MOV CL,0 
		;MOV DH,80
	    ;MOV DL,80
		;MOV BH,01110000B   ;ǰ��λ���屳��ɫΪ��ɫ
		;INT 10H
		;��ʾ��~~~~~~~~~~~~~~~~~~~~~~~~~~~~~��
		ADD LINE,2
		MOV DH,LINE
		MOV DL,1
		CALL GUANGBIAO
		LEA DX,A1
		CALL OUTP
		ADD LINE,2
		;��ʾ��**** * * *  Transfer   * * * ****��
		MOV DH,LINE
		MOV DL,1
		CALL GUANGBIAO
		LEA DX,A2
		CALL OUTP
		ADD LINE,2
		;��ʾ��designer:B20030722 ��
		MOV DH,LINE
		MOV DL,8
		CALL GUANGBIAO
		LEA DX,A3
		CALL OUTP
		ADD LINE,2
		
;���벨����
;��ʾ��ɫ��ɫ�����-������(PS,Ҫ��=300)
		MOV AH,6 
		MOV AL,0
		MOV CH,LINE
		MOV CL,47         ;��ǰ�У�0�е�47��(�˴�Ϊ47��)
		MOV DH,LINE
		MOV DL,52          ;��ǰ�У�47�е�52��(�˴�Ϊ52��)
		MOV BH,00100001B   ;��ɫ��ʾΪ��ɫ
		INT 10H
;����������
		MOV DH,LINE
		MOV DL,1
		CALL GUANGBIAO
		LEA DX,A8
		ADD LINE,1;��ʾ"ENTER BAUD(like 01 01H and >=0060H):$"
        MOV AH,09H
        INT 21H        
        LEA DX,STRING           ;��ȡSTRING�ַ���ʽ������
        MOV AH,0AH
        INT 21H        
;==�ַ�ת������ֵ
;�����ַ�����ֵ��ת�������ַ���1��ת������ֵ01HΪ������
;�ַ���1����ASCII��Ϊ31H������ֻҪ��������ϼ�ȥ30H�����ɵõ���Ӧ����ֵ��
;==Ӣ���ַ�����ֵ��ת�������ַ���A��ת������ֵ0AHΪ������
;�ַ���A����ASCII��Ϊ41H��ֻҪ��������ϼ�ȥ37H�����ɵõ���Ӧ��ֵ0AH��
;�����Ĵ����У����ж�����ĸ���ȼ�ȥ07H����ͬ�����ַ�һ����ȥ30H����Ȼ���������Ƴ�������֧��ֱ�Ӽ�ȥ37H��
;==�������������߼����Ʋ��ֵĽ��ͣ�������������Ƴ�ÿ�ζ��벢ת��
;��ĵ�����ֵ�����ڶ�Ӧ����ĵ���λ�����Ե������Ѿ��������λ����
;�ݺ���������λ������ʱ��ֻ�轫ԭ�е���������4λ���ټ��ϵ�λ���ݼ��ɡ�����Ҳ������Ƴɳ�10H����ӣ�������4λЧ����ͬ����
        MOV BX,05H              ;Ŀ���ȡ�����ݸ���
        MOV SI,02H              ;����ָ��STRING
        MOV DI,00H              ;����ָ��DATA1
        MOV CL,04H
TRANS1: MOV DL,STRING[SI]       ;���ζ�ȡSTRING�е��ַ�
        CMP DL,20H              ;�ո��ASCII��Ϊ20H 
        JE NEXT1                ;���ǿո����ת��NEXT1
        CMP DL,0DH              ;�س���ASCII��Ϊ0DH
        JE NEXT1                ;���ǻس�����ת��NEXT1
        CMP DL,3AH              
        JB NEXT0                ;������ĸ�����ȥ07H���������֣���ת��NEXT0
        SUB DL,07H        
NEXT0:  SUB DL,30H              ;��ȥ30H����ASCIIתΪ��ֵ
        SHL DATA1[DI],CL        ;�߼�����4λ�����
        ADD DATA1[DI],DL
        INC SI
        JMP NEXT2
NEXT1:  INC DI					;�����ո���ǻس���ʾһ������ת����ɣ���ʱDI��һ��ָ����һ���洢��ֵ��λ��
        INC SI
NEXT2:  CMP BX,DI				;�ж����������Ƿ�ת�����
        JNE TRANS1 
		
		
;֡��ʽ��ʾ��ɫ��ɫ�����-֡��ʽ
		MOV AH,6 
		MOV AL,0
		MOV CH,LINE
		MOV CL,30          ;��ǰ�У�0�е�30��(�˴�Ϊ30��)
		MOV DH,LINE
		MOV DL,31          ;��ǰ�У�30�е�31��(�˴�Ϊ31��)
		MOV BH,00100001B   ;��ɫ��ʾΪ��ɫ
		INT 10H
;��ʾ��ENTER FRAME FORMAT(like 03):$��
INPUTF:
		MOV DH,LINE
		MOV DL,1
		CALL GUANGBIAO
		LEA DX,A9
		ADD LINE,1;��ʾ"ENTER FRAME FORMAT(like 03):$"
        MOV AH,09H
        INT 21H        
        LEA DX,STRINGF           ;��ȡSTRINGF�ַ���ʽ������
        MOV AH,0AH
        INT 21H        
;�ַ�ת������ֵ
        MOV BX,05H              ;Ŀ���ȡ�����ݸ���
        MOV SI,02H              ;����ָ��STRING
        MOV DI,00H              ;����ָ��DATAF
        MOV CL,04H
TRANS1F: MOV DL,STRINGF[SI]       ;���ζ�ȡSTRINGF�е��ַ�
        CMP DL,20H              ;�ո��ASCII��Ϊ20H 
        JE NEXT1F               ;���ǿո����ת��NEXT1F
        CMP DL,0DH              ;�س���ASCII��Ϊ0DH
        JE NEXT1F                ;���ǻس�����ת��NEXT1F
        CMP DL,3AH              
        JB NEXT0F                ;������ĸ�����ȥ07H���������֣���ת��NEXT0
        SUB DL,07H        
NEXT0F:  SUB DL,30H              ;��ȥ30H����ASCIIתΪ��ֵ
        SHL DATAF[DI],CL        ;�߼�����4λ�����
        ADD DATAF[DI],DL
        INC SI
        JMP NEXT2F
NEXT1F:  INC DI					;�����ո���ǻس���ʾһ������ת����ɣ���ʱDI��һ��ָ����һ���洢��ֵ��λ��
        INC SI
NEXT2F:  CMP BX,DI				;�ж����������Ƿ�ת�����
        JNE TRANS1F            
;֡��ʽ�������
;MOV BX,OFFSET DATAF[1]
;CMP WORD PTR [BX],3FH    ;�����֡��ʽ�������3FH�ͱ���
;JA ERRORF
;��ʾ������ʾ��Ϣ
;ERRORF:;֡��ʽ����
	;MOV AH,6 
	;MOV AL,0
	;MOV CH,LINE
	;MOV CL,4           ;��ǰ�У�23�е�30�У�����8λ�ַ���
	;MOV DH,LINE
	;MOV DL,60
	;MOV BH,01000001B   ;��ɫ��ʾΪ��ɫ
	;INT 10H
	;MOV DL,1
	;CALL GUANGBIAO
	;LEA DX,WRONGF
	;CALL OUTP
	;INC LINE
	;JMP INPUTF
;EXIT1: MOV AH,4CH
	;INT 21H


;����Ҫ�ڲ����ʺ�֡��ʽ�����ˣ����޸ģ����޸�
;��ʾ��ɫ��ɫ�����-input the word
		MOV AH,6 
		MOV AL,0
		MOV CH,LINE
		MOV CL,26          ;��ǰ�У�0�е�26��(�˴�Ϊ26��)
		MOV DH,LINE
		MOV DL,75          ;��ǰ�У�26�е�75��(�˴�Ϊ75��)
		MOV BH,00100001B   ;��ɫ��ʾΪ��ɫ
		INT 10H
;��ʾ��Please input the word:$��
		MOV DH,LINE
		MOV DL,1
		CALL GUANGBIAO
		LEA DX,A4
		CALL OUTP
		ADD LINE,1     
;UI��ʾ����(���޸�)

;����������
	   MOV AX,DATA
	   MOV DS,AX
	   CLI                        ;���ж�
	   MOV AH,0AH
	   MOV DX,OFFSET MESG
	   INT 21H
	   MOV AH,2
	   MOV DL,0AH
	   INT 21H
;��ʾ��ɫ��ɫ�����
	   MOV AH,6 
		MOV AL,0
		MOV CH,LINE
		MOV CL,15     ;��ǰ�У�0�е�15��(�˴�Ϊ15��)
		MOV DH,LINE
		MOV DL,75       ;��ǰ�У�15�е�75��(�˴�Ϊ75��)
		MOV BH,11100001B   ;��ɫ��ʾΪ��ɫ
		INT 10H   
;��ʾ��The output��
	   MOV DH,LINE
	   MOV DL,1
	   CALL GUANGBIAO
	   LEA DX,A5
	   CALL OUTP
	   ADD LINE,2 
;����������
	   MOV CH,0
	   CALL I8250                 ;�����ڳ�ʼ��
	   CALL I8259                 ;������8259A�������ж�	   
	   CALL RD0B                ;���ж�����
	   CALL WR0B 				  ;д�ж�����
	   STI                        ;���ж�	   
	   MOV BX,OFFSET MESG+2
	   MOV CL,MESG+1
 
SCANT: MOV DX,2FDH
	   IN AL,DX
	   TEST AL,20H
	   JZ SCANT	   
	   MOV DX,2F8H
	   MOV AL,[BX]
	   OUT DX,AL
	   INC BX                   ;����
	   MOV DX,0
TWAIT: DEC DX
	   JNZ TWAIT                ;��ѭ����ʱ����֤�жϽ��յ�ʱ��
	   LOOP SCANT
RETURN:CALL RESET
	   MOV AH,4CH
	   INT 21H             ;���� DOS
	   
	   
	   
	   
;�������ӳ���
;���ĺ���GUANGBIAO
	   GUANGBIAO PROC
	   PUSH AX
	   PUSH BX
	   MOV AH,2          ;2�Ź��ܵ��ã�Ԥ�ù���λ��
	   MOV BH,0
	   INT 10H           ;�����
	   POP BX
	   POP AX
	   RET
	   GUANGBIAO ENDP
;������ʽ��ʾ����ĺ���OUTP
	   OUTP PROC
	   PUSH AX
	   MOV AH,9          ;9�Ź��ܵ��ã��ַ������
	   INT 21H
	   POP AX
	   RET
	   OUTP ENDP

RECEIVE PROC
	   PUSHA
	   PUSH DS
	   MOV AX,DATA
	   MOV DS,AX
	   MOV DX,2F8H
	   IN AL,DX
	   AND AL,7FH
	   MOV AH, 2
       MOV DL, AL
       INT 21H           ;��Ļ��ʾ
	   
EXIT:  MOV AL,20H      ;�жϽ�������
	   OUT 20H,AL
	   POP DS           ;�ָ��ֳ�
	   POPA
	   IRET
RECEIVE ENDP


I8250 PROC              ;�����ڳ�ʼ���ӳ���
	   MOV DX,2FBH
	   MOV AL,80H
	   OUT DX,AL       ;Ѱַλ��1
	   
	   MOV DX,2F9H		;���ò����ʣ��˴�00��60��1200����
	   MOV AL,DATA1[0]
	   OUT DX,AL	     ;������8λ
	   MOV DX,2F8H
	   MOV AL,DATA1[1]
	   OUT DX,AL	     ;������8λ
	   
;֡��ʽ������Ϊ03H
	   MOV DX,2FBH
	   MOV AL,DATAF[0]
	   OUT DX,AL

	   MOV DX,2F9H
	   MOV AL,01H	    ;��������ж�
	   OUT DX,AL
	   MOV DX,2FCH
	   MOV AL,18H   	;�ڻ���8250���ͳ��ж�����
	   OUT DX,AL
	   RET
I8250 ENDP
 
I8259 PROC
	   IN AL,21H
	   AND AL,11110111B
	   OUT 21H,AL	    ;���ж����μĴ���
	   RET
I8259 ENDP
 
RD0B PROC  	        ;����ԭ��ϵͳ��0BH �ж�����
	   MOV AX,350BH
	   INT 21H
	   MOV WORD PTR OLD0B,BX
	   MOV WORD PTR OLD0B+2,ES
	   RET
RD0B ENDP
 
WR0B PROC         	;�û�0BH���ж�����ָ���Զ����жϷ������
	   PUSH DS
	   MOV AX,CODE
	   MOV DS,AX
	   MOV DX,OFFSET RECEIVE
	   MOV AX,250BH
	   INT 21H
	   POP DS
	   RET
WR0B ENDP
RESET PROC                ;�ָ�ϵͳ0B�ж�����
	   IN AL,21H
	   OR AL,00001000B
	   OUT 21H,AL
	   MOV AX,250BH
	   MOV DX,WORD PTR OLD0B
	   MOV DS,WORD PTR OLD0B+2
	   INT 21H
	   RET
RESET ENDP
CODE ENDS
	END BEG





