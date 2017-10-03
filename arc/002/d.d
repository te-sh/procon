import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.regex;     // RegEx

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), h = rd[0], w = rd[1];
  auto c = new string[](h);
  foreach (i; 0..h) c[i] = readln.chomp;

  if (checkDive(c)) return;
  
  auto r = ctRegex!(`(o(?:o|\.)*o|o)(\.+)(x(?:x|\.)*x|x)`), s = 0L;
  long[] t;

  foreach (ci; c) {
    auto m = ci.matchAll(r);
    foreach (mi; m) {
      auto c1 = mi[1].count('o').to!long, c2 = mi[3].count('x').to!long;
      auto cd = mi[2].length.to!long - 1;
      s += calcMovable(mi[1], false) + c1 * cd;
      s -= calcMovable(mi[3], true)  + c2 * cd;
      if (cd % 2 == 1) t ~= c1+c2-2;
    }
  }

  if (!t.empty) {
    t.sort!"a > b";
    foreach (i, ti; t) s += ti * (i % 2 ? -1 : 1);
  }

  writeln(t.length % 2 == 0 && s > 0 || t.length % 2 == 1 && s >= 0 ? "o" : "x");
}

auto calcMovable(R)(R s, bool rev)
{
  auto t = 0L, r = 0L;

  auto parse(char c)
  {
    if (c == '.') r += t;
    else ++t;
  }

  if (rev)
    foreach_reverse (c; s) parse(c);
  else
    foreach (c; s) parse(c);

  return r;
}

auto dr1 = ctRegex!(`o\.+$`), dr2 = ctRegex!(`^\.+x`);

auto checkDive(string[] c)
{
  import core.stdc.stdlib;

  auto a1 = int.max, a2 = int.max;
  foreach (ci; c) {
    auto m1 = ci.matchFirst(dr1), m2 = ci.matchFirst(dr2);
    if (!m1.empty) a1 = min(a1, m1[0].length);
    if (!m2.empty) a2 = min(a2, m2[0].length);
  }

  if (a1 == int.max && a2 == int.max) return false;

  writeln(a1 <= a2 ? "o" : "x");
  return true;
}
