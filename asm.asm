;Programa: Nr. 3
;Uzduoties salyga: Parašykite programą, kuri įvestoje simbolių eilutėje didžiąsias ASCII raides pakeičia mažosiomis. Pvz.: įvedus aBcDEf54 turi atspausdinti abcdef54
;Atliko: Vasarė Pratuzaitė

.model small
.stack 100h

MAX_BUFF = 200

.data
    request     db 'Programa simboliu eilute pakeicia mazosiomis raidemis:', 0Dh, 0Ah, '$'
    error_len   db 'Eilute negali buti tuscia', 0Dh, 0Ah, '$'
    result      db 'Rezultatas:', 0Dh, 0Ah, '$'
    buffer      db MAX_BUFF
    input       db ?
    buffer_data db MAX_BUFF dup (0)

.code

start:
    mov ax, @data
    mov ds, ax

    ; Ivesti uzklausa
    mov ah, 09h
    mov dx, offset request
    int 21h

input_request:
    ; Skaityti eilute
    mov dx, offset buffer
    mov ah, 0Ah
    int 21h

    ; Tikrinti, ar eilute ne tuscia
    cmp byte ptr input, 0
    jz error

    ; Isvesti rezultata
    mov ah, 09h
    mov dx, offset result
    int 21h

    mov si, offset buffer_data
    xor ch, ch
    mov cl, input

convert_to_lowercase:
    LODSB
    mov ah, 2

    ; Tikrinti, ar simbolis didzioji raide
    cmp al, 'A'
    jb not_letter
    cmp al, 'Z'
    ja not_letter

    ; Pakeisti didziaja raide i mazaja
    add al, 32

not_letter:
    mov dl, al
    int 21h

    loop convert_to_lowercase

    ; Grizti i DOS
    mov ax, 4C00h
    int 21h

error:
    mov ah, 09h
    mov dx, offset error_len
    int 21h
    jmp input_request
end start
