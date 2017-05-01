unit uadminnasabah;
{ Unit ini menampung berbagai subprogram berkaitan dengan nasabah (buat, edit, hapus, dkk.) }

interface
	uses banktype;

	procedure editnasabah();
	{ Mengubah berbagai data yang diinginkan oleh pengguna }

implementation

	procedure editnasabah();
	var
		pilih 			: integer;
		data 			: string;

	begin
		writeln('> 1. Nama Nasabah');
		writeln('> 2. Alamat');
		writeln('> 3. Kota');
		writeln('> 4. Email');
		writeln('> 5. No Telp');
		writeln('> 6. Password');
		repeat
			write('> Pilih menu yang akan diganti : ');
			readln(pilih);
			if(NOT((pilih > 0) AND (pilih <= 6))) then writeln('> Pilihan salah! Coba lagi!');
		until((pilih > 0) AND (pilih <= 6));
		write('> Silakan masukkan data yang baru : ');
		readln(data);
		case pilih of
			1 : currentuser.nama := data;
			2 : currentuser.alamat := data;
			3 : currentuser.kota := data;
			4 : currentuser.email := data;
			5 : currentuser.telp := data;
			6 : currentuser.pass := data;
		end;
		writeln('> Data anda telah diupdate. ');
	end;

end.