//dicky
//menampilkan daftar rekening online
unit ulihatrek;

interface
	uses banktype,sysutils;
	var
		i,Neff,pilrek:integer;
		noak,noakun:string;
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
	function datetoint(d, m, y: string): integer;
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
				writeln('Informasi Rekening Online ',hitungrekonline,' anda :');
					writeln(arrrekonline.list[i].noakun);
					writeln(arrrekonline.list[i].nonasabah);
					writeln(arrrekonline.list[i].jenis);
					writeln(arrrekonline.list[i].uang);
					writeln(arrrekonline.list[i].saldo:0:2);
					writeln(arrrekonline.list[i].setrutin:0:2);
					writeln(arrrekonline.list[i].autodebet);
					writeln(arrrekonline.list[i].waktu);
					writeln(arrrekonline.list[i].tglmulai);
					writeln;
			end;
		end;
		writeln('Anda Memiliki ',hitungrekonline,' buah rekening');
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
				carirekonline:=i;
			end else
			begin
				i:=i+1;
			end;
		end;
		if(found=false) then
		begin
			carirekonline:=0;
		end;
	end;
	procedure isrekada (jenistab:string);
	var
		found:boolean;
	begin
		found:=false;
		for i:=1 to (arrrekonline.Neff) do
		begin
			if((arrrekonline.list[i].jenis)=jenistab) then
			begin
				found:=true;
				writeln('Pilih rekening ',jenistab,' Anda: ');
				writeln(arrrekonline.list[i].noakun);
				writeln('Rekening ',jenistab,' :');
			end;
		end;
		if(found=false) then
		begin
			writeln('Anda tidak mempunyai ',jenistab);
		end;
	end;
	procedure infosaldo();
	var
		inaktif:integer;
	begin
		writeln('Pilih jenis rekening:');
		writeln('1. Deposito');
		writeln('2. Tabungan Rencana');
		writeln('3. Tabungan Mandiri');
		write('Jenis rekening: ');
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
			end;
		readln(noakun);
		noak:=noakun;//testing bwt lihattransaksi
		inaktif:=carirekonline(noakun);
		writeln;
		writeln('Informasi Rekening Online Anda');
		writeln('Nomor rekening : ',noakun);
		writeln('Tanggal Mulai : ',arrrekonline.list[inaktif].tglmulai);
		writeln('Mata Uang : ',arrrekonline.list[inaktif].uang);
		writeln('Jangka Waktu : ',arrrekonline.list[inaktif].waktu);
		writeln('Setoran Rutin : ',arrrekonline.list[inaktif].setrutin:0:2);
		writeln('Saldo : ',arrrekonline.list[inaktif].saldo:0:2);
		writeln();
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

	function datetoint(d, m, y: string): integer;
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
		s1:=gettgl(tanggal1);
		s2:=getbln(tanggal1);
		s3:=getthn(tanggal1);
		for i:=1 to arrnasabah.Neff do
		begin
			if((currentuser.nonasabah)=(arrrekonline.list[i].nonasabah)) then
			begin
				for i1:=1 to (arrtransaksi.Neff) do
				begin
					if((arrrekonline.list[i].noakun)=(arrtransaksi.list[i1].noakun)) then
					begin
						tanggal2:=arrtransaksi.list[i1].tgl;
						s4:=gettgl(tanggal2);
						s5:=getbln(tanggal2);
						s6:=getthn(tanggal2);
						selhari1:=(datetoint(s1,s2,s3))-(datetoint(s4,s5,s6));
							if(selhari1>=1) and(selhari1<=90) then
							begin
								writeln('Histori Transaksi Setoran/Penarikan Anda ');
								writeln('Tanggal Transaksi : ',arrtransaksi.list[i1].tgl);
								writeln('Jenis Transaksi : ',arrtransaksi.list[i1].jenis);
								writeln('Mata Uang Yang Digunakan : ',arrtransaksi.list[i1].uang);
								writeln('Jumlah Uang : ',arrtransaksi.list[i1].jumlah:0:2);
								writeln('Saldo Rekening Anda Setelah Transaksi Ini : ',arrtransaksi.list[i1].saldoakhir:0:2);
							end;
					end;
				end;

			end;
		end;
		writeln;
		for i:=1 to arrnasabah.Neff do
		begin
			if((currentuser.nonasabah)=(arrrekonline.list[i].nonasabah)) then
			begin
				for i2:=1 to (arrtransfer.Neff) do
				begin
					if((arrrekonline.list[i].noakun)=(arrtransfer.list[i2].asal)) then
					begin
						tanggal3:=arrtransfer.list[i2].tgl;
						s7:=gettgl(tanggal3);
						s8:=getbln(tanggal3);
						s9:=getthn(tanggal3);
						selhari2:=(datetoint(s1,s2,s3))-(datetoint(s7,s8,s9));
							if(selhari2>=1) and(selhari2<=90) then
							begin
								writeln('Histori Transaksi Transfer Rekening Anda ');
								writeln('Tanggal Transaksi Transfer: ',arrtransfer.list[i2].tgl);
								writeln('Rekening Asal Transfer : ',arrtransfer.list[i2].asal);
								writeln('Rekening Tujuan Transfer : ',arrtransfer.list[i2].tujuan);
								writeln('Jenis Transaksi Transfer : ',arrtransfer.list[i2].jenis);
								writeln('Nama Bank Luar (Jika Ada) :',arrtransfer.list[i2].bank);
								writeln('Mata Uang Yang Digunakan : ',arrtransfer.list[i2].uang);
								writeln('Jumlah Uang Yang Ditransfer : ',arrtransfer.list[i2].jumlah:0:2);
								writeln('Saldo Rekening Anda Setelah Transaksi Ini : ',arrtransfer.list[i2].saldoakhir:0:2);
							end;
					end;
				end;
			end;
		end;
		writeln;
		for i:=1 to arrnasabah.Neff do
		begin
			if((currentuser.nonasabah)=(arrrekonline.list[i].nonasabah)) then
			begin
				for i3:=1 to (arrbayar.Neff) do
				begin
					if((arrrekonline.list[i].noakun)=(arrbayar.list[i3].noakun)) then
					begin
						tanggal4:=arrbayar.list[i3].tgl;
						s10:=gettgl(tanggal4);
						s11:=getbln(tanggal4);
						s12:=getthn(tanggal4);
						selhari3:=(datetoint(s1,s2,s3))-(datetoint(s10,s11,s12));
							if(selhari3>=1) and(selhari3<=90) then
							begin
								writeln('Histori Transaksi Pembayaran Anda ');
								writeln('Tanggal Transaksi Pembayaran Anda : ',arrbayar.list[i3].tgl);
								writeln('Jenis Transaksi Pembayaran Anda : ',arrbayar.list[i3].jenis);
								writeln('Nomor Pembayaran Transaksi Pembayaran Anda : ',arrbayar.list[i3].nomorbayar);
								writeln('Mata Uang Yang Digunakan : ',arrbayar.list[i3].uang);
								writeln('Jumlah Transaksi Pembayaran Anda : ',arrbayar.list[i3].jumlah:0:2);
								writeln('Saldo Rekening Anda Setelah Transaksi Ini : ',arrbayar.list[i3].saldoakhir:0:2);
							end;
					end;
				end;

			end;
		end;
		writeln;
		for i:=1 to arrnasabah.Neff do
		begin
			if((currentuser.nonasabah)=(arrrekonline.list[i].nonasabah)) then
			begin
				for i4:=1 to (arrbeli.Neff) do
				begin
					if ((arrrekonline.list[i].noakun)=(arrbeli.list[i4].noakun)) then
					begin
						tanggal5:=arrbeli.list[i4].tgl;
						s13:=gettgl(tanggal5);
						s14:=getbln(tanggal5);
						s15:=getthn(tanggal5);
						selhari4:=(datetoint(s1,s2,s3))-(datetoint(s13,s14,s15));
							if(selhari4>=1) and(selhari4<=90) then
							begin
								writeln('Histori Transaksi Pembelian Anda ');
								writeln('Tanggal Transaksi Pembelian Anda : ',arrbeli.list[i4].tgl);
								writeln('Jenis barang yang Dibeli : ',arrbeli.list[i4].jenis);
								writeln('Penyedia Jasa : ',arrbeli.list[i4].penyedia);
								writeln('Nomor Tujuan Pembelian Anda : ',arrbeli.list[i4].nomortujuan);
								writeln('Mata Uang Yang Digunakan : ',arrbeli.list[i4].uang);
								writeln('Jumlah Transaksi Pembelian Anda : ',arrbeli.list[i4].jumlah:0:2);
								writeln('Saldo Rekening Anda Setelah Transaksi Ini : ',arrbeli.list[i4].saldoakhir:0:2);
							end;
					end;
				end;

			end;
		end;
		writeln;
	end;
end.
