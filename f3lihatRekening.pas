//dicky
//menampilkan daftar rekening online
unit f3f4f5;
interface

	uses banktype;
	uses ulogin;
	uses utanggal;
	var
		found:boolean;
	procedure lihatdatarek (user, pass : string; T : lnasabah);
		// IS: sudah login, adafungsi login yg hasilin output i
		// FS: tampilkan info rekening online nasabah dari lnasabah
	function carirekonline (noakun:string):integer;
		//IS: harus sudah validasi login di tempat lain dulu sebelum panggil fungsi ini
		//    dan pastikan found tdk mungkin false
		//FS: output indeks dmn orang dgn noakun xxx berada di arrrekonline
	procedure isrekada (jenistab:string);
		// IS: login ada output bernilai i
		// FS: menampilkan pilihan noakun pada sebuah jenis tabungan
	procedure infosaldo(user, pass : string; T : lnasabah; var pilrek:integer; var noakun:string);
		//IS : sudah login
		//FS: menampilkan info saldo currentuser ssuai pilihan
	
implementation

	procedure lihatdatarek (user, pass : string; T : lnasabah);
	var
		hitungrekonline:integer;
	begin
		if(login(user, pass : string; T : lnasabah)>0) and (login(user, pass : string; T : lnasabah)=i)then
		begin
			hitungrekonline:=0;
				for i:=1 to Neff do
				begin
					if((currentuser.nonasabah)=(arrrekonline.list[i].nonasabah)) then
					begin
						hitungrekonline:=hitungrekonline+1;
						writeln('> Informasi Rekening Online ',hitungrekonline,' anda :');
							writeln('> ',arrrekonline.list[i].noakun);
							writeln('> ',arrrekonline.list[i].nonasabah);
							writeln('> ',arrrekonline.list[i].jenis);
							writeln('> ',arrrekonline.list[i].uang);
							writeln('> ',arrrekonline.list[i].saldo);
							writeln('> ',arrrekonline.list[i].setrutin);
							writeln('> ',arrrekonline.list[i].autodebet);
							writeln('> ',arrrekonline.list[i].waktu);
							writeln('> ',arrrekonline.list[i].tglmulai);
							writeln;
					end;
				end;
				writeln('Anda Memiliki ',hitungrekonline,' jumlah rekening');
		end else
		begin
			writeln('> silakan login terlebih dahulu');
		end;
	end;
	function carirekonline (noakun:string):integer;
	begin
		found:=false;
		i:=1;
		while (i<=Neff) and (found=false) do
		begin
			if(noakun=(arrrekonline.list[i].noakun)) then
			begin
				carirekonline:=i;
			end else
			begin
				i:=i+1;
			end;
		end;
	end;
	procedure isrekada (jenistab:string);
	begin
		for i:=1 to Neff do
		begin
			if((currentuser.nonasabah)=(arrrekonline.list[i].nonasabah)) then
			begin
				if((arrrekonline.list[i].nonasabah)=jenistab) then
				begin
					writeln('> Pilih rekening ',jenistab,' Anda: ');
					write('> ',arrrekonline.list[i].noakun);
				end else
				begin
					writeln('> Anda tidak mempunyai ',jenistab);
				end;
			end;
		end;
	end;
	procedure infosaldo(user, pass : string; T : lnasabah; var pilrek:integer; var noakun:string);
	var
		inaktif:integer;
	begin
		if(login(user, pass : string; T : lnasabah)>0) and (login(user, pass : string; T : lnasabah)=i)then
		begin
			writeln('> informasiSaldo');
			writeln('> Pilih jenis rekening:');
			writeln('> 1. Deposito');
			writeln('> 2. Tabungan Rencana');
			writeln('> 3. Tabungan Mandiri');
			write('> Jenis rekening: ');
			readln(pilrek);
				if(pilrek=1) then
				begin
					isrekada('deposito');
				end else if(pilrek=2) then
				begin
					isrekada('tabungan rencana');
				end else if(pilrek=3) then
				begin
					isrekada('tabungan mandiri');
				end else
				begin
					repeat
						writeln('Harap masukkan pilihan opsi yang tersedia')
						readln(pilrek);
					until((pilrek>=1) and (pilrek<=3));//validasi, akan diulang sampai input angka benar
				end;
			readln(noakun);
			inaktif:=carirekonline(noakun);
			writeln('> Nomor rekening : ',noakun);
			writeln('> Tanggal Mulai : ',arrrekonline.list[inaktif].tglmulai);
			writeln('> Mata Uang : ',arrrekonline.list[inaktif].uang);
			writeln('> Jangka Waktu : ',arrrekonline.list[inaktif].waktu);
			writeln('> Setoran Rutin : ',arrrekonline.list[inaktif].setrutin);
			writeln('> Saldo : ',arrrekonline.list[inaktif].saldo);
			writeln('> ');
		end else
		begin
			writeln('> silakan login terlebih dahulu');
		end;
	end;
	procedure lihattransaksi ();
	var
		
	begin
		if(login(user, pass : string; T : lnasabah)>0) and (login(user, pass : string; T : lnasabah)=i)then
		begin
			
		end else
		begin
			writeln('> silakan login terlebih dahulu');
		end;
	end;
end.