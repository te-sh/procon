import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto gi = n.iota.map!(_ => readln.chomp.until("#")).join;

  auto ai = gi.enumerate.map!(g => g[1] == '-' ? g[0] : size_t.max).filter!(i => i < size_t.max).array;
  auto r = n;
  foreach (i; (1 << ai.length).iota) {
    auto bi = gi.dup;
    foreach (j, a; ai)
      bi[a] = bitTest(i, j) ? 'o' : 'x';
    r = min(r, calc(n, bi));
  }

  writeln(r);
}

auto calc(size_t n, dchar[] bi)
{
  auto wi = n.iota.map!(i => n.iota.map!(j => result(bi, i, j)).count(true)).array;
  auto w0 = wi[0];
  auto ri = wi.sort!"a > b".uniq;
  return ri.countUntil(w0) + 1;
}

bool result(dchar[] bi, size_t p1, size_t p2)
{
  if (p1 == p2)
    return false;
  else if (p1 > p2)
    return !result(bi, p2, p1);
  else
    return bi[(p2 - 1) * p2 / 2 + p1] == 'x';
}

bool bitTest(T)(T n, size_t i) { return (n & (1.to!T << i)) != 0; }
