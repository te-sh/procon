import std.algorithm, std.conv, std.range, std.stdio, std.string;

const ma = 1000000;

version(unittest) {} else
void main()
{
  auto imos = new int[](ma+1);

  auto n = readln.chomp.to!size_t;
  foreach (_; 0..n) {
    auto rd = readln.chomp.splitter;
    auto a = rd.front.to!int; rd.popFront();
    ++imos[a];
    auto b = rd.front.to!int;
    if (b < ma) --imos[b+1];
  }

  foreach (i; 1..ma+1) imos[i] += imos[i-1];

  writeln(imos.reduce!max);
}
