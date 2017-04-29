//dicky
//menampilkan daftar rekening online
unit ulihatrek;

interface
	uses banktype,sysutils;
	var
		i,Neff,pilrek:integer;
		noak:string;
	procedure lihatdatarek ();
		// IS: sudah login, adafungsi login yg hasilin output i
		// FS: tampilkan info rekening online nasabah dari lnasabah
	function carirekonline (noakun:string):integer;
		//IS: harus sudah validasi login di tempat lain dulu sebelum panggil fungsi ini
		//FS: output indeks dmn orang dgn noakun xxx berada di arrrekonline
		//    klo found = true maka indeks=i , klo found = false maka indeks=0
	procedure isrekada (jenistab:string);
		// IS: login ada output bernilai i
		// FS: menampilkan pilihan noakun pada sebuah jenis tabungan
	procedure infosaldo();
		//IS : sudah login
		//FS: menampilkan info saldo currentuser ssuai pilihan
	function today (Fmt : string):string;
		//IS: ada sysutils
		//FS: menghasilkan string dari date today di sysutils
	function gettgl (var S:string):string;
		//IS: ada tanggal, misal 21-12-2016
		//FS: dapet string 21
	function getbln (var S:string):string;
		//IS: ada tanggal, misal 21-12-2016
		//FS: dapet string 12
	function getthn (var S:string):string;
		//IS: ada tanggal, misal 21-12-2016
		//FS: dapet string 2016
	function isKabisat(yy:integer):boolean;
		//IS: ada thn, misal 2017
		//FS: tahu kabisat ato ga
	function datetoint(d, m, y: string): longint;
		//IS: masukan dari gettgl , getbln , dan getthn
		//FS: penjumlahan dari gettgl , getbln , dan getthn dlm bentuk longint
	procedure lihattransaksi ();
		//IS: sudah login, asumsi arrrekonline dgn noakun itu selalu true
		//FS: menampilkan daftar transaksi pengguna
	
