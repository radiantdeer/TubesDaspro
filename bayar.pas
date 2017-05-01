unit bayar;
uses sysutils,banktype;
interface
	procedure bayar();
implementation
	procedure bayar ();
	var
		noakun,pil,nobayar:string;
		i,i1,i2,jt:integer;{jt=jenis transaksi}
		harini,s1:string;
		ang,sel:integer;
		bayartotal,jumbayar:real;{jumbayar yg ori, bayartotal yg abis ada denda dan kurs}
		denda,tukar:booleasn; {denda true=klo >tgl15, tukar=true klo di rekonline bkn IDR dan di pembayaran pake IDR}
	begin
		if (SudahJatuhTempo(arrrekonline)=true) then
		begin {klo udh jatuh tempo baru bisa melakukan pembayaran}
					writeln ('Pilih Jenis Pembayaran');
					writeln('	1. Listrik');{ada batas tgl 15}
					writeln('	2. BPJS');
					writeln('	3. PDAM');{ada batas tgl 15}
					writeln('	4. Telepon');{ada batas tgl 15}
					writeln('	5. TV Kabel');{ada batas tgl 15}
					writeln('	6. Kartu Kredit');
					writeln('	7. Pajak');
					writeln('	8. Pendidikan');
					writeln('	9. Internet');{ada batas tgl 15}
					writeln('	10. Transaksi Lain');
					write ('Jenis Transaksi Pembayaran : ');
					readln(jt);
					case jt of
						1 : pil :='Listrik';
						2 : pil := 'BPJS';
						3 : pil := 'PDAM';
						4 : pil := 'Telepon';
						5 : pil := 'TV Kabel';
						6 : pil := 'Kartu Kredit';
						7 : pil := 'Pajak';
						8 : pil := 'Pendidikan'
						else begin
							Write ('Jenis Transaksi : ');
							readln(pil);
						end;
					end;
					write('Nomor Pembayaran : ');
					readln(nobayar);
					harini:=FormatDateTime('DD-MM-YYYY',Now);//now bwt nentuin udh lewat tgl 15 ato blum
					s1:=gettgl(harini);//dapet tgl brp
					val(s1,ang);//ang jadi variabel integer hasil konversi dari s1
					sel:=ang-15;//selisih hari stlh lewat tgl 15
					if((jt=1) or(jt=3) or(jt=4) or(jt=5) or(jt=9)) and (ang>15) then //ada kriteria yg lebih tgl 15 kena denda
					begin{pengecekan kena denda ato ga}
						denda:=true;
					end else begin
						denda:=false;
					end;
					writeln('Masukkan Jumlah yang ingin dibayar');
					readln(jumbayar);
					{bagian ini cuma bwt cari kurs di rekonline}
					for i:=1 to arrrekonline.Neff do
					begin
						if(currentuser.nonasabah=arrrekonline.list[i].nonasabah) then
						begin
							if((arrrekonline.list[i].uang)<>'IDR') then
							begin
								tukar:=true; //hrs dikonversi klo bkn IDR
							end else begin
								tukar:=false; //ga perlu dikonversi klo IDR
							end;
						end;
					end;
					{cari kurs selese}
					if(denda=true) and(tukar=true) then
					begin{kena denda dan beda kurs}
						bayartotal:= CurrencyConvert('IDR',(jumbayar + 10000*sel),(arrrekonline.list[i].uang));
					end else if(denda=true) and (tukar=false) then
					begin{kena denda tapi kurs sama}
						bayartotal:= jumbayar + 10000*sel;
					end else if(denda=false) and (tukar=true) then
					begin{ga kena denda dan beda kurs}
						bayartotal:=
					end else begin {ga kena denda dan kurs sama}
					
					end;
					
					//lanjutin di sini
		end else begin
			Writeln('Waktu Batas Pengambilan Belum Lewat, Transaksi Gagal');
		end;
	end;
end.