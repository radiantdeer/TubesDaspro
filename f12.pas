program progpembelian;
uses banktype;

var
	listbrg : lbarang;
	i : integer;
	pil : integer;
	neff : integer;
	listpembayaran : lpembelian;
	rekening : rekonline;
	
procedure menu(listbrg : lbarang;var pil : integer);
var
	i : integer;
	m : integer;
begin
	for i := 1 to listbrg.neff do
	begin
		writeln(i,'. ',listbrg.list[i].jenis, ' | ',listbrg.list[i].penyedia, ' | ',listbrg.list[i].harga:0:0);
	end;
	m := listbrg.neff;
	writeln(m+1,'. Lihat Histori Pembelian');
	writeln(m+2,'. Kembali ke menu utama');
	repeat
		writeln('Masukkan pilihan anda : ');
		write('> ');
		readln(pil);
		if (pil <1) and (pil >m+2) then
			writeln('Pilihan tidak valid. Silakan coba lagi');
	until (pil >0) and (pil < m+3);
end;

procedure pilihmenu(pil : integer; var nomor : string;var listbrg : lbarang);
var
	i,m : integer;
begin
	writeln('Masukkan nomor tujuan :');
	write('> ');
	readln(nomor);
	m := listbrg.neff;
	case pil of
			1 : prosesuang(listbrg.list[1],rekening);
			2 : prosesuang(listbrg.list[2],rekening);
			3 : prosesuang(listbrg.list[3],rekening);
			4 : prosesuang(listbrg.list[4],rekening);
			5 : prosesuang(listbrg.list[5],rekening);
			6 : prosesuang(listbrg.list[6],rekening);
			7 : prosesuang(listbrg.list[7],rekening);
			8 : prosesuang(listbrg.list[8],rekening);
			9 : prosesuang(listbrg.list[9],rekening);
			10 : prosesuang(listbrg.list[10],rekening);
			{(m+1) : historipembelian;
			(m+2) : menuutama;}
	end;	
end;

procedure prosesuang (list : barang; var rekening : rekonline);

begin
	if(list.harga > rekening.saldo) then
	begin
		writeln('Maaf Uang tidak cukup');
	end else
		rekening.saldo := rekening.saldo - list.harga;
	
end;	
{ALGORITMA UTAMA}
begin
	repeat
		menu(listbrg,pil);
		pilihmenu(pil,nomor,listbrg);
	until (pilihmenu(12,nomor,listbrg));
	
end.
	