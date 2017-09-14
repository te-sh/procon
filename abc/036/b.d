import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = new string[](n);
  foreach (i; 0..n) s[i] = readln.chomp;

  foreach (i; 0..n) {
    foreach (j; 0..n)
      write(s[n-j-1][i]);
    writeln;
  }
}
