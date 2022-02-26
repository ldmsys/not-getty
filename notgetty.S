bits 16
org 0x7C00
LF equ 0Ah

xor ah, ah ; set video mode
xor bh, bh ; we won't use page number
mov al, 03h ; to 03h in order to clear screen
int 10h ; video call
mov cx, 0Fh
mov dx, 4290h
mov ah, 86h
int 15h
mov si, login
call print
mov BYTE [cn], 00h

_login:
    mov si, usernameprompt
    call print
    mov BYTE [sh], 01h
    call ioctl

    mov si, passwdprompt
    mov BYTE [sh], 00h
    call print
    call ioctl
    mov BYTE [sh], 01h

    mov cx, 35h
    mov dx, 67E0h
    mov ah, 86h
    int 15h
    mov si, incorrect
    call print
    
    cmp BYTE [cn], 04h
    jae 0x7C00
    inc BYTE [cn]
    jmp _login

ioctl: ; [ic] = inputted character cnt, [sh] = show character
    mov BYTE [ic], 00h
    .loop1:
        xor ah, ah
        int 16h
        cmp al, 03h
        je 0x7C00
        cmp al, 04h
        je 0x7C00
        cmp al, 1Ah
        je 0x7C00
        cmp al, 0Dh
        je .ret
        cmp BYTE [sh], 00h
        je .loop1
        cmp al, 08h
        je .backspace
        cmp al, 20h
        jb .loop1
        cmp al, 7Eh
        ja .loop1
        cmp BYTE [ic], 3Eh
        jae .loop1
        inc BYTE [ic]

    .printascii:
        mov ah, 0Eh
        int 10h
        jmp .loop1
    
    .cursorback:
        pusha
        mov ah, 03h
        int 10h
        dec dl
        mov ah, 02h
        int 10h
        popa
        ret
    
    .backspace:
        cmp BYTE [ic], 00h
        je .loop1
        push ax
        call .cursorback
        mov al, ' '
        mov ah, 0Eh
        int 10h
        pop ax
        dec BYTE [ic]
        jmp .printascii

    .ret:
        mov ah, 03h ; get cursor's location
        int 10h ; video call
        mov ah, 02h ; move cursor's location
        xor dl, dl ; set row to zero
        inc dh ; increase column
        int 10h ; video call
        ret

print:
    pusha
    xor bh, bh ; we won't use page number

    .loop:
        lodsb
        cmp al, 00h ; '\0' = exit
        je .ret
        cmp al, LF ; '\n' = newline
        je .newline
        mov ah, 0Eh ; write character 
        int 10h ; video call
        jmp .loop

    .newline:
        mov ah, 03h ; get cursor's location
        int 10h ; video call
        mov ah, 02h ; move cursor's location
        xor dl, dl ; set row to zero
        inc dh ; increase column
        int 10h ; video call
        jmp .loop
    
    .ret:
        popa
        ret


login: db LF, "CentOS Linux 7 (Core)", LF, "Kernel 3.10.0-1127.el7.x86_64 on an x86_64", LF, LF, 0 ; CentOS 7
;login: db LF, "Debian GNU/Linux 7 localhost tty1", LF, LF, 0 ; Debian 7
;login: db LF, "Ubuntu 20.04.3 LTS localhost tty1", LF, LF, 0 ; Ubuntu 20.04
usernameprompt: db "localhost login: ", 0
passwdprompt:   db "Password: ", 0
incorrect:      db "Login incorrect", LF, LF, 0
ic: db 00h
sh: db 01h
cn: db 00h

times 510-($-$$) db 0
dw 0xAA55