import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), pa = rd[0], pb = rd[1];
  auto pa2 = pa * 2, pb2 = pb * 2;

  foreach (s; 0..1000)
    foreach (a; 0..s+1) {
      auto b = s - a;
      auto a200 = a * 200, b200 = b * 200;
      if (s * (pa2 - 1) <= a200 && a200 < s * (pa2 + 1) &&
          s * (pb2 - 1) <= b200 && b200 < s * (pb2 + 1)) {
        writeln(s);
        return;
      }
    }
}
