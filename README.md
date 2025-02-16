# Brotli-Compression-Decompression-for-Delphi-Lazarus
Brotli Compression Decompression for Delphi, Lazarus and Free Pascal

## Usage examples

```
var F,S: TFileStream;
    OrigSize: Integer;
begin
  F := TFileStream.Create('input.txt', fmOpenRead);
  S := TFileStream.Create('output.snap', fmCreate);
  Brotli(F, S);
  OrigSize := F.Size;
  F.Free;
  S.Free;

  F := TFileStream.Create('output.snap', fmOpenRead);
  S := TFileStream.Create('output.txt', fmCreate);
  UnBrotli(F, S, OrigSize);
  F.Free;
  S.Free;
end;
```

## This unit uses Brotli library by Google:

Brotli is open-sourced under the MIT License.

## Linux (Debian, Ubuntu, Mint)

1) apt install apt-file libbrotli-dev
2) apt-file search libbrotli.so
It will list you how your libbrotli.so files are named *exactly* and where they are
3) Open BrotliLib.pas and edit "const BROTLI_LIB"
4) Change the value of that const. Enter filename (excluding path) found in step 2
5) Compile and run
