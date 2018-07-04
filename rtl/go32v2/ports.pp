{
    This file is part of the Free Pascal run time library.
    and implements some stuff for protected mode programming
    Copyright (c) 1999-2000 by the Free Pascal development team.

    These files adds support for TP styled port accesses

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

unit ports;

{$ifdef VER3_0}
{$Calling StdCall}
{$endif VER3_0}

{$inline ON}

interface

type
{$ifdef VER3_0}
   tport = object
      procedure writeport(p : word;data : byte);
      function  readport(p : word) : byte;
      property pp[w : word] : byte read readport write writeport;default;
   end;

   tportw = object
      procedure writeport(p : word;data : word);
      function  readport(p : word) : word;
      property pp[w : word] : word read readport write writeport;default;
   end;

   tportl = object
      procedure writeport(p : word;data : longint);
      function  readport(p : word) : longint;
      property pp[w : word] : longint read readport write writeport;default;
   end;
{$else VER3_0}
   tport = object
      procedure writeport(p : word;data : byte);inline;
      function  readport(p : word) : byte;inline;
      property pp[w : word] : byte read readport write writeport;default;
   end;

   tportw = object
      procedure writeport(p : word;data : word);inline;
      function  readport(p : word) : word;inline;
      property pp[w : word] : word read readport write writeport;default;
   end;

   tportl = object
      procedure writeport(p : word;data : longint);inline;
      function  readport(p : word) : longint;inline;
      property pp[w : word] : longint read readport write writeport;default;
   end;
{$endif VER3_0}
var
{ we don't need to initialize port, because neither member
  variables nor virtual methods are accessed }
   port,
   portb : tport;
   portw : tportw;
   portl : tportl;

  implementation

{$asmmode ATT}

{ to give easy port access like tp with port[] }

{$ifdef VER3_0}
procedure tport.writeport(p : word;data : byte);assembler;
asm
        movw    p,%dx
        movb    data,%al
        outb    %al,%dx
end;


function tport.readport(p : word) : byte;assembler;
asm
        movw    p,%dx
        inb     %dx,%al
end;


procedure tportw.writeport(p : word;data : word);assembler;
asm
        movw    p,%dx
        movw    data,%ax
        outw    %ax,%dx
end;


function tportw.readport(p : word) : word;assembler;
asm
        movw    p,%dx
        inw     %dx,%ax
end;


procedure tportl.writeport(p : word;data : longint);assembler;
asm
        movw    p,%dx
        movl    data,%eax
        outl    %eax,%dx
end;


function tportl.readport(p : word) : longint;assembler;
asm
        movw    p,%dx
        inl     %dx,%eax
end;
{$else VER3_0}
procedure tport.writeport(p : word;data : byte);inline;
begin
  fpc_x86_outportb(p,data);
end;


function tport.readport(p : word) : byte;inline;
begin
  readport:=fpc_x86_inportb(p);
end;


procedure tportw.writeport(p : word;data : word);inline;
begin
  fpc_x86_outportw(p,data);
end;


function tportw.readport(p : word) : word;inline;
begin
  readport:=fpc_x86_inportw(p);
end;


procedure tportl.writeport(p : word;data : longint);inline;
begin
  fpc_x86_outportl(p,data);
end;


function tportl.readport(p : word) : longint;inline;
begin
  readport:=fpc_x86_inportl(p);
end;
{$endif VER3_0}

end.
