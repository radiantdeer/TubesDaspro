unit ubank;

interface
  
  uses sysutils;
  //type
  procedure loadFile(fname : string);

implementation

  procedure loadFile(fname : string);
  var
    ft : text;
    s : string;
    c : char;
    
  begin
    if(FileExists(fname)) then
    begin
      assign(ft,fname);
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
    end else writeln('Error : File ',fname,' tidak ditemukan!');  
  end;

end.