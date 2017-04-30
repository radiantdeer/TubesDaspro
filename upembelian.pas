program progpembelian;
uses sysutils,banktype;

var
	listbrg : lbarang;
	i : integer;
	pil : integer;
	neff : integer;
	listpembelian : lpembelian;
	rekening : rekonline;
	jumlahBayar : real;
	arrrekonline : lrekonline;
	tempArray : array [1..50] of string;
	listkurs : lkurs;
	currentuser : nasabah;
	
function gantikurs (awal : string; akhir : string;saldo : real) : real;
var
	i : integer;
	found : boolean;
	temp : real;
	
begin
	found := false;
	i := 0;
	while not(found) do
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

procedure bayar(harga : real;arr : integer;nomor : string);
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
	
begin
	writeln('> Pilih jenis rekening:');
	writeln('> 1. Deposito');
	writeln('> 2. Tabungan rencana');
	writeln('> 3. Tabungan mandiri');
	stop:=false;
	
	repeat
		write('> Jenis rekening : ');
		readln(jenisRek);
		if (jenisRek=1) or (jenisRek=2) or (jenisRek=3) then
		begin
			stop:=true;
		end else
		begin
			writeln('> Jenis rekening yang Anda masukkan salah!');
		end;
	until stop;
	
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
		while (not(found)) do
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
			end else if (jenis='deposito') or (jenis='tabungan rencana') and (arrrekonline.list[i].saldo>=harga) then //Ubah di sini
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
			end else if (jenis='deposito') or (jenis='tabungan rencana') and (arrrekonline.list[i].saldo>=harga) then //Ubah di sini
			begin
				if()
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
				listpembelian.list[listpembelian.Neff].penyedia:=listbrg.list[arr].jenis;;
				listpembelian.list[listpembelian.Neff].nomortujuan:=nomor;
				listpembelian.list[listpembelian.Neff].uang:=arrrekonline.list[i].uang;
				listpembelian.list[listpembelian.Neff].jumlah:=harga;
				listpembelian.list[listpembelian.Neff].saldoakhir:= arrrekonline.list[i].saldo;
				listpembelian.list[listpembelian.Neff].tgl:=FormatDateTime('DD-MM-YYYY',Now);
				writeln('> Pembelian Berhasil ! Jumlah saldo Anda adalah ',arrrekonline.list[i].saldo);
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
var
	i : integer;
	nomor : string;
	
begin
	for i := 1 to listbrg.neff do
		begin
			writeln('> ',i,'. ',listbrg.list[i].jenis, ' | ',listbrg.list[i].penyedia, ' | ',listbrg.list[i].harga:0:0);
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
	bayar(listbrg.list[pil].harga,pil,nomor);
end;

{ALGORITMA UTAMA}
begin
	menu;
end.
	
