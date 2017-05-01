unit ututup;
{unit yang digunakan untuk menutup sebuah rekening}
uses banktype, sysutils, dateutils,utransaksi;
interface
	uses uadminnasabah,banktype,sysutils;
{Kamus Global}
var
	biaya : real;
	arrrekonline : lrekonline;
	jenisRek : integer;
	stop, found, tutup : boolean;
	currentuser : nasabah;
	tempArray : array [1..50] of string;
	i, N,j : integer;
	jumlah : real;
	noAk : string;
	jenis : string;
	{fungsi dan prosedur}
function Kuranghari (rekonline : rekonline;jenis : string) : integer;
{ Menghasilkan true jika telah memenuhi waktu jatuh tempo dan false jika
  belum memenuhi waktu jatuh tempo }
{ Waktu jatuh tempo dihitung dari tanggal pembuatan rekening ke jangka 
  waktu yang ditentukan untuk rekening tersebut }
procedure tutuprek ();
//IS:
//FS:

implementation
function Kuranghari (rekonline : rekonline;jenis : string) : integer;


{ Kamus Lokal }
var
	tanggalMulai, jatuhTempo 	: TDateTime;
	cmd 						: integer;
	date, month, year 			: string;
	dd, mm, yy 					: integer;
	
{ Algoritma }
begin
	date:=copy(rekonline.tglmulai,1,2);		//Menyalin tanggal dari array rekonline
	month:=copy(rekonline.tglmulai,4,2);	//Menyalin bulan dari array rekonline
	year:=copy(rekonline.tglmulai,7,4);		//Menyalin tahun dari array rekonline
	val(date,dd);							//Mengubah bentuk tanggal dari string to integer
	val(month,mm);							//Mengubah bentuk bulan dari string to integer
	val(year,yy);							//Mengubah bentuk tahun dari string to integer
	tanggalMulai:=EncodeDate(yy,mm,dd);		//Mengubah bentuk yy mm dd menjadi type tanggal
	if (jenis = 'deposito') then
	begin
		case rekonline.waktu of				//case waktu deposito dan mengincrement bulan sebesar waktunya
			'1 bulan' : jatuhTempo:=IncMonth(tanggalMulai,1);
			'3 bulan' : jatuhTempo:=IncMonth(tanggalMulai,3);
			'6 bulan' : jatuhTempo:=IncMonth(tanggalMulai,6);
			'1 tahun' : jatuhTempo:=IncMonth(tanggalMulai,12);
		end;
	end else
	if (jenis = 'tabungan rencana') then	//case waktu tabungan rencana dan mengincrement tahun sebesar waktunya
	begin
		case rekonline.waktu of
			'1 tahun' : jatuhTempo:=IncYear(tanggalMulai,1);	
			'2 tahun' : jatuhTempo:=IncYear(tanggalMulai,2);
			'3 tahun' : jatuhTempo:=IncYear(tanggalMulai,3);
			'4 tahun' : jatuhTempo:=IncYear(tanggalMulai,4);
			'5 tahun' : jatuhTempo:=IncYear(tanggalMulai,5);	
			'6 tahun' : jatuhTempo:=IncYear(tanggalMulai,6);
			'7 tahun' : jatuhTempo:=IncYear(tanggalMulai,7);
			'8 tahun' : jatuhTempo:=IncYear(tanggalMulai,8);
			'9 tahun' : jatuhTempo:=IncYear(tanggalMulai,9);	
			'10 tahun' : jatuhTempo:=IncYear(tanggalMulai,10);
			'11 tahun' : jatuhTempo:=IncYear(tanggalMulai,11);
			'12 tahun' : jatuhTempo:=IncYear(tanggalMulai,12);
			'13 tahun' : jatuhTempo:=IncYear(tanggalMulai,13);
			'14 tahun' : jatuhTempo:=IncYear(tanggalMulai,14);	
			'15 tahun' : jatuhTempo:=IncYear(tanggalMulai,15);
			'16 tahun' : jatuhTempo:=IncYear(tanggalMulai,16);
			'17 tahun' : jatuhTempo:=IncYear(tanggalMulai,17);
			'18 tahun' : jatuhTempo:=IncYear(tanggalMulai,18);	
			'19 tahun' : jatuhTempo:=IncYear(tanggalMulai,19);
			'20 tahun' : jatuhTempo:=IncYear(tanggalMulai,20);
		end;
	end;
	cmd:=DaysBetween(jatuhTempo,Now);					//membandingkan tanggal setelah di increment dengan waktu sekarang
	Kuranghari:=cmd;							
end;

