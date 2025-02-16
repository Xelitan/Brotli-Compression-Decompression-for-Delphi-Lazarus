unit BrotliLib;

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Description:	BROTLI compressor and decompressor                            //
// Version:	0.1                                                           //
// Date:	16-FEB-2025                                                   //
// License:     MIT                                                           //
// Target:	Win64, Free Pascal, Delphi                                    //
// Copyright:	(c) 2025 Xelitan.com.                                         //
//		All rights reserved.                                          //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

interface

uses
  Classes, SysUtils, Dialogs;

const BROTLI_LIB = 'brotlienc.dll';
      BROTLI_LIB2 = 'brotlidec.dll';

type
  TBrotliQuality = 0..11;
  TBrotliWindow = 10..24;

  TBrotliEncoderMode = (BROTLI_MODE_GENERIC, BROTLI_MODE_TEXT, BROTLI_MODE_FONT);

  function BrotliEncoderCompress(quality: Integer; window: Integer; mode: TBrotliEncoderMode; input_size: Cardinal; input_buffer: PByte; encoded_size: PCardinal;encoded_buffer: PByte): LongBool; cdecl; external BROTLI_LIB;
  function BrotliEncoderMaxCompressedSize(input_size: Cardinal): Cardinal; cdecl; external BROTLI_LIB;
  function BrotliDecoderDecompress(encoded_size: Cardinal; encoded_buffer: PByte; decoded_size: PCardinal; decoded_buffer: PByte): LongBool; cdecl; external BROTLI_LIB2;

  //Functions
  function Brotli(Data: PByte; DataLen: Integer; var OutData: TBytes; Compression: Integer = 11): Boolean; overload;
  function UnBrotli(Data: PByte; DataLen: Integer; var OutData: TBytes; OutDataLen: Integer): Boolean; overload;

  function Brotli(InStr, OutStr: TStream; Compression: Integer = 11): Boolean; overload;
  function UnBrotli(InStr, OutStr: TStream; OutDataLen: Integer): Boolean; overload;

  function Brotli(Str: String; Compression: Integer = 11): String; overload;
  function UnBrotli(Str: String; OutDataLen: Integer): String; overload;

implementation

function Brotli(Data: PByte; DataLen: Integer; var OutData: TBytes; Compression: Integer): Boolean;
var Res: LongBool;
    OutLen: Cardinal;
begin
  OutLen := BrotliEncoderMaxCompressedSize(DataLen);
  SetLength(OutData, OutLen);

  Res := BrotliEncoderCompress(Compression, 22, BROTLI_MODE_GENERIC, DataLen, Data, @Outlen, @OutData[0]);

  if not Res then Exit(False);
  SetLength(OutData, OutLen);

  Result := True;
end;

function UnBrotli(Data: PByte; DataLen: Integer; var OutData: TBytes; OutDataLen: Integer): Boolean;
var Res: LongBool;
begin
  SetLength(OutData, OutDataLen);
  Res := BrotliDecoderDecompress(DataLen, Data, @OutDataLen, @OutData[0]);

  if not Res then Exit(False);
  SetLength(OutData, OutDataLen);

  Result := True;
end;

function UnBrotli(Str: String; OutDataLen: Integer): String;
var Res: Boolean;
    OutLen: Integer;
    OutData: TBytes;
begin
  Res := UnBrotli(@Str[1], Length(Str), OutData, OutDataLen);
  if not Res then Exit('');

  OutLen := Length(OutData);
  SetLength(Result, OutLen);
  Move(OutData[0], Result[1], OutLen);
end;

function Brotli(InStr, OutStr: TStream; Compression: Integer): Boolean;
var Buf: array of Byte;
    Size: Integer;
    OutData: TBytes;
begin
  Result := False;
  try
    Size := InStr.Size - InStr.Position;
    SetLength(Buf, Size);
    InStr.Read(Buf[0], Size);

    if not Brotli(@Buf[0], Size, OutData, Compression) then Exit;

    OutStr.Write(OutData[0], Length(OutData));
    Result := True;
  finally
  end;
end;

function UnBrotli(InStr, OutStr: TStream; OutDataLen: Integer): Boolean;
var Buf: array of Byte;
    Size: Integer;
    OutData: TBytes;
begin
  Result := False;
  try
    Size := InStr.Size - InStr.Position;
    SetLength(Buf, Size);
    InStr.Read(Buf[0], Size);

    if not UnBrotli(@Buf[0], Size, OutData, OutDataLen) then Exit;

    OutStr.Write(OutData[0], Length(OutData));
    Result := True;
  finally
  end;
end;

function Brotli(Str: String; Compression: Integer): String;
var Res: Boolean;
    OutLen: Integer;
    OutData: TBytes;
begin
  Res := Brotli(@Str[1], Length(Str), OutData, Compression);
  if not Res then Exit('');

  OutLen := Length(OutData);
  SetLength(Result, OutLen);
  Move(OutData[0], Result[1], OutLen);
end;

end.
