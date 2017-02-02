import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), aw = rd1[0], ab = rd1[1];
  auto rd2 = readln.split.to!(int[]), bw = rd2[0], bb = rd2[1];
  auto rd3 = readln.split.to!(int[]), c = rd3[0], d = rd3[1];

  auto cb = min(ab, c), cw = c - cb;
  aw -= cw; ab -= cb; bw += cw; bb += cb;

  auto dw = min(bw, d), db = d - dw;
  bw -= dw; bb -= db; aw += dw; ab += db;

  writeln(aw);
}
