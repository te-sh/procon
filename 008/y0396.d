import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], m = rd1[1];
  auto rd2 = readln.split.to!(int[]), x = rd2[0], y = rd2[1];

  auto cls(int z)
  {
    auto k = (z-1) % (m*2);
    return k < m ? k+1 : m*2-k;
  }

  writeln(cls(x) == cls(y) ? "YES" : "NO");
}
