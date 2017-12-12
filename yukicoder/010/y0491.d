import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long, k = (n/(10^^9+1)).to!int;

  auto s = k.to!string, ns = s.length, sh = 10^^((ns+1)/2), r = 0;

  foreach (i; 1..sh) {
    auto t = i.to!string, nt = t.length;
    if (chain(t, t.retro).to!long <= k) ++r;
    if (chain(t, t[0..$-1].retro).to!long <= k) ++r;
  }

  writeln(r);
}
