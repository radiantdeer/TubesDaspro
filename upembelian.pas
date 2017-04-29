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
	
procedure menu;
var
	i : integer;
	m : integer;
begin
	repeat
		for i := 1 to listbrg.neff do
		begin
			writeln('> ',i,'. ',listbrg.list[i].jenis, ' | ',listbrg.list[i].penyedia, ' | ',listbrg.list[i].harga:0:0);
		end;
		m := listbrg.neff;
		writeln('> ',11,'. Lihat Histori Pembelian');
		writeln('> ',12,'. Kembali ke menu utama');
		repeat
			writeln('> Masukkan pilihan anda : ');
			write('> ');
			readln(pil);
			if (pil <1) and (pil >12) then
				writeln('> Pilihan tidak valid. Silakan coba lagi');
		until (pil >0) and (pil < 13);
		pilihmenu(pil);
	until(pil = 12);
	
end;

procedure pilihmenu(pil : integer);
var
	nomor : string;
begin
	writeln('> Masukkan nomor tujuan :');
	write('> ');
	readln(nomor);
	case pil of
			1 : bayar(listbrg.list[1].harga,1,nomor);
			2 : bayar(listbrg.list[2].harga,2,nomor);
			3 : bayar(listbrg.list[3].harga,3,nomor);
			4 : bayar(listbrg.list[4].harga,4,nomor);
			5 : bayar(listbrg.list[5].harga,5,nomor);
			6 : bayar(listbrg.list[6].harga,6,nomor);
			7 : bayar(listbrg.list[7].harga,7,nomor);
			8 : bayar(listbrg.list[8].harga,8,nomor);
			9 : bayar(listbrg.list[9].harga,9,nomor);
			10 : bayar(listbrg.list[10].harga,10,nomor);
			11 : historipembelian;
			12 : menuutama;
	end;	
end;


procedure bayar(harga : real,arr : integer);
var
	jenisRek : integer;
	stop,success : boolean;
	jenis : string;
	i : integer;
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
			stop:=true
		else
			writeln('> Jenis rekening yang Anda masukkan salah!');
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
				found:=true
			else
				i:=i+1;
		end;
		
		if (jenis='tabungan mandiri') and (arrrekonline.list[i].saldo>=harga) then
		begin
			arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-harga;
			success:=true;
		end else if (jenis='deposito') or (jenis='tabungan rencana') and (arrrekonline.list[i].saldo>=saldo) then //Ubah di sini
		begin
			arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-harga;
			success:=true;
		end else
			success:=false;
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
			listpembelian.list[listpembelian.Neff].tgl:=DateTimeToStr(Now);
			writeln('> Pembelian Berhasil ! Jumlah saldo Anda adalah ',arrrekonline.list[i].saldo);
		end else
			writeln('> Anda tidak dapat melakukan pembelian.');
	end else
		writeln('> Anda tidak mempunyai ',jenis,'.');
end;
{ALGORITMA UTAMA}
begin
	repeat
		menu(listbrg,pil);
		pilihmenu(pil,nomor,listbrg);
	until (pilihmenu(12,nomor,listbrg));
	
end.
	