import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto vi = readln.split.to!(int[]);

  auto dpv = new int[](n+1);
  dpv[1] = vi[0];
  auto dpi = new size_t[][](n+1);
  dpi[1] = [0];

  foreach (i; 2..n+1) {
    if (dpv[i-1] <= dpv[i-2] + vi[i-1]) {
      dpv[i] = dpv[i-2] + vi[i-1];
      dpi[i] = dpi[i-2] ~ (i-1);
    } else {
      dpv[i] = dpv[i-1];
      dpi[i] = dpi[i-1];
    }
  }

  writeln(dpv[$-1]);
  writeln(dpi[$-1].map!"a + 1".array.to!(string[]).join(" "));
}
