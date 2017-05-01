program buatrekening;
{Program untuk membuat rekening baru}
uses banktype,sysutils;

{Kamus Lokal}
var
	currentuser : nasabah;
	jenisRek : integer;
	stop : boolean;
	arrrekonline : lrekonline;
	jenis : string;
	setoran : real;
	temprek : rekonline;
	yakin : char;
	i,j : integer;
	found : boolean;
	autodebet : string;
	swaktu : string;
	iwaktu : integer;
	pilwaktu : string;
	c : char;
	
{Algoritma Utama}
begin
	writeln('> Pilih jenis rekening');
	writeln('> 1. Deposito');
	writeln('> 2. Tabungan rencana');
	writeln('> 3. Tabungan mandiri');
	//Validasi masukan jenis rekening 
	//Pengulangan akan berhenti jika pengguna memasukkan jenis rekening yang tepat, yaitu 1, 2, atau 3
	stop:=false;
	repeat
		write('> Jenis rekening yang akan dibuat : ');
		readln(jenisRek);
		if (jenisRek>= 1) and (jenisRek <=3) then
		begin
			stop:=true;
		end else
		begin
			writeln('> Jenis rekening yang Anda masukkan salah!');
		end;
	until stop;
	
	{Pembuatan rekening deposito}
	if (jenisRek = 1) then
	begin
		jenis := 'deposito';
		writeln('> Jenis rekening yang akan dibuat adalah ',jenis);
		write('> Masukkan nomor rekening : ');
		readln(temprek.noakun);
		temprek.jenis := jenis;
		temprek.nonasabah := currentuser.nonasabah;
		
		{Validasi input mata uang}
		repeat
			write('> Masukkan jenis kurs yang digunakan (IDR/EUR/USD) : ');
			readln(temprek.uang);
			if (temprek.uang = 'EUR') then
			begin
				repeat
					write('> Masukkan besar setoran awal : ');
					readln(setoran);
					if(setoran < 550) then
					begin
						writeln('> Setoran awal minimal 550 EUR. Silakan masukkan kembali.');
					end;
				until (setoran >= 550);
			end else
			if (temprek.uang = 'USD') then
			begin
				repeat
					write('> Masukkan besar setoran awal : ');
					readln(setoran);
					if(setoran < 600) then
					begin
						writeln('> Setoran awal minimal 600 USD. Silakan masukkan kembali.');
					end;
				until (setoran >= 600);
			end else
			if(temprek.uang = 'IDR') then
			begin
				repeat
					write('> Masukkan besar setoran awal : ');
					readln(setoran);
					if(setoran < 8000000) then
					begin
						writeln('> Setoran awal minimal Rp.8.000.000. Silakan masukkan kembali.');
					end;
				until (setoran >= 8000000);
			end else
				writeln('> Masukkan salah. Silakan coba lagi');
		until (temprek.uang = 'IDR') or (temprek.uang = 'USD') or (temprek.uang = 'EUR');
		
		temprek.saldo := setoran;
		temprek.setrutin := 0;
		i := 0;
		
		{Pencarian rekening tabungan mandiri untuk dimasukkan ke rekening auto debet}
		found := false;
		write('> Masukkan nomor rekening autodebet anda : ');
		readln(autodebet);
		while (i<= arrrekonline.neff) and not(found) do
		begin
			i := i +1;
			if (arrrekonline.list[i].noakun = autodebet) then
			begin
				found := true;
			end;
		
		if (found) then
		begin
			temprek.autodebet := autodebet;
		end else
			writeln('> Anda tidak memiliki rekening mandiri');
		
		{Input jangka waktu dan validasi input}
		repeat
			writeln('> Pilih jangka waktu deposito : ');
			writeln('> 1 bulan');
			writeln('> 3 bulan');
			writeln('> 6 bulan');
			writeln('> 12 bulan');
			write('> Masukkan jangka waktu : ');
			readln(temprek.waktu);
			if (temprek.waktu <> '1 bulan') or (temprek.waktu <> '3 bulan') or (temprek.waktu <> '6 bulan') or (temprek.waktu <> '12 bulan') then
			begin
				writeln('> Masukkan salah. Silakan coba lagi');
			end;
		until (temprek.waktu = '1 bulan') or (temprek.waktu = '3 bulan') or (temprek.waktu = '6 bulan') or (temprek.waktu = '12 bulan');
		
		temprek.tglmulai := FormatDateTime('DD-MM-YYYY',Now);
		
		{Menampilkan data rekening yang telah di input}
		writeln();
		writeln('> Ini adalah rekening ',jenis,' baru anda :');
		writeln('> Nomor Rekening : ',temprek.noakun);
		writeln('> Jenis Rekening : ',temprek.jenis);
		writeln('> Mata Uang : ',temprek.uang);
		writeln('> Setoran Awal : ',temprek.saldo);
		if (found) then
		begin
			writeln('> Rekening Auto Debet : ', temprek.autodebet);
		end;
		writeln('> Jangka Waktu : ',temprek.waktu);
		
		{Validasi pembuatan rekening}
		write('> Apakah anda yakin akan membuat rekening ini ?(y/n) : ');
		readln(yakin);
		if (yakin = 'y') then
		begin
			arrrekonline.neff := arrrekonline.neff +1;
			arrrekonline.list[arrrekonline.neff] := temprek;
			writeln('> Rekening anda berhasil dibuat. Terimakasih');
		end else
		begin
			writeln('> Pembuatan rekening dibatalkan');
		end;
		end;
	end else
	
	{Pembuatan rekening Tabungan Rencana}
	if (jenisRek = 2) then
	begin
		jenis := 'tabungan rencana';
		writeln('> Jenis rekening yang akan dibuat adalah ',jenis);
		write('> Masukkan nomor rekening : ');
		readln(temprek.noakun);
		temprek.jenis := jenis;
		temprek.nonasabah := currentuser.nonasabah;
		temprek.uang := 'IDR';
		
		{Validasi Input Setoran Awal}
		repeat
			write('> Masukkan jumlah setoran awal : ');
			readln(temprek.saldo);
			if (temprek.saldo < 0) then
			begin
				writeln('> Masukkan tidak valid. Silakan coba lagi.');
			end;
		until (temprek.saldo >= 0);
		
		{Validasi jumlah setoran rutin bulanan}
		repeat 
			write('> Masukkan jumlah setoran rutin bulanan : ');
			readln(temprek.setrutin);
			if (temprek.setrutin < 500000) then
			begin
				writeln('> Masukkan tidak valid. SIlakan coba lagi.');
			end;
		until (temprek.setrutin >= 500000);

		{Pencarian dan Pemasukan rekening auto debet }
		i := 0;
		found := false;
		write('> Masukkan nomor rekening autodebet anda : ');
		readln(autodebet);
		while (i<= arrrekonline.neff) and not(found) do
		begin
			i := i +1;
			if (arrrekonline.list[i].noakun = autodebet) and (arrrekonline.list[i].jenis = 'tabungan mandiri') then
			begin
				found := true;
			end;
		if (found) then
		begin
			temprek.autodebet := autodebet;
		end else
			writeln('> Anda tidak memiliki rekening mandiri');
		
		{Validasi input jangka waktu}
		repeat
			write('> Pilih jangka waktu tabungan rencana (1 tahun s/d 20 tahun) :  ');
			readln(pilwaktu);
			j := 1;
			stop := false;
			swaktu := '';
			while (j <= length(pilwaktu)) and not(stop) do
			begin
				c := pilwaktu[j];
				if(c <> ' ') then 
				begin
					swaktu := swaktu + c;
					j := j + 1;
				end else stop := true;
			end;
			iwaktu := StrToInt(swaktu);
			if(iwaktu <= 20) and (iwaktu >= 1) then
			begin
				temprek.waktu := pilwaktu;
			end else
			begin
				writeln('> Masukkan salah. Silakan coba lagi');
			end;
		until (iwaktu <= 20) and (iwaktu >= 1);
		temprek.tglmulai := FormatDateTime('DD-MM-YYYY',Now);
		
		{Menampilkan data rekening yang telah di input}
		writeln();
		writeln('> Ini adalah rekening ',jenis,' baru anda :');
		writeln('> Nomor Rekening : ',temprek.noakun);
		writeln('> Jenis Rekening : ',temprek.jenis);
		writeln('> Mata Uang : ',temprek.uang);
		writeln('> Setoran Awal : ',temprek.saldo);
		writeln('> Setoran Rutin : ',temprek.setrutin);
		if (found) then
		begin
			writeln('> Rekening Auto Debet : ', temprek.autodebet);
		end;
		writeln('> Jangka Waktu : ',temprek.waktu);
		write('> Apakah anda yakin akan membuat rekening ini ?(y/n) : ');
		readln(yakin);
		if (yakin = 'y') then
		begin
			arrrekonline.neff := arrrekonline.neff +1;
			arrrekonline.list[arrrekonline.neff] := temprek;
			writeln('> Rekening anda berhasil dibuat. Terimakasih');
		end else
		begin
			writeln('> Pembuatan rekening dibatalkan');
		end;
		end;
	end else
	
	{Pembuatan rekening mandiri}
	if (jenisRek = 3) then
	begin
		jenis := 'tabungan mandiri';
		writeln('> Jenis rekening yang akan dibuat adalah ',jenis);
		write('> Masukkan nomor rekening : ');
		readln(temprek.noakun);
		temprek.jenis := jenis;
		temprek.nonasabah := currentuser.nonasabah;
		temprek.uang := 'IDR';
		
		{Validasi input setoran awal}
		repeat
			write('> Masukkan besar setoran awal : ');
			readln(setoran);
			if(setoran < 50000) then
			begin
				writeln('> Setoran awal minimal Rp.50.000. Silakan masukkan kembali.');
			end;
		until (setoran >= 50000);
		temprek.saldo := setoran;
		temprek.setrutin := 0;
		temprek.autodebet := '-';
		temprek.waktu := '-';
		temprek.tglmulai := FormatDateTime('DD-MM-YYYY',Now);
		
		{Menampilkan data rekening yang telah di input}
		writeln();
		writeln('> Ini adalah rekening ',jenis,' baru anda :');
		writeln('> Nomor Rekening : ',temprek.noakun);
		writeln('> Jenis Rekening : ',temprek.jenis);
		writeln('> Mata Uang : ',temprek.uang);
		writeln('> Setoran Awal : ',temprek.saldo);
		write('> Apakah anda yakin akan membuat rekening ini ?(y/n) : ');
		readln(yakin);
		if (yakin = 'y') then
		begin
			arrrekonline.neff := arrrekonline.neff +1;
			arrrekonline.list[arrrekonline.neff] := temprek;
			writeln('> Rekening anda berhasil dibuat. Terimakasih');
		end else
		begin
			writeln('> Pembuatan rekening dibatalkan');
		end;
	end;
end.
