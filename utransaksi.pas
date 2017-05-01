unit utransaksi;
{ Berisi fungsi-fungsi transaksi (setoran, penarikan, transfer, pembelian, pembayaran) }

interface
  uses banktype, utampilanpengguna, sysutils, dateutils,ulihatrek;
  
  type
	  TabString = array [1..50] of string;

  var
      tempArray : TabString;
      pil : char;
      jenisRek : integer;
      jenis, noAk, notujuan, banktujuan, trfremarks, srccur : string;
      jumlahSetor, jumlahTarik, jumlahTrf : real;
      stop, found, success : boolean;
      N : integer;
      i, j : integer;

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
    
  procedure pembelian_do(harga : real;arr : integer;nomor : string);
  { Prosedur utama yang melakukan proses pembelian berbagai barang yang disediakan }
  
  procedure menu_pembelian();
  { Menampilkan menu pembelian, yaitu list produk/jasa yang tersedia dan menangani pilihan user.
    Jika pilihan user benar, maka proses pembelian akan ditangani prosedur pembelian_do }
  procedure bayarya ();
  {input rekening mana yg mau dipake bwt bayar, pilih pembayaran, masukin nominal pembayaran, lalu saldo rekening
  akan berkurang sesuai bayartotal}
implementation

  function SudahJatuhTempo (rekonline : rekonline) : boolean;
  { Spesifikasi lihat di bagian interface }
  { Kamus }
  var
    tanggalMulai, jatuhTempo : TDateTime;
    cmd, waktu : integer;
    date, month, year, swaktu : string;
    dd, mm, yy : integer;
    j : integer;
    c : char;

  { Algoritma }
  begin
    date:=copy(rekonline.tglmulai,1,2);
    month:=copy(rekonline.tglmulai,4,2);
    year:=copy(rekonline.tglmulai,7,4);
    val(date,dd);
    val(month,mm);
    val(year,yy);
    tanggalMulai:=EncodeDate(yy,mm,dd);
    if (rekonline.jenis = 'deposito') then
    begin
      case rekonline.waktu of       //case waktu deposito dan mengincrement bulan sebesar waktunya
        '1 bulan' : jatuhTempo:=IncMonth(tanggalMulai,1);
        '3 bulan' : jatuhTempo:=IncMonth(tanggalMulai,3);
        '6 bulan' : jatuhTempo:=IncMonth(tanggalMulai,6);
        '1 tahun' : jatuhTempo:=IncMonth(tanggalMulai,12);
      end;
    end 
    else if (rekonline.jenis = 'tabungan rencana') then  //case waktu tabungan rencana dan mengincrement tahun sebesar waktunya
    begin
      j := 1;
      stop := false;
      swaktu := '';
      while (j <= length(rekonline.waktu)) and not(stop) do
      begin
        c := rekonline.waktu[j];
        if(c <> ' ') then 
        begin
          swaktu := swaktu + c;
          j := j + 1;
        end else stop := true;
      end;
      waktu := StrToInt(swaktu);
      jatuhTempo := IncYear(tanggalMulai,waktu);
    end;
    cmd := CompareDate(jatuhTempo,Now); //membandingkan tanggal jatuh tempo dengan tanggal login user
    SudahJatuhTempo := cmd<=0;
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
		PilihJenisRekening(jenisRek);
    	IsiTempArray(tempArray,jenis,N,jenisRek);
    	if (N>0) then
    	begin
			TampilIsiTempArray(tempArray,N,jenis);
			write('> Rekening: ');
			readln(noAk);
			CariIdxpadaTempArray(tempArray,noAk,N,found);
    		if found then
    		begin
				CariIdxpadaArrRekOnline(arrrekonline,noAk,j);
    			write('> Jumlah setoran: ');
    			readln(jumlahSetor);
    			{ Update besar saldo }
    			arrrekonline.list[j].saldo:=arrrekonline.list[j].saldo+jumlahSetor;
    			{ Update array transaksi setoran/penarikan }
    			arrtransaksi.Neff:=arrtransaksi.Neff+1;
    			arrtransaksi.list[arrtransaksi.Neff].noakun:=arrrekonline.list[j].noakun;
    			arrtransaksi.list[arrtransaksi.Neff].jenis:='setoran';
    			arrtransaksi.list[arrtransaksi.Neff].uang:=arrrekonline.list[j].uang;
    			arrtransaksi.list[arrtransaksi.Neff].jumlah:=jumlahSetor;
    			arrtransaksi.list[arrtransaksi.Neff].saldoakhir:=arrrekonline.list[j].saldo;
    			arrtransaksi.list[arrtransaksi.Neff].tgl:=FormatDateTime('DD-MM-YYYY',Now);
    			writeln('> Setoran berhasil! Jumlah saldo Anda adalah ',arrrekonline.list[j].saldo:0:2);
    		end else { not(found) }
    			writeln('> Rekening tidak ditemukan!');
    	end else { N=0 }
    		writeln('> Anda tidak mempunyai ',jenis,'.');
    end;

  procedure penarikan();

    begin
		PilihJenisRekening(jenisRek);
    	IsiTempArray(tempArray,jenis,N,jenisRek);
    	if (N>0) then
    	begin
    		TampilIsiTempArray(tempArray,N,jenis);
    		write('> Rekening: ');
			readln(noAk);
			CariIdxpadaTempArray(tempArray,noAk,N,found);
    		if found then
    		begin
				CariIdxpadaArrRekOnline(arrrekonline,noAk,j);
    			write('> Masukkan jumlah uang yang diinginkan : ');
    			readln(jumlahTarik);
    			if (jenis='tabungan mandiri') and (arrrekonline.list[j].saldo>=jumlahTarik) then
    			begin
    				arrrekonline.list[j].saldo:=arrrekonline.list[j].saldo-jumlahTarik;
    				success:=true;
    			end else if ((jenis='deposito') or (jenis='tabungan rencana')) and (arrrekonline.list[j].saldo>=jumlahTarik) and SudahJatuhTempo(arrrekonline.list[j]) then
    			begin
    				arrrekonline.list[j].saldo:=arrrekonline.list[j].saldo-jumlahTarik;
    				success:=true;
    			end else
    				success:=false;
    			if (success=true) then
    			begin
    				arrtransaksi.Neff:=arrtransaksi.Neff+1;
    				arrtransaksi.list[arrtransaksi.Neff].noakun:=arrrekonline.list[j].noakun;
    				arrtransaksi.list[arrtransaksi.Neff].jenis:='penarikan';
    				arrtransaksi.list[arrtransaksi.Neff].uang:=arrrekonline.list[j].uang;
    				arrtransaksi.list[arrtransaksi.Neff].jumlah:=jumlahTarik;
    				arrtransaksi.list[arrtransaksi.Neff].saldoakhir:=arrrekonline.list[j].saldo;
    				arrtransaksi.list[arrtransaksi.Neff].tgl:=FormatDateTime('DD-MM-YYYY',Now);
    				writeln('> Penarikan berhasil! Jumlah saldo Anda adalah ',arrrekonline.list[j].saldo:0:2);
    			end else { not(success) }
    				writeln('> Anda tidak dapat melakukan penarikan.');
    		end else { not(found) }
    			writeln('> Rekening tidak ditemukan!');
    	end else { N=0 }
    		writeln('> Anda tidak mempunyai ',jenis,'.');
    end;

  procedure transfer();

    begin
	  PilihJenisRekening(jenisRek);
      IsiTempArray(tempArray,jenis,N,jenisRek);
      if (N>0) then
      begin
        TampilIsiTempArray(tempArray,N,jenis);
        write('> Rekening : ');
        readln(noAk);
        CariIdxpadaTempArray(tempArray,noAk,N,found);
        if found then
        begin
		  CariIdxpadaArrRekOnline(arrrekonline,noAk,i);
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
              end; { tujuan transfer tidak ditemukan (do nothing) }
            end; { tujuan transfer bukan satu bank (do nothing) }
          end else { not(success) }
            writeln('> Anda tidak dapat melakukan transfer.');
        end else { not(found) }
          writeln('> Rekening tidak ditemukan!');
      end else { N=0 }
        writeln('> Anda tidak mempunyai ',jenis,'.');
    end;

  procedure pembelian_do(harga : real;arr : integer;nomor : string);

  var
    ganti : real;

  {Algoritma Prosedur}
  begin
    PilihJenisRekening(jenisRek);
    IsiTempArray(tempArray,jenis,N,jenisRek);
    if (N>0) then
    begin
      TampilIsiTempArray(tempArray,N,jenis);
      write('> Rekening: ');
      readln(noAk);
      CariIdxpadaTempArray(tempArray,noAk,N,found);
	  if found then
	  begin
		  CariIdxpadaArrRekOnline(arrrekonline,noAk,i);
          if (arrrekonline.list[i].uang <> 'IDR') then
          begin
			  ganti := CurrencyConvert(arrrekonline.list[i].uang,arrrekonline.list[i].saldo,'IDR');
			  if (jenis='tabungan mandiri') and (arrrekonline.list[i].saldo>=ganti) then
              begin
					arrrekonline.list[i].saldo:=CurrencyConvert('IDR',(arrrekonline.list[i].saldo-ganti),arrrekonline.list[i].uang);
					success:=true;
			  end else if ((jenis='deposito') or (jenis='tabungan rencana')) and (CurrencyConvert(arrrekonline.list[i].uang,arrrekonline.list[i].saldo,'IDR')>=harga) and (SudahJatuhTempo(arrrekonline.list[i])) then 
			  begin
					arrrekonline.list[i].saldo:=CurrencyConvert('IDR',(arrrekonline.list[i].saldo-ganti), arrrekonline.list[i].uang);
					success:=true;
			  end else
					success:=false;
		  end else if (jenis='tabungan mandiri') and (arrrekonline.list[i].saldo>=harga) then
          begin
			  arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-harga;
			  success:=true;
          end else if ((jenis='deposito') or (jenis='tabungan rencana')) and (CurrencyConvert(arrrekonline.list[i].uang,arrrekonline.list[i].saldo,'IDR')>= harga) and (SudahJatuhTempo(arrrekonline.list[i])) then 
          begin
			  arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-harga;
			  success:=true;
		  end else
			  success:=false;
          if (success=true) then
          begin
			  arrbeli.Neff:=arrbeli.Neff+1;
              arrbeli.list[arrbeli.Neff].noakun:=arrrekonline.list[i].noakun;
              arrbeli.list[arrbeli.Neff].jenis:=arrbarang.list[arr].jenis;
              arrbeli.list[arrbeli.Neff].penyedia:=arrbarang.list[arr].penyedia;
              arrbeli.list[arrbeli.Neff].nomortujuan:=nomor;
              arrbeli.list[arrbeli.Neff].uang:=arrrekonline.list[i].uang;
              arrbeli.list[arrbeli.Neff].jumlah:=harga;
              arrbeli.list[arrbeli.Neff].saldoakhir:= arrrekonline.list[i].saldo;
              arrbeli.list[arrbeli.Neff].tgl:=FormatDateTime('DD-MM-YYYY',Now);
              writeln('> Pembelian Berhasil ! Saldo Anda sekarang adalah ',arrrekonline.list[i].saldo:0:0);
          end else
          begin
              writeln('> Anda tidak dapat melakukan pembelian.')
          end;
      end else { not(found1) }
          writeln('> Rekening tidak ditemukan!');
    end else { N=0 }
    begin
      writeln('> Anda tidak mempunyai ',jenis,'.');
    end;
  end;

  procedure menu_pembelian();

  var
    pilih : integer;
    nomor : string;

  begin
    for i := 1 to arrbarang.neff do
      begin
        writeln('> ',i,'. ',arrbarang.list[i].jenis, ' | ',arrbarang.list[i].penyedia, ' | ',arrbarang.list[i].harga:0:0);     //Menampilkan barang yang tersedia
      end;
      repeat
        writeln('> Masukkan pilihan anda : ');
        write('> ');
        readln(pilih);
        if (pilih < 1) and (pilih >arrbarang.neff) then
          writeln('> Pilihan tidak valid. Silakan coba lagi');
    until (pilih >=1) and (pilih <= arrbarang.neff);
    writeln('> Masukkan nomor tujuan :');
    write('> ');
    readln(nomor);
    pembelian_do(arrbarang.list[pilih].harga,pilih,nomor);
  end;

 procedure bayarya ();
	var
		noAk,pil,nobayar:string;
		i,jt:integer;{jt=jenis transaksi}
		harini,s1:string;
		ang,sel:integer;
		bayartotal,jumbayar:real;{jumbayar yg ori, bayartotal yg abis ada denda dan kurs}
		denda,tukar,found:boolean; {denda true=klo >tgl15, tukar=true klo di rekonline bkn IDR dan di pembayaran pake IDR}
	begin
		writeln('Masukkan Nomor Akun yang akan anda gunakan untuk membayar');
		readln(noAk);
		found:=false;
		i:=1;
		while (i<=arrrekonline.Neff) and (not(found)) do
		begin
			if (arrrekonline.list[i].noakun=noAk) then
				found:=true
			else
				i:=i+1;
		end;//cek 
		if(found=true) then
		begin
		if (SudahJatuhTempo(arrrekonline.list[i])=true) then
		begin {klo udh jatuh tempo baru bisa melakukan pembayaran}
					writeln ('Pilih Jenis Pembayaran');
					writeln('1. Listrik');{ada batas tgl 15}
					writeln('2. BPJS');
					writeln('3. PDAM');{ada batas tgl 15}
					writeln('4. Telepon');{ada batas tgl 15}
					writeln('5. TV Kabel');{ada batas tgl 15}
					writeln('6. Kartu Kredit');
					writeln('7. Pajak');
					writeln('8. Pendidikan');
					writeln('9. Internet');{ada batas tgl 15}
					writeln('10. Transaksi Lain');
					write ('Jenis Transaksi Pembayaran : ');
					readln(jt);
					case jt of
						1 : pil :='Listrik';
						2 : pil := 'BPJS';
						3 : pil := 'PDAM';
						4 : pil := 'Telepon';
						5 : pil := 'TV Kabel';
						6 : pil := 'Kartu Kredit';
						7 : pil := 'Pajak';
						8 : pil := 'Pendidikan'
						else begin
							Write ('Jenis Transaksi : ');
							readln(pil);
						end;
					end;
					write('Nomor Pembayaran : ');
					readln(nobayar);
					harini:=FormatDateTime('DD-MM-YYYY',Now);//now bwt nentuin udh lewat tgl 15 ato blum
					s1:=gettgl(harini);//dapet tgl brp
					val(s1,ang);//ang jadi variabel integer hasil konversi dari s1
					sel:=ang-15;//selisih hari stlh lewat tgl 15
					if((jt=1) or(jt=3) or(jt=4) or(jt=5) or(jt=9)) and (ang>15) then //ada kriteria yg lebih tgl 15 kena denda
					begin{pengecekan kena denda ato ga}
						denda:=true;
					end else begin
						denda:=false;
					end;
					writeln('Masukkan Jumlah yang ingin dibayar');
					readln(jumbayar);
					{bagian ini cuma bwt cari kurs di rekonline}
						if((arrrekonline.list[i].uang)<>'IDR') then
						begin
							tukar:=true; //hrs dikonversi klo bkn IDR
						end else begin
							tukar:=false; //ga perlu dikonversi klo IDR
						end;
					{cari kurs selese}
					if(denda=true) and(tukar=true) then
					begin{kena denda dan beda kurs}
						bayartotal:= CurrencyConvert('IDR',(jumbayar + 10000*sel),(arrrekonline.list[i].uang));
					end else if(denda=true) and (tukar=false) then
					begin{kena denda tapi kurs sama}
						bayartotal:= jumbayar + 10000*sel;
					end else if(denda=false) and (tukar=true) then
					begin{ga kena denda dan beda kurs}
						bayartotal:= CurrencyConvert('IDR',jumbayar,(arrrekonline.list[i].uang));
					end else begin {ga kena denda dan kurs sama}
						bayartotal:=jumbayar;
					end;
					arrbayar.Neff:=arrbayar.Neff + 1;
					{nulis di arrbayar yg baru}
					arrbayar.list[arrbayar.Neff].noakun:= arrrekonline.list[i].noakun;
					arrbayar.list[arrbayar.Neff].jenis:= pil;
					arrbayar.list[arrbayar.Neff].nomorbayar:= nobayar;
					arrbayar.list[arrbayar.Neff].uang:= 'IDR';
					arrbayar.list[arrbayar.Neff].jumlah:= jumbayar;
					arrbayar.list[arrbayar.Neff].saldoakhir:= (arrrekonline.list[i].saldo)-bayartotal; 
					arrbayar.list[arrbayar.Neff].tgl:= FormatDateTime('DD-MM-YYYY',Now);
					writeln('Transaksi Pembayaran Anda Telah Sukses! Sisa Saldo Anda Sekarang ',arrbayar.list[arrbayar.Neff].saldoakhir:0:2);
		end else begin
			Writeln('Waktu Batas Pengambilan Belum Lewat, Transaksi Gagal');
		end;
		end;
	end;
end.
