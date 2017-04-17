//ujicoba
program ujicoba;

var
  n : integer;

begin
  readln(n);
  repeat
    if (n=1) then
      write('UDAH SATU')
    else if (n=2) then
      write('UDAH DUA')
    else 
    if (n=3) then
      write('UDAH TIGA')
    else
      write('COBA LAGI')
  until (n = 1 or 2 or 3);
  write(n);
end.
      