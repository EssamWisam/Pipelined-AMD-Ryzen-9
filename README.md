# Pipelined-AMD-Ryzen-9
This is a simple pipelined processor that serves as the project for the Computer Architecture course (CMP 3010) taught at Cairo University.

## Implemented Instructions
### ☝️ One Operand
```
NOP
HLT
SETC
NOT Rdst
INC Rdst
OUT Rdst
IN Rdst
```
### ✌️ Two Operands
```
MOV Rsrc, Rdst
ADD Rdst, Rsrc1, Rsrc2
SUB  Rdst, Rsrc1, Rsrc2
AND  Rdst, Rsrc1, Rsrc2
IADD Rdst, Rsrc2 ,Imm
```

### 💾 Memory
```
PUSH  Rdst
POP  Rdst
LDM  Rdst, Imm
LDD  Rdst, offset(Rsrc)
STD Rsrc1, offset(Rsrc2)
```

### 🦘 Jumps
```
JZ  Rdst
JN  Rdst
JC Rdst
JMP  Rdst
```

## Contributors
<!-- readme: collaborators -start -->
<table>
<tr>
    <td align="center">
        <a href="https://github.com/Kariiem">
            <img src="https://avatars.githubusercontent.com/u/48629566?v=4" width="100;" alt="Kariiem"/>
            <br />
            <sub><b>Kariiem Taha</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/EssamWisam">
            <img src="https://avatars.githubusercontent.com/u/49572294?v=4" width="100;" alt="EssamWisam"/>
            <br />
            <sub><b>Essam</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/Muhammad-saad-2000">
            <img src="https://avatars.githubusercontent.com/u/61880555?v=4" width="100;" alt="Muhammad-saad-2000"/>
            <br />
            <sub><b>MUHAMMAD SAAD</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/Ahmedmma72">
            <img src="https://avatars.githubusercontent.com/u/72984811?v=4" width="100;" alt="Ahmedmma72"/>
            <br />
            <sub><b>Ahmedmma72</b></sub>
        </a>
    </td></tr>
</table>
<!-- readme: collaborators -end -->


### For the design and more info about the architectural desicions we took, check <a href="https://bit.ly/3JFTedJ">this</a> along with the attached PDFs (Design Folder).
