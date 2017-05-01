unit ubukatutuprekening;
{ Berisi fungsi-fungsi yang menangani pembukaan dan penutupan rekening }

interface

	uses banktype, utampilanpengguna, sysutils;
	
	var
		jenis, noAk, mataUang, waktu, autodebet, noAkRekMandiri : string;
		setorAwal, setorRutin : real;
		jenisRek, rentangWaktu, i, j, N : integer;
		tempArray : TabString;
		swaktu : string;
		iwaktu : integer;
		pilwaktu : string;
		c : char;
		stop, found : boolean;
	
	procedure NomorAkunBaru(var noAk : string);
	{ Menerima masukan nomor akun rekening baru dari pengguna dan melakukan validasi apakah 
	  nomor akun tersebut masih tersedia atau telah ada }
	
	procedure BukaRekening();
	{ Membuat rekening online sesuai ketentuan pada penjelasan di atas }
	{ Nasabah memilih terlebih dahulu akan membuat rekening tabungan mandiri, deposito, atau tabungan rencana }
	
implementation

	procedure NomorAkunBaru(var noAk : string);
	var
		stop, found : boolean;
		i : integer;
	begin
		stop:=false;
		repeat
			write('> Masukkan nomor akun rekening baru: ');
			readln(noAk);
			found:=false;
			i:=1;
			while (i<=arrrekonline.Neff) and not(found) do
			begin
				if (arrrekonline.list[i].noakun=noAk) then
					found:=true
				else
					i:=i+1;
			end;
			if found then
				writeln('> Nomor akun yang Anda masukkan tidak tersedia. Silakan masukkan nomor akun yang lain!')
			else
				stop:=true;
		until stop;
	end;
	
	procedure BukaRekening();
	begin
		PilihJenisRekening(jenisRek);
		if (jenisRek=1) then
		begin
			jenis:='deposito';
			writeln('> Anda akan membuka rekening ',jenis,'!');
			NomorAkunBaru(noAk);
			{ Validasi mata uang }
			stop:=false;
			repeat
				write('> Masukkan mata uang yang akan digunakan (IDR/EUR/USD): ');
				readln(mataUang);
				if (mataUang='IDR') or (mataUang='EUR') or (mataUang='USD') then
					stop:=true
				else
					writeln('> Mata uang yang dimasukkan salah!');
			until stop;
			if (mataUang='IDR') then
			begin
				{ Validasi besar setoran awal }
				repeat
					write('> Masukkan besar setoran awal: ');
					readln(setorAwal);
					if (setorAwal<8000000) then
						writeln('> Minimum setoran awal untuk tabungan deposito adalah Rp8.000.000,00.');
				until (setorAwal>=8000000);
			end else if (mataUang='EUR') then
			begin
				{ Validasi besar setoran awal }
				repeat
					write('> Masukkan besar setoran awal: ');
					readln(setorAwal);
					if (setorAwal<550) then
						writeln('> Minimum setoran awal untuk tabungan deposito adalah EUR 550.');
				until (setorAwal>=550);
			end else { mataUang='USD' }
			begin
				{ Validasi besar setoran awal }
				repeat
					write('> Masukkan besar setoran awal: ');
					readln(setorAwal);
					if (setorAwal<600) then
						writeln('> Minimum setoran awal untuk tabungan deposito adalah USD 600.');
				until (setorAwal>=600);
			end;
			{ Masukan rentang waktu deposito }
			writeln('> Pilih rentang waktu deposito: ');
			writeln('> 1. 1 bulan');
			writeln('> 2. 3 bulan');
			writeln('> 3. 6 bulan');
			writeln('> 4. 12 bulan');
			{ Validasi masukan rentang waktu deposito }
			stop:=false;
			repeat
				write('> Masukkan rentang waktu yang diinginkan: ');
				readln(rentangWaktu);
				if (rentangWaktu>=1) and (rentangWaktu<=4) then
					stop:=true
				else
					writeln('> Rentang waktu deposito yang Anda masukkan salah!');
			until stop;
			if (rentangWaktu=1) then
				waktu:='1 bulan'
			else if (rentangWaktu=2) then
				waktu:='3 bulan'
			else if (rentangWaktu=3) then
				waktu:='6 bulan'
			else { rentangWaktu=4 }
				waktu:='1 tahun';
			{ Pencarian rekening tabungan mandiri yang dimiliki oleh pengguna }
			{ Jika nasabah sudah memiliki tabungan mandiri, maka dapat didefinisikan rekening autodebet dari salah 
			  satu rekening tabungan mandiri }
			IsiTempArray(tempArray,jenis,N,3);
			if (N=0) then
			begin
				autodebet:='-';
				writeln('> Anda tidak memiliki rekening tabungan mandiri yang dapat dijadikan rekening autodebet.');
			end else if (N=1) then
			begin
				autodebet:=tempArray[N];
				writeln('> Rekening ',tempArray[N],' menjadi rekening autodebet.');
			end else { N>1 }
			begin
				{ Jika rekening mandiri yang dimiliki pengguna lebih dari satu, pengguna diminta untuk memilih
				  rekening mandiri yang akan dijadikan rekening autodebet }
				TampilIsiTempArray(tempArray,N,jenis);
				repeat
					write('> Rekening: ');
					readln(noAkRekMandiri);
					{ Pencarian indeks nomor akun rekening yang dimasukkan pengguna pada tempArray }
					found:=false;
					i:=1;
					while (i<=N) and (not(found)) do
					begin
						if (tempArray[i]=noAk) then
							found:=true
						else
							i:=i+1;
					end;
					if found then
						autodebet:=tempArray[i]
					else
						writeln('> Rekening tidak ditemukan!');
				until found;
			end;
			setorRutin:=0;
			jenis:='deposito';
		end else if (jenisRek=2) then
		begin
			jenis:='tabungan rencana';
			writeln('> Anda akan membuka rekening ',jenis,'!');
			NomorAkunBaru(noAk);
			mataUang:='IDR';
			{ Validasi besar setoran awal }
			repeat
				write('> Masukkan besar setoran awal: ');
				readln(setorAwal);
				if (setorAwal<0) then
					writeln('Masukkan tidak valid!');
			until (setorAwal>=0);
			{ Validasi besar setoran rutin }
			repeat
				write('> Masukkan besar setoran rutin: ');
				readln(setorRutin);
				if (setorRutin<500000) then
					writeln('> Minimum setoran awal untuk tabungan deposito adalah Rp500.000,00.');
			until (setorRutin>=500000);
			{ Validasi jangka waktu tabungan rencana }
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
					waktu:=pilwaktu;
				end else
				begin
					writeln('> Masukkan salah. Silakan coba lagi');
				end;
			until (iwaktu <= 20) and (iwaktu >= 1);
			{ Pencarian rekening tabungan mandiri yang dimiliki oleh pengguna }
			{ Jika nasabah sudah memiliki tabungan mandiri, maka dapat didefinisikan rekening autodebet dari salah 
			  satu rekening tabungan mandiri }
			IsiTempArray(tempArray,jenis,N,3);
			if (N=0) then
			begin
				autodebet:='-';
				writeln('> Anda tidak memiliki rekening tabungan mandiri yang dapat dijadikan rekening autodebet.');
			end else if (N=1) then
			begin
				autodebet:=tempArray[N];
				writeln('> Rekening ',tempArray[N],' menjadi rekening autodebet.');
			end else { N>1 }
			begin
				{ Jika rekening mandiri yang dimiliki pengguna lebih dari satu, pengguna diminta untuk memilih
				  rekening mandiri yang akan dijadikan rekening autodebet }
				TampilIsiTempArray(tempArray,N,jenis);
				repeat
					write('> Rekening: ');
					readln(noAkRekMandiri);
					{ Pencarian indeks nomor akun rekening yang dimasukkan pengguna pada tempArray }
					found:=false;
					i:=1;
					while (i<=N) and (not(found)) do
					begin
						if (tempArray[i]=noAk) then
							found:=true
						else
							i:=i+1;
					end;
					if found then
						autodebet:=tempArray[i]
					else
						writeln('> Rekening tidak ditemukan!');
				until found;
			end;
			jenis:='tabungan rencana';
		end else { jenisRek=3 }
		begin
			jenis:='tabungan mandiri';
			writeln('> Anda akan membuka rekening ',jenis,'!');
			NomorAkunBaru(noAk);
			mataUang:='IDR';
			{ Validasi besar setoran awal }
			repeat
				write('> Masukkan besar setoran awal: ');
				readln(setorAwal);
				if (setorAwal<50000) then
					writeln('> Minimum setoran awal untuk tabungan mandiri adalah Rp50.000,00.');
			until (setorAwal>=50000);
			setorRutin:=0;
			autodebet:='-';
			waktu:='-';
		end;
		{ Update array rekening online }
		arrrekonline.Neff:=arrrekonline.Neff+1;
		arrrekonline.list[arrrekonline.Neff].noakun:=noAk;
		arrrekonline.list[arrrekonline.Neff].nonasabah:=currentuser.nonasabah;
		arrrekonline.list[arrrekonline.Neff].jenis:=jenis;
		arrrekonline.list[arrrekonline.Neff].uang:=mataUang;
		arrrekonline.list[arrrekonline.Neff].saldo:=setorAwal;
		arrrekonline.list[arrrekonline.Neff].setrutin:=setorRutin;
		arrrekonline.list[arrrekonline.Neff].autodebet:=autodebet;
		arrrekonline.list[arrrekonline.Neff].waktu:=waktu;
		arrrekonline.list[arrrekonline.Neff].tglmulai:=FormatDateTime('DD-MM-YYYY',Now);
		writeln('Rekening Anda berhasil dibuka!');
	end;

end.

