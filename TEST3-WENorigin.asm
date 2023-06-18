DATAS SEGMENT
BUF DB 30
    DB ?
    DB 30 DUP(?)       ;�����洢������Ϣ�Ļ�����
MESG1 DB 'set BD$' 
MESG2 DB 'write the number of Divisor register from high to low:$'
MESG4 DB '���뷢������:'
H DB 2
     DB ?
     DB 2 DUP(?)
OLD0B DD ?   ;SUBSTITUTE
FLAG DB 0
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    CLI
    CALL I82501
    ;��ʾ���
    MOV AH,9
    MOV DX,OFFSET MESG1
    INT 21H
    MOV	DL,0AH			;����
    MOV	AH,02H
    INT	21H
    MOV AH,9
    MOV DX,OFFSET MESG2
    INT 21H
    
    MOV AH,0AH
    MOV DX,OFFSET BUF   
    INT 21H              ;��������͵���Ϣ
    MOV AH,2
    MOV DL,0AH     
    INT 21H  			 ;����
    
    MOV CH,0
    MOV CL,BUF+1         ;���㳤��
    
    CALL I8259
    CALL READ0B
    CALL WRITE0B
    STI
    MOV BX,OFFSET BUF+2  ;ȡ���׵�ַ
     
SCAN: 
    MOV DX,2FDH
    IN AL,DX
    TEST AL,20H          ;��鷢�ͱ��ּĴ����Ƿ�Ϊ��
    JZ SCAN
    
    MOV DX,2F8H
    MOV AL,[BX]          ;ȡ�ַ�
    OUT DX,AL		     ;�͵����ݼĴ���
    INC BX             
    LOOP SCAN

LAST:MOV DX,2FDH        
     IN AL,DX
     TEST AL,40H		 ;��鷢����λ�Ĵ����Ƿ�Ϊ��
     JZ LAST             ;ȷ���Ƿ������ַ��������

    
SCANT: CMP FLAG,1  		 ;�����Ƿ��յ������ַ�
       JZ SCANT
       CALL RESET
       MOV AH,4CH
       INT 21H
       
RECEIVE PROC
        PUSH AX
        PUSH DX
        PUSH DS            
        MOV AX,DATAS    
        MOV DS,AX
        MOV DX,2F8H   
        IN AL,DX
        CMP AL,0DH           ;�����Ƿ����
        JZ NEXT             
        MOV AH,2             ;��ʾ�յ����ַ�
        MOV DL,AL
        INT 21H
        JMP EXIT
NEXT:   MOV FLAG,1
EXIT:   MOV AL,20H
        OUT 20H,AL
        POP DS               
        POP DX
        POP AX
        IRET
RECEIVE ENDP


I82501 PROC              	;8250��ʼ��
     MOV DX,2FBH
     MOV AL,80H
     OUT DX,AL
     ;���ò�����
     MOV DX,2F9H
     MOV AL,09H				
     OUT DX,AL				;�����Ĵ�����8λ
     MOV DX,2F8H
     MOV AL,00H
     OUT DX,AL				;�����Ĵ�����8λ
     ;����֡��ʽ
     MOV DX,2FBH
     MOV AL,0BH;
     OUT DX,AL
     
     MOV DX,2F9H
     MOV AL,01H
     OUT DX,AL				;����8250�ڲ���������ж�
     MOV DX,2FCH
     MOV AL,00011000B;<==���������p348;D4=1�ڻ��Լ�,  
     ; D3=1�����ж�, D4=0����ͨ��
     OUT DX,AL
     RET
I82501 ENDP

I8259 PROC
     IN AL,21H
     AND AL,11110111B;
     OUT 21H,AL
     RET
I8259 ENDP

READ0B PROC
      MOV AX,350BH
      INT 21H
      MOV WORD PTR OLD0B,BX
      MOV WORD PTR OLD0B+2,ES
      RET
READ0B ENDP

WRITE0B PROC
        PUSH DS
        MOV AX,CODES
        MOV DS,AX
        MOV DX,OFFSET RECEIVE
        MOV AX,250BH
        INT 21H
        POP DS
        RET
WRITE0B ENDP
RESET PROC
        IN AL,21H
        OR AL,00001000B
        OUT 21H,AL
        MOV AX,250BH
        MOV DX,WORD PTR OLD0B
        MOV DS,WORD PTR OLD0B+2
        INT 21H
        RET
RESET ENDP
CODES ENDS
END START







