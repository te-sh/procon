import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto r = size_t(0);
  foreach (i; 0..s.length)
    foreach (j; i..s.length)
      if (j-i+1 != s.length && isKaibun(s[i..j+1]))
        r = max(r, j-i+1);
  writeln(r);
}

auto isKaibun(string s)
{
  foreach (i; 0..s.length/2)
    if (s[i] != s[$-i-1]) return false;
  return true;
}
