program perubahan;
{Program untuk merubah data nasabah}
uses banktype;

{Kamus}
var
	currentuser 	: nasabah;
	pilih 			: integer;
	data 			: string;

{Deklarasi dan Spesifikasi Prosedur}}
procedure menu;
{Program untuk menjalankan menu}

{Algoritma Prosedur}
begin
	writeln('> 1. Nama Nasabah');
	writeln('> 2. Alamat');
	writeln('> 3. Kota');
	writeln('> 4. Email');
	writeln('> 5. No Telp');
	writeln('> 6. Password');
	write('> Pilih menu yang akan diganti : ');
	readln(pilih);
	write('> SIlakan masukkan data yang baru : ');
	readln(data);
	case pilih of
		1 : currentuser.nama := data;
		2 : currentuser.alamat := data;
		3 : currentuser.kota := data;
		4 : currentuser.email := data;
		5 : currentuser.telp := data;
		6 : currentuser.pass := data;
	end;
	writeln('> Terimakasih. Data anda telah diupdate. ');
end;

{Algoritma}
begin
	menu;
end.