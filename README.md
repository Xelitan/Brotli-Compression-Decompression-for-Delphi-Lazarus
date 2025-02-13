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