implementation

	procedure lihatdatarek ();
	var
		hitungrekonline:integer;
	begin
		hitungrekonline:=0;
		for i:=1 to arrnasabah.Neff do
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
	end;
	function carirekonline (noakun:string):integer;
	var
		found:boolean;
	begin
		found:=false;
		i:=1;
		while (i<=(arrrekonline.Neff)) and (found=false) do
		begin
			if(noakun=(arrrekonline.list[i].noakun)) then
			begin
				found:=true;
			end else
			begin
				i:=i+1;
			end;
		end;
		if(found=true) then
		begin
			carirekonline:=i;
		end else
		begin
			carirekonline:=0;
		end;
	end;
	procedure isrekada (jenistab:string);
	begin
		for i:=1 to (arrrekonline.Neff) do
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
	procedure infosaldo();
	var
		inaktif:integer;
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
					writeln('Harap masukkan pilihan opsi yang tersedia');
					readln(pilrek);
				until((pilrek>=1) and (pilrek<=3));//validasi, akan diulang sampai input angka benar
			end;
		readln(noak);
		inaktif:=carirekonline(noak);
		writeln('> Nomor rekening : ',noak);
		writeln('> Tanggal Mulai : ',arrrekonline.list[inaktif].tglmulai);
		writeln('> Mata Uang : ',arrrekonline.list[inaktif].uang);
		writeln('> Jangka Waktu : ',arrrekonline.list[inaktif].waktu);
		writeln('> Setoran Rutin : ',arrrekonline.list[inaktif].setrutin);
		writeln('> Saldo : ',arrrekonline.list[inaktif].saldo);
		writeln('> ');
	end;
	
	function today (Fmt : string):string;

	Var S : AnsiString;

	begin
	  DateTimeToString (S,Fmt,Date);
	  today:=S;
	end;
	
	function gettgl (var S:string):string;
	begin
		gettgl:=copy (S,1,2);
	end;
	
	function getbln (var S:string):string;
	begin
		getbln:=copy (S,4,2);
	end;
	
	function getthn (var S:string):string;
	begin
		getthn:=copy (S,7,4);
	end;
	
	function isKabisat(yy:integer):boolean;
	begin
		isKabisat:= ((yy mod 4) = 0) and (((yy mod 100) <>0) or ((yy mod 400) = 0));
	end;

	function datetoint(d, m, y: string): longint;
	var
		sum : integer;
		i:integer;
		mm,yy : integer;
	begin
		sum:=strtoint(d);
		mm:= strtoint(m);
		yy:=strtoint(y);
		for i:=1 to mm-1 do
		begin
			if((i=1) or (i=3) or (i=5) or (i=7) or (i=8) or (i=10) or (i=12)) then
			sum:= sum+31
			else if ((i=4) or (i=6) or (i=9) or (i=11) or(i=4)) then
			sum:=sum+30
			else
			begin
			if(isKabisat(yy)) then sum:=sum+29
			else sum:=sum+28;
			end;
		end;
		datetoint:=sum;
	end;
	procedure lihattransaksi ();
	var
		tanggal1,tanggal2,tanggal3,tanggal4,tanggal5:string;
		s1,s2,s3:string;
		s4,s5,s6:string;
		s7,s8,s9:string;
		s10,s11,s12:string;
		s13,s14,s15:string;
		selhari1,selhari2,selhari3,selhari4:integer;
		i1,i2,i3,i4:integer; {pencacah}
	begin
		tanggal1:=today ('dd-mm-yyyy');
		writeln('> Masukkan nomor akun anda untuk melihat histori transaksi anda');
		readln(noak);
			for i1:=1 to (arrtransaksi.Neff) do
			begin
				if(noak=(arrtransaksi.list[i1].noakun)) then
				begin
					tanggal2:=arrtransaksi.list[i1].tgl;
					for i2:=1 to (arrtransfer.Neff) do
					begin
						if(noak=(arrtransfer.list[i2].asal)) then
						begin
							tanggal3:=arrtransfer.list[i2].tgl;
							for i3:=1 to (arrbayar.Neff) do
							begin
								if(noak=(arrbayar.list[i3].noakun)) then
								begin
									tanggal4:=arrbayar.list[i3].tgl;
									for i4:=1 to (arrbeli.Neff) do
									begin
										if(noak=(arrbeli.list[i4].noakun)) then
										begin {cek satu-satu no akun itu ada ato tidak di tiap array}
											tanggal5:=arrbeli.list[i4].tgl;
											s1:=gettgl(tanggal1);
											s2:=getbln(tanggal1);
											s3:=getthn(tanggal1);
											s4:=gettgl(tanggal2);
											s5:=getbln(tanggal2);
											s6:=getthn(tanggal2);
											s7:=gettgl(tanggal3);
											s8:=getbln(tanggal3);
											s9:=getthn(tanggal3);
											s10:=gettgl(tanggal4);
											s11:=getbln(tanggal4);
											s12:=getthn(tanggal4);
											s13:=gettgl(tanggal5);
											s14:=getbln(tanggal5);
											s15:=getthn(tanggal5);
											selhari1:=(datetoint(s1,s2,s3))-(datetoint(s4,s5,s6));
											selhari2:=(datetoint(s1,s2,s3))-(datetoint(s7,s8,s9));
											selhari3:=(datetoint(s1,s2,s3))-(datetoint(s10,s11,s12));
											selhari4:=(datetoint(s1,s2,s3))-(datetoint(s13,s14,s15));
												if(selhari1>=1) and(selhari1<=90) then
												begin
													writeln('> Histori Transaksi Setoran/Penarikan');
													writeln('> Tanggal Transaksi : ',arrtransaksi.list[i1].tgl);
													writeln('> Jenis Transaksi : ',arrtransaksi.list[i1].jenis);
													writeln('> Mata Uang Yang Digunakan : ',arrtransaksi.list[i1].uang);
													writeln('> Jumlah Uang : ',arrtransaksi.list[i1].jumlah);
													writeln('> Saldo Rekening Anda Setelah Transaksi Ini : ',arrtransaksi.list[i1].saldoakhir);
												end;
												if(selhari2>=1) and(selhari2<=90) then
												begin
													writeln('> Histori Transaksi Transfer Rekening Anda :');
													writeln('> Tanggal Transaksi Transfer: ',arrtransfer.list[i2].tgl);
													writeln('> Rekening Asal Transfer : ',arrtransfer.list[i2].asal);
													writeln('> Rekening Tujuan Transfer : ',arrtransfer.list[i2].tujuan);
													writeln('> Jenis Transaksi Transfer : ',arrtransfer.list[i2].jenis);
													writeln('> Nama Bank Luar (Jika Ada) :',arrtransfer.list[i2].bank);
													writeln('> Mata Uang Yang Digunakan : ',arrtransfer.list[i2].uang);
													writeln('> Jumlah Uang Yang Ditransfer : ',arrtransfer.list[i2].jumlah);
													writeln('> Saldo Rekening Anda Setelah Transaksi Ini : ',arrtransfer.list[i2].saldoakhir);
													
												end;
												if(selhari3>=1) and(selhari3<=90) then
												begin
													writeln('> Histori Transaksi Pembayaran Anda : ');
													writeln('> Tanggal Transaksi Pembayaran Anda : ',arrbayar.list[i3].tgl);
													writeln('> Jenis Transaksi Pembayaran Anda : ',arrbayar.list[i3].jenis);
													writeln('> Nomor Pembayaran Transaksi Pembayaran Anda : ',arrbayar.list[i3].nomorbayar);
													writeln('> Mata Uang Yang Digunakan : ',arrbayar.list[i3].uang);
													writeln('> Jumlah Transaksi Pembayaran Anda : ',arrbayar.list[i3].jumlah);
													writeln('> Saldo Rekening Anda Setelah Transaksi Ini : ',arrbayar.list[i3].saldoakhir);
												end;
												if(selhari4>=1) and(selhari4<=90) then
												begin
													writeln('> Histori Transaksi Pembelian Anda : ');
													writeln('> Tanggal Transaksi Pembelian Anda : ',arrbeli.list[i4].tgl);
													writeln('> Jenis barang yang Dibeli : ',arrbeli.list[i4].jenis);
													writeln('> Penyedia Jasa : ',arrbeli.list[i4].penyedia);
													writeln('> Nomor Tujuan Pembelian Anda : ',arrbeli.list[i4].nomortujuan);
													writeln('> Mata Uang Yang Digunakan : ',arrbeli.list[i4].uang);
													writeln('> Jumlah Transaksi Pembelian Anda : ',arrbeli.list[i4].jumlah);
													writeln('> Saldo Rekening Anda Setelah Transaksi Ini : ',arrbeli.list[i4].saldoakhir);
												end;
										end;
									end;
								end;
							end;
						end;
					end;
				end;
			end;	
	end;
end.