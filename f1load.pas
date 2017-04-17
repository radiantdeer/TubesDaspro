Program F1Load;

uses sysutils; 

var
  c : char;
  s : string;
  ft : text;
  
begin
  write('Pilih file : ');readln(s);
  if(FileExists(s)) then
  begin
    assign(ft,s);
    reset(ft);
    s := '';
    while (not(EOF(ft))) do
    begin
      read(ft,c);
      while ((c <> Chr(10)) AND (not(EOF(ft)))) do // Chr(10) converts the ASCII code of 10 to the line ending/ENTER
      begin
        if (c = '|') then
        begin
          writeln(s);
          s := '';
        end else
        begin
          s := s + c;
        end;
        read(ft,c);
        if (EOF(ft)) then s := s + c; // This will fix the issue that the last character always get cut
      end;
      writeln(s);
      s := '';
    end;
    close(ft);
    writeln('File berhasil dimuat!');
  end else writeln('Error : File '.s.'tidak ditemukan!');  
end.