import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto a = readln.split.to!(int[]);

  foreach (i; 1..2*n-3)
    foreach (p; 0..n) {
      auto q = i-p;
      if (q < p || q >= n) continue;
      if (a[p] > a[q]) swap(a[p], a[q]);
    }

  foreach (i; 0..n) {
    write(a[i]);
    if (i < n-1) write(" ");
  }
  writeln;
}