{Algoritma}
procedure tutuprek ();
begin
	writeln('> Pilih jenis rekening');
	writeln('> 1. Deposito');
	writeln('> 2. Tabungan rencana');
	writeln('> 3. Tabungan mandiri');
	//Validasi masukan jenis rekening 
	//Pengulangan akan berhenti jika pengguna memasukkan jenis rekening yang tepat, yaitu 1, 2, atau 3
	stop:=false;
	repeat
		write('> Jenis rekening yang akan ditutup : ');
		readln(jenisRek);
		if (jenisRek>= 1) and (jenisRek <=3) then
		begin
			stop:=true;
		end else
		begin
			writeln('> Jenis rekening yang Anda masukkan salah!');
		end;
	until stop;
	
	//Mendaftarkan nomor akun rekening-rekening milik pengguna ke array tempArray sesuai dengan masukan jenis rekening 
	//N adalah banyaknya rekening milik pengguna dengan jenis tertentu sesuai masukan pengguna
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
			begin
				found:=true;
			end else
			begin
				i:=i+1;
			end;
		end;	
		
		tutup := false;
		if(jenis = 'tabungan mandiri') then
		begin
			if(arrrekonline.list[i].uang <> 'IDR') then
			begin
				jumlah := CurrencyConvert(arrrekonline.list[i].uang,arrrekonline.list[i].saldo - 25000,'IDR');
			end else
				jumlah := arrrekonline.list[i].saldo - 25000;
			if ( jumlah >= 0) then
			begin
				tutup := true;
				for j := i+1 to arrrekonline.neff+1 do
				begin
					arrrekonline.list[j-1] := arrrekonline.list[j];
				end;
			arrrekonline.neff := arrrekonline.neff-1;
		end else
		if (jenis = 'tabungan rencana') then
		begin
			if not(SudahJatuhTempo(arrrekonline.list[i])) then
			begin
				if(arrrekonline.list[i].uang <> 'IDR') then
				begin
					jumlah := CurrencyConvert(arrrekonline.list[i].uang,arrrekonline.list[i].saldo - 200000,'IDR');
				end else
					jumlah := arrrekonline.list[i].saldo - 200000;
				if ( jumlah >= 0) then
				begin
					tutup := true;
					for j := i+1 to arrrekonline.neff+1 do
					begin
						arrrekonline.list[j-1] := arrrekonline.list[j];
					end;
				arrrekonline.neff := arrrekonline.neff-1;
				end;
			end;
			end else
			begin
				if(arrrekonline.list[i].uang <> 'IDR') then
				begin
					jumlah := CurrencyConvert(arrrekonline.list[i].uang,arrrekonline.list[i].saldo - 25000,'IDR');
				end else
					jumlah := arrrekonline.list[i].saldo - 25000;
				if (jumlah >= 0) then
				begin
					tutup := true;
					for j := i+1 to arrrekonline.neff+1 do
					begin
						arrrekonline.list[j-1] := arrrekonline.list[j];
					end;
				arrrekonline.neff := arrrekonline.neff-1;
				end;
			end;
		end else
		if (jenis = 'deposito')  and (SudahJatuhTempo(arrrekonline.list[i])) then
		begin
			if (SudahJatuhTempo(arrrekonline.list[i])) then
			begin
				if(arrrekonline.list[i].uang <> 'IDR') then
				begin
					jumlah := CurrencyConvert(arrrekonline.list[i].uang,arrrekonline.list[i].saldo - 25000,'IDR');
				end else
					jumlah := arrrekonline.list[i].saldo - 25000;
				if ( jumlah >= 0) then
				begin
					tutup := true;
					for j := i+1 to arrrekonline.neff+1 do
					begin
						arrrekonline.list[j-1] := arrrekonline.list[j];
					end;
				arrrekonline.neff := arrrekonline.neff-1;
				end;
			end else
			if not(SudahJatuhTempo(arrrekonline.list[i])) then
			begin
				biaya := 10000 * Kuranghari(arrrekonline.list[i],jenis);
				if(arrrekonline.list[i].uang <> 'IDR') then
				begin
					jumlah := CurrencyConvert(arrrekonline.list[i].uang,arrrekonline.list[i].saldo - biaya,'IDR');
				end else
					jumlah := arrrekonline.list[i].saldo - biaya;
				if ( jumlah >= 0) then
				begin
					tutup := true;
					for j := i+1 to arrrekonline.neff+1 do
					begin
						arrrekonline.list[j-1] := arrrekonline.list[j];
					end;
				end;
			end;
		end;
		
		if (tutup) and (jumlah >= 0) then 
		begin
			writeln('> Pilih jenis rekening tujuan pemindahan saldo anda : ');
			writeln('> 1. Deposito');
			writeln('> 2. Tabungan rencana');
			writeln('> 3. Tabungan mandiri');
			//Validasi masukan jenis rekening 
			//Pengulangan akan berhenti jika pengguna memasukkan jenis rekening yang tepat, yaitu 1, 2, atau 3
			stop:=false;
			repeat
				write('> Jenis rekening yang akan ditutup : ');
				readln(jenisRek);
				if (jenisRek>= 1) and (jenisRek <=3) then
				begin
					stop:=true;
				end else
				begin
					writeln('> Jenis rekening yang Anda masukkan salah!');
				end;
			until stop;
	
			//Mendaftarkan nomor akun rekening-rekening milik pengguna ke array tempArray sesuai dengan masukan jenis rekening 
			//N adalah banyaknya rekening milik pengguna dengan jenis tertentu sesuai masukan pengguna
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
					begin
						found:=true;
					end else
					begin
						i:=i+1;
					end;
				end;	
			
			
			if (arrrekonline.list[i].uang <> 'IDR') then
			begin
				arrrekonline.list[i].saldo := CurrencyConvert('IDR',(CurrencyConvert(arrrekonline.list[i].uang,arrrekonline.list[i].saldo,'IDR')+jumlah),arrrekonline.list[i].uang);
			end else
				arrrekonline.list[i].saldo := arrrekonline.list[i].saldo + jumlah;
			end;
			writeln('> Saldo rekening ',jenis,' anda bertambah menjadi ',arrrekonline.list[i].saldo);
		end else
			writeln('> Saldo anda kurang atau rekening anda belum jatuh tempo. Penutupan dibatalkan');
	end else
		writeln('> Anda tidak mempunyai ',jenis,'.');
end;
end.
		
