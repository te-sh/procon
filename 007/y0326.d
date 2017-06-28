import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto k = readln.chomp.to!size_t;

  auto b = n.iota.array;

  foreach (_; 0..k) {
    auto rd = readln.split.to!(size_t[]).map!"a-1".array, x = rd[0], y = rd[1];
    swap(b[x], b[y]);
  }

  auto a = readln.split.to!(size_t[]).map!"a-1".array;
  size_t[] r;

  foreach (i; 0..n-1) {
    auto j = b.countUntil(a.countUntil(i));
    foreach_reverse (s; i..j) {
      r ~= s;
      swap(b[s], b[s+1]);
    }
  }

  writeln(r.length);
  foreach (ri; r)
    writeln(ri+1, " ", ri+2);
}
