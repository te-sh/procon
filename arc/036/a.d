import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1];
  auto t = new int[](n);
  foreach (i; 0..n) t[i] = readln.chomp.to!int;

  foreach (i; 2..n)
    if (t[i-2]+t[i-1]+t[i] < k) {
      writeln(i+1);
      return;
    }

  writeln(-1);
}
