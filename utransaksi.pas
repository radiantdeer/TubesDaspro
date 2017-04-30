unit utransaksi;
{ Berisi fungsi-fungsi transaksi (setoran, penarikan, transfer, pembelian, pembayaran) }

interface
  uses banktype, sysutils, dateutils;

  var
      tempArray : array [1..50] of string;
      pil : char;
      jenisRek : integer;
      jenis, noAk, notujuan, banktujuan, trfremarks, srccur : string;
      jumlahSetor, jumlahTarik, jumlahTrf : real;
      stop, found, success : boolean;
      N : integer;
      i : integer;

  // List Subprogram yang tersedia di unit ini
  function SudahJatuhTempo (rekonline : rekonline) : boolean;
  { Menghasilkan true jika telah memenuhi waktu jatuh tempo dan false jika
    belum memenuhi waktu jatuh tempo }
  { Waktu jatuh tempo dihitung dari tanggal pembuatan rekening ke jangka
    waktu yang ditentukan untuk rekening tersebut }
  function CurrencyConvert (asal : string; nominal : real; tujuan : string) : real;
  { Mengubah nominal yang dalam mata uang asal menjadi mata uang tujuan, nominal dianggap positif
    Menggunakan data dalam array lkurs, jika data tidak ditemukan, fungsi mengembalikan -999 }
  procedure setoran();
  { Menyetor sejumlah uang secara tunai ke suatu rekening tertentu }
  procedure penarikan();
  { Menarik sejumlah uang secara tunai dari suatu rekening tertentu }
  procedure transfer();
  { Memindahkan sejumlah uang dari suatu rekening ke rekening lainnya
    Rekening tujuan bisa ada atau tidak (memang tidak ada/)}

