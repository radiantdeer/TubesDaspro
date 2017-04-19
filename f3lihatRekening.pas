//dicky
//menampilkan daftar rekening online
program f3lihatrek;
uses banktype;
var
	nodicari:string;//nomor nasabah yg dicari
	found:=boolean;
	opsirek:string;

	function caritab ()
procedure lihatdatarek (pass:string, arrnasabah:lnasabah);
// dari lnasabah, pass pake dari login
begin
	found:=false;
	i:=1;
	while (found=false) and (i<=Neff) do
	begin
		if(pass=(arrnasabah.list[i].pass)) then //variabel pass asalnya dari password pass login
		begin
			found:=true;
		end else
		begin
			i:=i+1;
		end;
	end;
	if(found:=true) then
	begin
		writeln('> Informasi Data Diri Rekening Online Milik Anda:');
		writeln(arrnasabah.list[i].nonasabah);
		writeln(arrnasabah.list[i].nama);
		writeln(arrnasabah.list[i].alamat);
		writeln(arrnasabah.list[i].kota);
		writeln(arrnasabah.list[i].email);
		writeln(arrnasabah.list[i].telp);
		writeln(arrnasabah.list[i].user);
		writeln(arrnasabah.list[i].pass);
		writeln(arrnasabah.list[i].stat);
	end;
end;

//procedure yg f4 di bawah blum selesai, jgn dicompile dulu, mau ambis fisika dulu
procedure lihatinfosaldo(pass:string, Tab1:lnasabah, Tab2:lrekonline);
begin
	writeln('> informasiSaldo');
	writeln('> Pilih jenis rekening:');
	writeln('> 1. Deposito');
	writeln('> 2. Tabungan Rencana');
	writeln('> 3. Tabungan Mandiri');
	write('> Jenis rekening: ');
	readln(opsirek);
	writeln('> Pilih rekening ',opsirek,' Anda: ');
	writeln('> 1.');
	readln(nodicari);
	
	
	if(found:=true) then
	begin
	nodicari:=//nodicari asalnya dari nonasabah[i] dari [i] yg dicari pake password
	hitungrekonline:=0;
		for i:=1 to Neff do
		begin
			if(nodicari=(Tab2.list[i].nonasabah)) then
			begin
			//bandingin nonasabah di tabnasabah & tabrekonline
				hitungrekonline:=hitungrekonline+1;
				writeln('> Informasi rekekning online ',hitungrekonline,' anda :');
				writeln(Tab2.list[i].noakun);
				writeln(Tab2.list[i].nonasabah);
				writeln(Tab2.list[i].jenis);
				writeln(Tab2.list[i].uang);
				writeln(Tab2.list[i].saldo);
				writeln(Tab2.list[i].setrutin);
				writeln(Tab2.list[i].autodebet);
				writeln(Tab2.list[i].waktu);
				writeln(Tab2.list[i].tglmulai);
			end;
			writeln;
		end;
		writeln;
		writeln('anda memiliki ',hitungrekonline,' jumlah rekening');
	end;
end;

begin
	
end.
