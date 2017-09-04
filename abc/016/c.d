import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];
  auto f = new size_t[][](n);
  foreach (_; 0..m) {
    auto rd2 = readln.split.to!(size_t[]), u = rd2[0]-1, v = rd2[1]-1;
    f[u] ~= v;
    f[v] ~= u;
  }

  foreach (i; 0..n) {
    auto ff = f.indexed(f[i]).joiner.array.sort().uniq.filter!(j => j != i && !f[i].canFind(j)).array;
    writeln(ff.length);
  }
}