implementation

    function SudahJatuhTempo (rekonline : rekonline) : boolean;
    { Menghasilkan true jika telah memenuhi waktu jatuh tempo dan false jika
      belum memenuhi waktu jatuh tempo }
    { Waktu jatuh tempo dihitung dari tanggal pembuatan rekening ke jangka
      waktu yang ditentukan untuk rekening tersebut }
    { Kamus }
    var
      tanggalMulai, jatuhTempo : TDateTime;
      cmd : integer;
      date, month, year : string;
      dd, mm, yy : integer;
    { Algoritma }
    begin
      date:=copy(rekonline.tglmulai,1,2);
      month:=copy(rekonline.tglmulai,4,2);
      year:=copy(rekonline.tglmulai,7,4);
      val(date,dd);
      val(month,mm);
      val(year,yy);
      tanggalMulai:=EncodeDate(yy,mm,dd);
      case rekonline.waktu of
        '1 bulan' : begin
                jatuhTempo:=IncMonth(tanggalMulai,1);
              end;
        '3 bulan' : begin
                jatuhTempo:=IncMonth(tanggalMulai,3);
              end;
        '6 bulan' : begin
                jatuhTempo:=IncMonth(tanggalMulai,6);
              end;
        '1 tahun' : begin
                jatuhTempo:=IncMonth(tanggalMulai,12);
              end;
      end;
      cmd:=CompareDate(jatuhTempo,Now);
      SudahJatuhTempo:=cmd<=0;
    end;

    function CurrencyConvert (asal : string; nominal : real; tujuan : string) : real;

      begin
        found := false;
        i := 1;
        while ((i <= arrkurs.Neff) and not(found)) do
        begin
          if ((asal = arrkurs.list[i].awal) and (tujuan = arrkurs.list[i].akhir)) then
            found:=true
          else
            i:=i+1;
        end;
        if (found) then
          CurrencyConvert := nominal * arrkurs.list[i].nakhir
        else 
          CurrencyConvert := -999;
      end;

    procedure setoran();

      begin
        writeln('> Pilih jenis rekening:');
      	writeln('> 1. Deposito');
      	writeln('> 2. Tabungan rencana');
      	writeln('> 3. Tabungan mandiri');
      	{ Validasi masukan jenis rekening }
      	{ Pengulangan akan berhenti jika pengguna memasukkan jenis rekening
      	  yang tepat, yaitu 1, 2, atau 3 }
      	stop:=false;
      	repeat
      		write('> Jenis rekening : ');
      		readln(jenisRek);
      		if (jenisRek=1) or (jenisRek=2) or (jenisRek=3) then
      			stop:=true
      		else
      			writeln('> Jenis rekening yang Anda masukkan salah!');
      	until stop;
      	{ Mendaftarkan nomor akun rekening-rekening milik pengguna ke array
      	  tempArray sesuai dengan masukan jenis rekening }
      	{ N adalah banyaknya rekening milik pengguna dengan jenis tertentu
      	  sesuai masukan pengguna }
      	if (jenisRek=1) then
      	begin
      		jenis:='deposito';
      		N:=0;
      		for i:=1 to arrrekonline.Neff do
      		begin
      			if (arrrekonline.list[i].nonasabah=currentuser.nonasabah) and (arrrekonline.list[i].jenis=jenis) then
      			begin
      				N:=N+1;
      				tempArray[N]:=arrrekonline.list[i].noakun;
      			end;
      		end;
      	end else if (jenisRek=2) then
      	begin
      		jenis:='tabungan rencana';
      		N:=0;
      		for i:=1 to arrrekonline.Neff do
      		begin
      			if (arrrekonline.list[i].nonasabah=currentuser.nonasabah) and (arrrekonline.list[i].jenis=jenis) then
      			begin
      				N:=N+1;
      				tempArray[N]:=arrrekonline.list[i].noakun;
      			end;
      		end;
      	end else
      	begin
      		jenis:='tabungan mandiri';
      		N:=0;
      		for i:=1 to arrrekonline.Neff do
      		begin
      			if (arrrekonline.list[i].nonasabah=currentuser.nonasabah) and (arrrekonline.list[i].jenis=jenis) then
      			begin
      				N:=N+1;
      				tempArray[N]:=arrrekonline.list[i].noakun;
      			end;
      		end;
      	end;
      	if (N>0) then
      	begin
      		{ Menampilkan nomor akun rekening-rekening yang tersimpan pada
      		  array tempArray }
      		writeln('> Pilih rekening ',jenis,' Anda:');
      		for i:=1 to N do
      		begin
      			writeln('> ',i,'. ',tempArray[i]);
      		end;
      		write('> Rekening: ');
      		readln(noAk);
      		{ Pencarian indeks nomor akun rekening yang dimasukkan pengguna }
      		found:=false;
      		i:=1;
      		while (i<=arrrekonline.Neff) and (not(found)) do
      		begin
      			if (arrrekonline.list[i].noakun=noAk) then
      				found:=true
      			else
      				i:=i+1;
      		end;
      		if found then
      		begin
      			write('> Jumlah setoran: ');
      			readln(jumlahSetor);
      			arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo+jumlahSetor;
      			{ Update array transaksi setoran/penarikan }
      			arrtransaksi.Neff:=arrtransaksi.Neff+1;
      			arrtransaksi.list[arrtransaksi.Neff].noakun:=arrrekonline.list[i].noakun;
      			arrtransaksi.list[arrtransaksi.Neff].jenis:='setoran';
      			arrtransaksi.list[arrtransaksi.Neff].uang:=arrrekonline.list[i].uang;
      			arrtransaksi.list[arrtransaksi.Neff].jumlah:=jumlahSetor;
      			arrtransaksi.list[arrtransaksi.Neff].saldoakhir:=arrrekonline.list[i].saldo;
      			arrtransaksi.list[arrtransaksi.Neff].tgl:=FormatDateTime('DD-MM-YYYY',Now);
      			writeln('> Setoran berhasil! Jumlah saldo Anda adalah ',arrrekonline.list[i].saldo:0:2);
      		end else { not(found) }
      			writeln('> Rekening tidak ditemukan!');
      	end else { N=0 }
      		writeln('> Anda tidak mempunyai ',jenis,'.');
      end;

    procedure penarikan();

      begin
        writeln('> Pilih jenis rekening:');
      	writeln('> 1. Deposito');
      	writeln('> 2. Tabungan rencana');
      	writeln('> 3. Tabungan mandiri');
      	{ Validasi masukan jenis rekening }
      	{ Pengulangan akan berhenti jika pengguna memasukkan jenis rekening
      	  yang tepat, yaitu 1, 2, atau 3 }
      	stop:=false;
      	repeat
      		write('> Jenis rekening : ');
      		readln(jenisRek);
      		if (jenisRek=1) or (jenisRek=2) or (jenisRek=3) then
      			stop:=true
      		else
      			writeln('> Jenis rekening yang Anda masukkan salah!');
      	until stop;
      	{ Mendaftarkan nomor akun rekening-rekening milik pengguna ke array
      	  tempArray sesuai dengan masukan jenis rekening }
      	{ N adalah banyaknya rekening milik pengguna dengan jenis tertentu
      	  sesuai masukan pengguna }
      	if (jenisRek=1) then
      	begin
      		jenis:='deposito';
      		N:=0;
      		for i:=1 to arrrekonline.Neff do
      		begin
      			if (arrrekonline.list[i].nonasabah=currentuser.nonasabah) and (arrrekonline.list[i].jenis=jenis) then
      			begin
      				N:=N+1;
      				tempArray[N]:=arrrekonline.list[i].noakun;
      			end;
      		end;
      	end else if (jenisRek=2) then
      	begin
      		jenis:='tabungan rencana';
      		N:=0;
      		for i:=1 to arrrekonline.Neff do
      		begin
      			if (arrrekonline.list[i].nonasabah=currentuser.nonasabah) and (arrrekonline.list[i].jenis=jenis) then
      			begin
      				N:=N+1;
      				tempArray[N]:=arrrekonline.list[i].noakun;
      			end;
      		end;
      	end else
      	begin
      		jenis:='tabungan mandiri';
      		N:=0;
      		for i:=1 to arrrekonline.Neff do
      		begin
      			if (arrrekonline.list[i].nonasabah=currentuser.nonasabah) and (arrrekonline.list[i].jenis=jenis) then
      			begin
      				N:=N+1;
      				tempArray[N]:=arrrekonline.list[i].noakun;
      			end;
      		end;
      	end;
      	if (N>0) then
      	begin
      		{ Menampilkan nomor akun rekening-rekening yang tersimpan pada
      		  array tempArray }
      		writeln('> Pilih rekening ',jenis,' Anda:');
      		for i:=1 to N do
      		begin
      			writeln('> ',i,'. ',tempArray[i]);
      		end;
      		write('> Rekening: ');
      		readln(noAk);
      		{ Asumsikan nomor akun yang dimasukkan pengguna benar }
      		found:=false;
      		i:=1;
      		while (i<=arrrekonline.Neff) and (not(found)) do
      		begin
      			if (arrrekonline.list[i].noakun=noAk) then
      				found:=true
      			else
      				i:=i+1;
      		end;
      		if found then
      		begin
      			write('> Masukkan jumlah uang yang diinginkan : ');
      			readln(jumlahTarik);
      			if (jenis='tabungan mandiri') and (arrrekonline.list[i].saldo>=jumlahTarik) then
      			begin
      				arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-jumlahTarik;
      				success:=true;
      			end else if ((jenis='deposito') or (jenis='tabungan rencana')) and (arrrekonline.list[i].saldo>=jumlahTarik) and SudahJatuhTempo(arrrekonline.list[i]) then
      			begin
      				arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-jumlahTarik;
      				success:=true;
      			end else
      				success:=false;
      			if (success=true) then
      			begin
      				arrtransaksi.Neff:=arrtransaksi.Neff+1;
      				arrtransaksi.list[arrtransaksi.Neff].noakun:=arrrekonline.list[i].noakun;
      				arrtransaksi.list[arrtransaksi.Neff].jenis:='penarikan';
      				arrtransaksi.list[arrtransaksi.Neff].uang:=arrrekonline.list[i].uang;
      				arrtransaksi.list[arrtransaksi.Neff].jumlah:=jumlahTarik;
      				arrtransaksi.list[arrtransaksi.Neff].saldoakhir:=arrrekonline.list[i].saldo;
      				arrtransaksi.list[arrtransaksi.Neff].tgl:=FormatDateTime('DD-MM-YYYY',Now);
      				writeln('> Penarikan berhasil! Jumlah saldo Anda adalah ',arrrekonline.list[i].saldo:0:2);
      			end else { not(success) }
      				writeln('> Anda tidak dapat melakukan penarikan.');
      		end else { not(found) }
      			writeln('> Rekening tidak ditemukan!');
      	end else { N=0 }
      		writeln('> Anda tidak mempunyai ',jenis,'.');
      end;

    procedure transfer();

      begin
        writeln('> Pilih jenis rekening:');
        writeln('> 1. Deposito');
        writeln('> 2. Tabungan rencana');
        writeln('> 3. Tabungan mandiri');
        { Validasi masukan jenis rekening }
        { Pengulangan akan berhenti jika pengguna memasukkan jenis rekening
          yang tepat, yaitu 1, 2, atau 3 }
        stop:=false;
        repeat
          write('> Jenis rekening : ');
          readln(jenisRek);
          if (jenisRek=1) or (jenisRek=2) or (jenisRek=3) then
            stop:=true
          else
            writeln('> Jenis rekening yang Anda masukkan salah!');
        until stop;
        { Mendaftarkan nomor akun rekening-rekening milik pengguna ke array
          tempArray sesuai dengan masukan jenis rekening }
        { N adalah banyaknya rekening milik pengguna dengan jenis tertentu
          sesuai masukan pengguna }
        if (jenisRek=1) then
        begin
          jenis:='deposito';
          N:=0;
          for i:=1 to arrrekonline.Neff do
          begin
            if (arrrekonline.list[i].nonasabah=currentuser.nonasabah) and (arrrekonline.list[i].jenis=jenis) then
            begin
              N:=N+1;
              tempArray[N]:=arrrekonline.list[i].noakun;
            end;
          end;
        end else if (jenisRek=2) then
        begin
          jenis:='tabungan rencana';
          N:=0;
          for i:=1 to arrrekonline.Neff do
          begin
            if (arrrekonline.list[i].nonasabah=currentuser.nonasabah) and (arrrekonline.list[i].jenis=jenis) then
            begin
              N:=N+1;
              tempArray[N]:=arrrekonline.list[i].noakun;
            end;
          end;
        end else
        begin
          jenis:='tabungan mandiri';
          N:=0;
          for i:=1 to arrrekonline.Neff do
          begin
            if (arrrekonline.list[i].nonasabah=currentuser.nonasabah) and (arrrekonline.list[i].jenis=jenis) then
            begin
              N:=N+1;
              tempArray[N]:=arrrekonline.list[i].noakun;
            end;
          end;
        end;
        if (N>0) then
        begin
          { Menampilkan nomor akun rekening-rekening yang tersimpan pada
            array tempArray }
          writeln('> Pilih rekening ',jenis,' Anda:');
          for i:=1 to N do
          begin
            writeln('> ',i,'. ',tempArray[i]);
          end;
          write('> Rekening : ');
          readln(noAk);
          { Asumsikan nomor akun yang dimasukkan pengguna benar }
          found:=false;
          i:=1;
          while (i<=arrrekonline.Neff) and (not(found)) do
          begin
            if (arrrekonline.list[i].noakun=noAk) then
              found:=true
            else
              i:=i+1;
          end;
          if found then
          begin
            write('> Masukkan rekening tujuan : ');readln(notujuan);
            repeat
              write('> Apakah rekening tersebut merupakan rekening bank XYZ? (y/n) : ');readln(pil);
              if (NOT((pil = 'y') OR (pil = 'Y') OR (pil = 'n') OR (pil = 'N'))) then writeln('Masukan salah! Coba lagi!');
            until ((pil = 'y') OR (pil = 'Y') OR (pil = 'n') OR (pil = 'N'));
            if ((pil = 'n') OR (pil = 'N')) then
            begin
              trfremarks := 'antar bank';
              writeln('> Masukkan nama bank tujuan : ');
              readln(banktujuan);
            end else 
            begin
              trfremarks := 'dalam bank';
              banktujuan := '-';
            end;
            write('> Masukkan jumlah uang yang diinginkan : ');readln(jumlahTrf);
            if (jenis='tabungan mandiri') then
            begin
              if ((trfremarks = 'dalam bank') and (arrrekonline.list[i].saldo>=jumlahTrf)) then
              begin
                arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-jumlahTrf;
                srccur := arrrekonline.list[i].uang;
                success:=true;
              end else // trfremarks = 'antar bank'
              begin
                if ((arrrekonline.list[i].uang = 'IDR') and (arrrekonline.list[i].saldo>=(jumlahTrf + 5000))) then
                begin
                  arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-(jumlahTrf + 5000);
                  success:=true;
                end else if (((arrrekonline.list[i].uang = 'USD') or (arrrekonline.list[i].uang = 'EUR')) and (arrrekonline.list[i].saldo>=(jumlahTrf + 2))) then
                begin
                  arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-(jumlahTrf + 2);
                  success:=true;
                end;
              end;
            end else if ((jenis='deposito') or (jenis='tabungan rencana')) and SudahJatuhTempo(arrrekonline.list[i]) then
            begin
              if ((trfremarks = 'dalam bank') and (arrrekonline.list[i].saldo>=jumlahTrf)) then
              begin
                arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo - jumlahTrf;
                srccur := arrrekonline.list[i].uang;
                success:=true;
              end else // trfremarks = 'antar bank'
              begin
                if ((arrrekonline.list[i].uang = 'IDR') and (arrrekonline.list[i].saldo>=(jumlahTrf + 5000))) then
                begin
                  arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo - (jumlahTrf + 5000);
                  success:=true;
                end else if (((arrrekonline.list[i].uang = 'USD') or (arrrekonline.list[i].uang = 'EUR')) and (arrrekonline.list[i].saldo>=(jumlahTrf + 2))) then
                begin
                  arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo - (jumlahTrf + 2);
                  success:=true;
                end;
              end;
            end else
              success:=false;
            if (success) then
            begin
              arrtransfer.Neff:=arrtransfer.Neff+1;
              arrtransfer.list[arrtransfer.Neff].asal := arrrekonline.list[i].noakun;
              arrtransfer.list[arrtransfer.Neff].tujuan := notujuan;
              arrtransfer.list[arrtransfer.Neff].jenis := trfremarks;
              arrtransfer.list[arrtransfer.Neff].bank := banktujuan;
              arrtransfer.list[arrtransfer.Neff].uang := arrrekonline.list[i].uang;
              arrtransfer.list[arrtransfer.Neff].jumlah := jumlahTrf;
              arrtransfer.list[arrtransfer.Neff].saldoakhir := arrrekonline.list[i].saldo;
              arrtransfer.list[arrtransfer.Neff].tgl := FormatDateTime('DD-MM-YYYY',Now);
              writeln('> Transfer ke rekening ',notujuan,' berhasil! Jumlah saldo Anda adalah ',arrrekonline.list[i].saldo:0:2);
              if (trfremarks = 'dalam bank') then
              begin
                found:=false;
                i:=1;
                while (i<=arrrekonline.Neff) and (not(found)) do
                begin
                  if (arrrekonline.list[i].noakun = notujuan) then
                    found:=true
                  else
                    i:=i+1;
                end; { found or i <= arrrekonline.Neff}
                if (found) then
                begin
                  if (srccur = arrrekonline.list[i].uang) then 
                    arrrekonline.list[i].saldo := arrrekonline.list[i].saldo + jumlahTrf
                  else { mata uang rekening tujuan tidak sama }
                    arrrekonline.list[i].saldo := arrrekonline.list[i].saldo + CurrencyConvert(srccur,jumlahTrf,arrrekonline.list[i].uang);
                end; { tujuan transfer tidak ditemukan }
              end;
            end else { not(success) }
              writeln('> Anda tidak dapat melakukan transfer.');
          end else { not(found) }
            writeln('> Rekening tidak ditemukan!');
        end else { N=0 }
          writeln('> Anda tidak mempunyai ',jenis,'.');
      end;
end.
