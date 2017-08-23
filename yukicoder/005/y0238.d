import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto i = sameIndex(s);
  auto t = s[i..$-i];

  if (t.empty) {
    writeln(s[0..i] ~ 'a' ~ s[i..$]);
    return;
  }

  if (isKaibun(t[$-1] ~ t)) {
    writeln(s[0..i] ~ t[$-1] ~ t ~ s[$-i..$]);
    return;
  }

  if (isKaibun(t ~ t[0])) {
    writeln(s[0..i] ~ t ~ t[0] ~ s[$-i..$]);
    return;
  }

  writeln("NA");
}

auto sameIndex(string s)
{
  foreach (i; 0..s.length/2)
    if (s[i] != s[$-i-1]) return i;
  return s.length/2;
}

auto isKaibun(string s)
{
  foreach (i; 0..s.length/2)
    if (s[i] != s[$-i-1]) return false;
  return true;
}
