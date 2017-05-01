program pembelian;
{Program untuk melakukan transaksi pembelian}
uses sysutils,banktype,dateutils,utransaksi;

{Kamus Global}
var
	listbrg 		: lbarang;      //type barang yang dibeli     
	pil 			: integer;		//variabel pilih menu
	listpembelian 	: lpembelian;	//type histori pembelian
	arrrekonline 	: lrekonline;	//type rekening online
	listkurs 		: lkurs;		//type kurs yang dipakai
	currentuser 	: nasabah;		//data nasabah
	T : lkurs;
Function ConvertUang (awal, akhir : String ; Jumlah : real ) : real;
var
	i : Integer;
Begin
	i:=0;
	Repeat 
		i:= i+1
	until (arrrekonline.list[i].awal = awal) and (arrrekonline.list[i].akhir = akhir);
		ConvertUang := Jumlah*(arrrekonline.list[i].nakhir) div (arrrekonline.list[i].nawal);
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
			ganti := ConvertUang('IDR',arrrekonline.list[i].uang,harga);
			if (jenis='tabungan mandiri') and (arrrekonline.list[i].saldo>=ganti) then
			begin
				arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-ganti
				success:=true;
			end else if ((jenis='deposito') or (jenis='tabungan rencana')) and (arrrekonline.list[i].saldo>=ganti) and (SudahJatuhTempo(arrrekonline.list[i]) then 
			begin
				arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-ganti
				success:=true;
			end else
				success:=false;
		end else
		begin
			if (jenis='tabungan mandiri') and (arrrekonline.list[i].saldo>=harga) then
			begin
				arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-harga;
				success:=true;
			end else if ((jenis='deposito') or (jenis='tabungan rencana')) and (arrrekonline.list[i].saldo>=harga) and (SudahJatuhTempo(arrrekonline.list[i]) then 
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