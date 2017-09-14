import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], q = rd1[1];
  auto b = new int[](n);
  foreach (_; 0..q) {
    auto rd2 = readln.split.to!(size_t[]), l = rd2[0]-1, r = rd2[1]-1;
    ++b[l];
    if (r < n-1) --b[r+1];
  }
  foreach (i; 1..n) b[i] += b[i-1];
  foreach (i; 0..n) write(b[i] % 2 == 0 ? 0 : 1);
  writeln;
}
