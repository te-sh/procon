import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1], d = rd1[2];

  auto u = new int[](n);
  foreach (i; 0..n) u[i] = i.to!int;

  auto ps = u.dup, rd2 = readln.chomp.splitter;
  foreach (_; 0..m) {
    auto i = rd2.front.to!int; rd2.popFront();
    swap(ps[i-1], ps[i]);
  }

  auto p = new int[](n);
  foreach (i; 0..n) p[ps[i]] = i.to!int;

  auto r = repeatedSquare!(int[], mulPermutation, size_t)(p, d, u);
  foreach (ri; r) writeln(ri+1);
}

auto mulPermutation(int[] p1, int[] p2)
{
  auto n = p1.length;
  auto r = new int[](n);
  foreach (i; 0..n) r[i] = p2[p1[i]];
  return r;
}

T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T init)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  auto r = init;
  while (n > 0) {
    if ((n & 1) == 1)
      r = predFun(r, a);
    a = predFun(a, a);
    n >>= 1;
  }

  return r;
}
