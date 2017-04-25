unit uexit;

interface

  uses banktype;

  var
    ft : text;

// List semua prosedur dan fungsi yang tersedia
  procedure savefilenasabah(fname : string; T : lnasabah);

implementation

  procedure savefilenasabah(fname : string; T : lnasabah);
  var
    i : integer;

  begin
    if (T.Neff = 0) then writeln('Tidak ada data yang disimpan!')
    else
    begin
      assign(ft,fname);
      rewrite(ft);
      for i := 1 to T.Neff do
      begin
        write(ft,T.list[i].nonasabah);
        write(ft,' | ');
        write(ft,T.list[i].nama);
        write(ft,' | ');
        write(ft,T.list[i].alamat);
        write(ft,' | ');
        write(ft,T.list[i].kota);
        write(ft,' | ');
        write(ft,T.list[i].email);
        write(ft,' | ');
        write(ft,T.list[i].telp);
        write(ft,' | ');
        write(ft,T.list[i].user);
        write(ft,' | ');
        write(ft,T.list[i].pass);
        write(ft,' | ');
        write(ft,T.list[i].stat);
        if (i <> T.Neff) then writeln(ft);
      end;
      close(ft);
    end;
  end;

end.
