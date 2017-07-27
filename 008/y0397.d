import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  size_t[][] r;
  foreach (i; 0..n) {
    auto j = a[i..$].minIndex + i;
    if (i != j) {
      swap(a[i], a[j]);
      r ~= [i, j];
    }
  }

  writeln(r.length);
  foreach (ri; r)
    writeln(ri[0], " ", ri[1]);
  stdout.flush();

  readln;
}
