program pembelian;
{Program untuk melakukan transaksi pembelian}
uses sysutils,banktype,dateutils;

{Kamus Global}
var
	listbrg 		: lbarang;      //type barang yang dibeli     
	pil 			: integer;		//variabel pilih menu
	listpembelian 	: lpembelian;	//type histori pembelian
	arrrekonline 	: lrekonline;	//type rekening online
	listkurs 		: lkurs;		//type kurs yang dipakai
	currentuser 	: nasabah;		//data nasabah

{Deklarasi dan Spesifikasi Fungsi}
function SudahJatuhTempo (rekonline : rekonline;jenis : string) : boolean;
{ Menghasilkan true jika telah memenuhi waktu jatuh tempo dan false jika
  belum memenuhi waktu jatuh tempo }
{ Waktu jatuh tempo dihitung dari tanggal pembuatan rekening ke jangka 
  waktu yang ditentukan untuk rekening tersebut }

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
	cmd:=CompareDate(jatuhTempo,Now);					//membandingkan tanggal setelah di increment dengan waktu sekarang
	SudahJatuhTempo:=cmd<=0;							
end;

function gantikurs (awal : string; akhir : string;saldo : real) : real;
{Mengganti kurs dari kurs awal ke kurs akhir dengan skala yang telah ditentukan}

{Kamus Lokal}
var
	found 	: boolean;
	temp 	: real;
	i 		: integer;
	
{Algoritma Fungsi}
begin
	found := false;
	i := 0;
	while not(found) do				//Pencarian tabel kurs yang tepat
	begin	
		i := i +1;
		if (akhir = listkurs.list[i].awal) and (akhir = listkurs.list[i].akhir) then
		begin
			found := true;
			temp := saldo * listkurs.list[i].nakhir / listkurs.list[i].nawal;
		end;
	end;
	gantikurs := temp;
end;

procedure beli(harga : real;arr : integer;nomor : string);
{Prosedur untuk membeli sesuatu dan mengurangkan saldo dengan harga barang}

{Kamus Lokal}
var
	jenisRek : integer;
	stop,success : boolean;
	jenis : string;
	i : integer;
	tempArray : array [1..50] of string;
	ganti : real;
	N : integer;
	noAk : string;
	found : boolean;

{Algoritma Prosedur}
begin
	writeln('> Pilih jenis rekening');
	writeln('> 1. Deposito');
	writeln('> 2. Tabungan rencana');
	writeln('> 3. Tabungan mandiri');
	//Validasi masukan jenis rekening 
	//Pengulangan akan berhenti jika pengguna memasukkan jenis rekening yang tepat, yaitu 1, 2, atau 3
	stop:=false;
	repeat
		write('> Jenis rekening : ');
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
			ganti := gantikurs(arrrekonline.list[i].uang,'IDR',arrrekonline.list[i].saldo);
			if (jenis='tabungan mandiri') and (arrrekonline.list[i].saldo>=ganti) then
			begin
				arrrekonline.list[i].saldo:=gantikurs('IDR',arrrekonline.list[i].uang,(arrrekonline.list[i].saldo-ganti));
				success:=true;
			end else if ((jenis='deposito') or (jenis='tabungan rencana')) and (arrrekonline.list[i].saldo>=harga) and (SudahJatuhTempo(arrrekonline.list[i],jenis)) then 
			begin
				arrrekonline.list[i].saldo:=gantikurs('IDR',arrrekonline.list[i].uang,(arrrekonline.list[i].saldo-ganti));
				success:=true;
			end else
				success:=false;
		end else
		begin
			if (jenis='tabungan mandiri') and (arrrekonline.list[i].saldo>=harga) then
			begin
				arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-harga;
				success:=true;
			end else if ((jenis='deposito') or (jenis='tabungan rencana')) and (arrrekonline.list[i].saldo>=harga) and (SudahJatuhTempo(arrrekonline.list[i],jenis)) then 
			begin
				arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-harga;
				success:=true;
			end else
				success:=false;
		end;
			if (success=true) then
			begin
				listpembelian.Neff:=arrrekonline.Neff+1;
				listpembelian.list[listpembelian.Neff].noakun:=arrrekonline.list[i].noakun;
				listpembelian.list[listpembelian.Neff].jenis:=listbrg.list[arr].jenis;
				listpembelian.list[listpembelian.Neff].penyedia:=listbrg.list[arr].penyedia;
				listpembelian.list[listpembelian.Neff].nomortujuan:=nomor;
				listpembelian.list[listpembelian.Neff].uang:=arrrekonline.list[i].uang;
				listpembelian.list[listpembelian.Neff].jumlah:=harga;
				listpembelian.list[listpembelian.Neff].saldoakhir:= arrrekonline.list[i].saldo;
				listpembelian.list[listpembelian.Neff].tgl:=FormatDateTime('DD-MM-YYYY',Now);
				writeln('> Pembelian Berhasil ! Jumlah saldo Anda adalah ',arrrekonline.list[i].saldo:0:0);
			end else
			begin
				writeln('> Anda tidak dapat melakukan pembelian.')
			end;
	end else
	begin
		writeln('> Anda tidak mempunyai ',jenis,'.');
	end;
end;

procedure menu;
{Prosedur menampilkan main menu pembelian}

{Kamus Lokal}
var
	i : integer;
	nomor : string;

{Algoritma Prosedur}
begin
	for i := 1 to listbrg.neff do
		begin
			writeln('> ',i,'. ',listbrg.list[i].jenis, ' | ',listbrg.list[i].penyedia, ' | ',listbrg.list[i].harga:0:0);     //Menampilkan barang yang tersedia
		end;
		repeat
			writeln('> Masukkan pilihan anda : ');
			write('> ');
			readln(pil);
			if (pil <1) and (pil >listbrg.neff) then
				writeln('> Pilihan tidak valid. Silakan coba lagi');
	until (pil >=1) and (pil <= listbrg.neff);
	writeln('> Masukkan nomor tujuan :');
	write('> ');
	readln(nomor);
	beli(listbrg.list[pil].harga,pil,nomor);
end;

{ALGORITMA UTAMA}
begin
	menu;
end.