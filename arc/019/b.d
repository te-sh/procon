import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp, n = s.length;
  auto r = 0;
  foreach (i; 0..n/2) r += s[i] != s[$-1-i];

  if      (r == 0) writeln(n % 2 ? 25*(n-1) : 25*n);
  else if (r >= 2) writeln(25*n);
  else             writeln(25*(n-2)+24*2);
}
